/// xf_read_xml(string)
// Reads the given xml string and returns the root node.
// See: www.xmlfir.com/xf-read-xml


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    var t_eof = string_byte_length(argument0);
    
    // Write string to buffer
    var t_buff = buffer_create(t_eof, buffer_fixed, 1);
    buffer_seek(t_buff, buffer_seek_start, 0);
    buffer_write(t_buff, buffer_text, argument0);
    buffer_seek(t_buff, buffer_seek_start, 0);
    
    // Double buffering?
    if (cfg_read_xml_double_buffer) {
        var t_peek = buffer_create(t_eof, buffer_fast, 1);
        buffer_copy(t_buff, 0, t_eof, t_peek, 0);
    }
    else {
        t_peek = t_buff;
    }
    
    // Trim source string?
    var t_pos  = 0;
    
    if (cfg_read_xml_trim_source) {
        // Left trim
        while (t_pos < t_eof) {
            if (buffer_peek(t_peek, t_pos, buffer_u8) > 32) break;
            t_pos++;
        }
        
        // Right trim
        var t_end = t_eof;
        
        while (t_end - 1 > t_pos) {
            if (buffer_peek(t_peek, t_end - 1, buffer_u8) > 32) break;
            t_end--;
        }
        
        t_eof = t_end;
    }
    
    
    /**
    * Start Parsing
    * =============
    */
    // Main loop vars
    var t_node  = -1;
    var t_nodes = -1;
    var t_byte  = 0;
    var t_depth = 0;
    var t_error = false;
    var t_data  = ds_list_create();
    
    var t_nodes_i       = -1;
    var t_parent_id     = noone;
    var t_parent_length = 0;
    var t_parent_byte   = 0;
    var t_parent_ids    = ds_list_create();
    var t_parent_bytes  = ds_list_create();
    
    // New tag vars
    var t_otag_name_string = "";
    var t_otag_name_length = 0;
    var t_otag_name_bytes  = 0;
    var t_otag_pos_end     = 0;
    var t_otag_close       = 0;
    var t_otag_off         = 0;
    var t_otag_attribs_k   = -1;
    var t_otag_attribs_v   = -1;
    var t_otag_attr_start  = 0;
    var t_otag_attr_k      = "";
    var t_otag_attr_v      = "";
    var t_otag_attr_s      = 0;
    var t_otag_attr_q      = 0;
    var t_otag_attr_i      = 0;
    var t_otag_attr_klen   = 0;
    var t_otag_attr_vlen   = 0;
    var t_otag_attr_test   = "";
    var t_otag_attr_neg    = "";
    
    // Closing tag vars
    var t_ctag_i = 0;
    
    // PI vars
    var t_pi_start = 0;
    
    // Text vars
    var t_txt_str     = "";
    var t_txt_pos_end = 0;
    var t_txt_start   = 0;
    var t_txt_end     = 0;
    var t_txt_break   = 0;
    
    // Comment vars
    var t_com_str     = "";
    var t_com_pos_end = 0;

    
    /**
    * Big loop
    * ========
    * + If char is not <
    * [
    *     + Parse text
    * ]
    * + If char is <
    * [
    *    + If next char is not /,!,?
    *    [
    *        + Parse tag name
    *        + Parse tag attributes
    *    ]
    *    + If next char is /
    *    [
    *        + Parse closing tag
    *    ]
    *    + If next char is !
    *    [
    *        + Is comment?
    *        [
    *            + Parse comment
    *        ]
    *        + Is cdata?
    *        [
    *            + Parse cdata
    *        ]
    *    ]
    *    + If next char is ?
    *    [
    *        + Parse PI
    *    ]
    * ]
    */
    
    // Add depth 0 nodes
    ds_list_add(t_data, -1);
    
    while (t_pos < t_eof)
    {
        // Reset loop vars
        t_node = -1;
        
        /*
        * Text node
        * =========
        */
        if (buffer_peek(t_peek, t_pos, buffer_u8) != 60) 
        {
            t_txt_pos_end = t_pos;
            t_txt_break   = 0;
            
            // Find the end of the text node by looking for <
            while (t_txt_pos_end != t_eof)
            {
                if (buffer_peek(t_peek, t_txt_pos_end, buffer_u8) == 60) break;
                t_txt_pos_end++;
            }
            
            // Check EOF
            if (t_txt_pos_end == t_eof) {
                // ERROR: Unexpected end of string
                t_error = xf_log(true, xf_read_xml, 1, 
                    'Unexpected end of string near pos ' + string(t_pos) + '. Expected text node.'
                );
                break;
            }
            
            t_txt_start = t_pos;
            t_txt_end   = t_txt_pos_end;
            
            // Trim text and/or discard empty text?
            if (cfg_read_xml_trim_content || cfg_read_xml_discard_empty) {
                // Left trim
                while (t_txt_start < t_txt_pos_end)
                {
                    // Break if not white space
                    if (buffer_peek(t_peek, t_txt_start, buffer_u8) > 32) break;
                    t_txt_start++;
                }
                
                // Right trim
                while (t_txt_end - 1 > t_txt_start)
                {
                    // Break if not white space
                    if (buffer_peek(t_peek, t_txt_end - 1, buffer_u8) > 32) break;
                    t_txt_end--;
                }
                
                // Deal with empty text node
                if (t_txt_start == t_txt_end) {
                    if (cfg_read_xml_discard_empty) {
                        // Discard it
                        t_pos = t_txt_pos_end;
                        t_txt_break = 1;
                    }
                    // Keep empty string and do nothing
                }
                else {
                    // Reset start and end if trim is disabled
                    if (!cfg_read_xml_trim_content) {
                        t_txt_start = t_pos;
                        t_txt_end   = t_txt_pos_end;
                    }
                    
                    // Get substring
                    t_byte = buffer_peek(t_buff, t_txt_end, buffer_u8);
                    
                    buffer_poke(t_buff, t_txt_end, buffer_u8, 0);
                    buffer_seek(t_buff, buffer_seek_start, t_txt_start);
                    t_txt_str = buffer_read(t_buff, buffer_string);
                    
                    buffer_poke(t_buff, t_txt_end, buffer_u8, t_byte);
                }
            }
            else {
                // Get string
                t_byte = buffer_peek(t_buff, t_txt_end, buffer_u8);
                    
                buffer_poke(t_buff, t_txt_end, buffer_u8, 0);
                buffer_seek(t_buff, buffer_seek_start, t_txt_start);
                t_txt_str = buffer_read(t_buff, buffer_string);
                
                buffer_poke(t_buff, t_txt_end, buffer_u8, t_byte);
            }
            
            if (t_txt_break == 0) {
                // Decode entities?
                if (cfg_read_xml_entities_decode) {
                    if (string_pos("&", t_txt_str)) {
                        if (string_pos("&gt;", t_txt_str))   t_txt_str = string_replace_all(t_txt_str, "&gt;", ">");
                        if (string_pos("&lt;", t_txt_str))   t_txt_str = string_replace_all(t_txt_str, "&lt;", "<");
                        if (string_pos("&quot;", t_txt_str)) t_txt_str = string_replace_all(t_txt_str, "&quot;", '"');
                        if (string_pos("&apos;", t_txt_str)) t_txt_str = string_replace_all(t_txt_str, "&apos;", "'");
                    }
                }
                
                // Create text node
                t_nodes_i++;
                t_node = ds_list_create();
                ds_list_add(t_node, xf_type_text, t_txt_str, t_parent_id, -1, -1, -1, noone);
                t_txt_str = "";
                
                // Store node
                if (t_nodes == -1) {
                    t_nodes = ds_list_create();
                    ds_list_replace(t_data, t_depth, t_nodes);
                }
                        
                ds_list_add(t_nodes, t_node);
                ds_list_mark_as_list(t_nodes, t_nodes_i);
                
                // Advance to next char
                t_pos = t_txt_pos_end;
            }
        }
        
        
        // Go to next char
        t_pos++;
        t_byte = buffer_peek(t_peek, t_pos, buffer_u8);

        /*
        * Parse new tag
        * =============
        */
        if (t_byte > 64) 
        {
            // Search the end of the tag
            t_otag_pos_end = t_pos;
            
            while (t_otag_pos_end < t_eof)
            {
                if (buffer_peek(t_peek, t_otag_pos_end, buffer_u8) == 62) break;
                t_otag_pos_end++;
            }
            
            // Check EOF
            if (t_otag_pos_end > t_eof) {
                xf_log(xf_read_xml, 1, 'Unexpected end of string near pos ' + string(t_pos) + '. Expected tag name.');
                t_error = true;
                break;
            }
            
            // Get the length of the tag name
            t_otag_name_length = t_pos;
            
            while (t_otag_name_length < t_otag_pos_end)
            {
                t_byte = buffer_peek(t_peek, t_otag_name_length, buffer_u8);
                
                // Break on white space or /
                if (t_byte < 33 || t_byte == 47) break;
                t_otag_name_length++;
            }
            
            if (t_otag_name_length == t_pos) {
                xf_log(xf_read_xml, 1, 'Unexpected end of string near pos ' + string(t_pos) + '. Expected tag name.');
                t_error = true;
                break;
            }
            
            // Get the tag name
            buffer_poke(t_buff, t_otag_name_length, buffer_u8, 0);
            buffer_seek(t_buff, buffer_seek_start, t_pos);
            t_otag_name_string = buffer_read(t_buff, buffer_string);

            buffer_poke(t_buff, t_otag_name_length, buffer_u8, t_byte);
            
            // Set the string length of the name
            t_otag_name_length = (t_otag_name_length - t_pos);

            // Check if this tag is self-closing
            if (buffer_peek(t_peek, t_otag_pos_end - 1, buffer_u8) == 47) {
                t_otag_close = 1;
                t_otag_pos_end--;
            }
            else {
                t_otag_close = 0;
                t_otag_name_bytes = 0;
                
                // Get the tag name bytes - if tag is not self-closing
                t_otag_off = t_otag_name_length - 1;
                t_pos += t_otag_name_length - 1;
                
                while (t_otag_off > -1)
                {
                    t_otag_name_bytes[t_otag_off] = buffer_peek(t_peek, t_pos, buffer_u8);
                    t_otag_off--;
                    t_pos--;
                }
            }

            // Advance to next character
            t_pos += t_otag_name_length + 1;
            
            // Skip white space
            while (t_pos < t_otag_pos_end)
            {
                if (buffer_peek(t_peek, t_pos, buffer_u8) > 32) break;
                t_pos++;
            }

            // Get tag attributes
            if (t_pos < t_otag_pos_end) {
                t_otag_attr_s    = 0;
                t_otag_attr_k    = "";
                t_otag_attr_v    = "";
                t_otag_attr_klen = 0;
                t_otag_attr_start = t_pos;
                
                t_otag_attribs_k = ds_list_create();
                t_otag_attribs_v = ds_list_create();
                
                while (t_pos < t_otag_pos_end)
                {
                    // Stage 1: Parse attribute key
                    t_byte = buffer_peek(t_peek, t_pos, buffer_u8);
                    
                    if (t_byte > 33) {
                        if (t_byte != 61) {
                            t_otag_attr_klen++;
                            t_pos++;
                            continue;
                        }
                        
                        if (t_otag_attr_klen > 0) {
                            // Get the attribute name
                            buffer_poke(t_buff, t_otag_attr_start + t_otag_attr_klen, buffer_u8, 0);
                            buffer_seek(t_buff, buffer_seek_start, t_otag_attr_start);
                            t_otag_attr_k = buffer_read(t_buff, buffer_string);

                            // Go to stage 2
                            t_otag_attr_s = 2;
                            t_pos++;
                        }
                        else {
                            xf_log(xf_read_xml, 1, 'Unexpected character at pos ' + string(t_pos) + '. Expected attribute key.');
                            t_otag_attr_s = -1;
                            t_pos = t_otag_pos_end;
                            break;
                        }
                    }
                    else {
                        xf_log(xf_read_xml, 1, 'Unexpected white space at pos ' + string(t_pos) + '. Expected attribute key or =.');
                        t_otag_attr_s = -1;
                        t_pos = t_otag_pos_end;
                        break;
                    }

                    // Check eof
                    if (t_pos >= t_otag_pos_end) break;
                    
                    // Stage 2: Find value opening quote
                    t_byte = buffer_peek(t_peek, t_pos, buffer_u8);
                    
                    if (t_byte != 39 && t_byte != 34) {
                        xf_log(xf_read_xml, 1, 'Unexpected character at pos ' + string(t_pos) + '. Expected quote.');
                        t_otag_attr_s = -1;
                        t_pos = t_otag_pos_end;
                        break;
                    }
                    else {
                        t_otag_attr_q = t_byte;
                        t_otag_attr_s = 2;
                        t_pos++;
                    }
                    
                    // Stage 3: Parse attribute value
                    t_otag_attr_start = t_pos;
                    
                    while (t_pos < t_otag_pos_end)
                    {
                        if (buffer_peek(t_peek, t_pos, buffer_u8) == t_otag_attr_q) break;

                        t_pos++;
                    }
                    
                    // Check eof
                    if (t_pos >= t_otag_pos_end) break;


                    // Get value string
                    buffer_poke(t_buff, t_otag_attr_start + (t_pos - t_otag_attr_start), buffer_u8, 0);
                    buffer_seek(t_buff, buffer_seek_start, t_otag_attr_start);
                    t_otag_attr_v = buffer_read(t_buff, buffer_string);
                    
                    // Cast value?
                    if (cfg_read_xml_att_cast) {
                        t_otag_attr_vlen = string_length(t_otag_attr_v);
                        
                        if (t_otag_attr_vlen == 5) {
                            // Is False?
                            if (string_lower(t_otag_attr_v) == "false") {
                                t_otag_attr_v = false;
                            }
                        }
                        else if (t_otag_attr_vlen == 4) {
                            // Is True?
                            if (string_lower(t_otag_attr_v) == "true") {
                                t_otag_attr_v = true;
                            }
                        }
                        
                        if (is_string(t_otag_attr_v)) {
                            // Is Real?
                            t_otag_attr_test = "";
                            t_otag_attr_neg  = "";
                            
                            t_byte = buffer_peek(t_peek, t_otag_attr_start, buffer_u8);
                            
                            if (t_byte == 45) {
                                t_otag_attr_neg = "-";
                                t_otag_attr_start++;
                            }
                            
                            while (t_otag_attr_start < t_pos)
                            {
                                t_byte = buffer_peek(t_peek, t_otag_attr_start, buffer_u8);
                                
                                if (t_byte == 46 || (t_byte >= 48 && t_byte <= 57)) {
                                    t_otag_attr_test += chr(t_byte);
                                    t_otag_attr_start++;
                                    continue;
                                }
                                
                                break;
                            }
                            
                            // Test
                            if (string_length(t_otag_attr_neg + t_otag_attr_test) == t_otag_attr_vlen) {
                                t_otag_attr_v = real(t_otag_attr_v);
                            }
                        }
                    }

                    // Reached end of value, store the attribute
                    t_otag_attr_i = ds_list_find_index(t_otag_attribs_k, t_otag_attr_k);
                    
                    // Decode entities?
                    if (is_string(t_otag_attr_v) && cfg_read_xml_entities_decode) {
                        if (string_pos("&", t_otag_attr_v)) {
                            if (string_pos("&gt;", t_otag_attr_v))   t_otag_attr_v = string_replace_all(t_otag_attr_v, "&gt;", ">");
                            if (string_pos("&lt;", t_otag_attr_v))   t_otag_attr_v = string_replace_all(t_otag_attr_v, "&lt;", "<");
                            if (string_pos("&quot;", t_otag_attr_v)) t_otag_attr_v = string_replace_all(t_otag_attr_v, "&quot;", '"');
                            if (string_pos("&apos;", t_otag_attr_v)) t_otag_attr_v = string_replace_all(t_otag_attr_v, "&apos;", "'");
                        }
                    }
                    
                    if (t_otag_attr_i > -1) {
                        // Replace existing
                        ds_list_replace(t_otag_attribs_v, t_otag_attr_i, t_otag_attr_v);
                    }
                    else {
                        // Add new
                        ds_list_add(t_otag_attribs_k, t_otag_attr_k);
                        ds_list_add(t_otag_attribs_v, t_otag_attr_v);
                    }
                    
                    // Reset attribute data
                    t_otag_attr_s = 0;
                    t_otag_attr_k = "";
                    t_otag_attr_v = "";
                    t_otag_attr_klen = 0;
                    t_pos++;
                    
                    // Skip white space
                    while (t_pos < t_otag_pos_end)
                    {
                        if (buffer_peek(t_peek, t_pos, buffer_u8) > 32) break;
                        t_pos++;
                    }

                    t_otag_attr_start = t_pos;
                }
                
                // Check for attribute parsing error
                if (t_otag_attr_s == -1 || t_otag_attr_klen > 0) {
                    xf_log(xf_read_xml, 1, 'Failed to parse attributes near pos ' + string(t_pos));
                    
                    // Clean-up attribute data
                    if (t_otag_attribs_k > -1) {
                        ds_list_destroy(t_otag_attribs_k);
                        ds_list_destroy(t_otag_attribs_v);
                        
                        t_error = true;
                        break;
                    }
                }
            }
            else {
                // This element has no attributes
                t_otag_attribs_k = -1;
                t_otag_attribs_v = -1;
            }
            
            // Create new element node
            t_nodes_i++;
            t_node = ds_list_create();
            ds_list_add(t_node, xf_type_element, t_otag_name_string, t_parent_id, -1, t_otag_attribs_k, t_otag_attribs_v, noone);
            
            // Save node attributes
            if (t_otag_attribs_k > -1) {
                ds_list_mark_as_list(t_node, xf_prop_attrk);
                ds_list_mark_as_list(t_node, xf_prop_attrv);
            }
            
            // Store node
            if (t_nodes == -1) {
                t_nodes = ds_list_create();
                ds_list_replace(t_data, t_depth, t_nodes);
            }
            
            ds_list_add(t_nodes, t_node);
            ds_list_mark_as_list(t_nodes, t_nodes_i);
            
            // Skip the rest of the code if self-closing tag
            if (t_otag_close) {
                t_pos += 2;
                continue;
            }
            
            // Set new type
            ds_list_replace(t_node, xf_prop_type, xf_type_element);
            
            // Store node in parent list
            ds_list_add(t_parent_ids,   t_node);
            ds_list_add(t_parent_bytes, t_otag_name_bytes);
            
            // Set as current parent node
            t_parent_id     = t_node;
            t_parent_length = t_otag_name_length;
            t_parent_byte   = t_otag_name_bytes;

            // Increase depth
            ds_list_add(t_data, -1);
            t_nodes   = -1;
            t_nodes_i = -1;
            t_depth++;
            
            // Go to next char
            t_pos++;
        
            // Peek ahead, and see if we can keep in the loop
            if (t_pos + 1 < t_eof) {
                if (buffer_peek(t_peek, t_pos, buffer_u8) == 60) {
                    t_byte = buffer_peek(t_peek, t_pos + 1, buffer_u8);
                    
                    if (t_byte == 47 || t_byte == 33 || t_byte == 63) {
                        // Its either a closing tag, comment, cdata or pi node
                        t_pos++;
                    }
                    else {
                        // New tag, must loop again
                        continue;
                    }
                }
                else {
                    // Text node, must loop again
                    continue;
                }
            }
            else {
                continue;
            }
        }
        
        
        /*
        * Parse closing tag
        * =================
        */
        if (t_byte == 47) 
        {
            // Check eof
            if ((t_pos + t_parent_length) >= t_eof) {
                xf_log(xf_read_xml, 1, 
                    'Unexpected end of string near pos ' + string(t_pos) + '. Expected closing tag.'
                );
                t_error = true;
                break;
            }
            
            // Advance one char
            t_pos++;

            // Compare closing tag name against open tag name
            t_ctag_i = 0;
            
            while (t_ctag_i < (t_parent_length - 1))
            {
                if (buffer_peek(t_peek, t_pos + t_ctag_i, buffer_u8) != t_parent_byte[t_ctag_i]) {
                    t_error = true;
                    break;
                }
                
                t_ctag_i++;
            }
            
            if (t_error) {
                xf_log(xf_read_xml, 1, 'Closing tag mismatch at pos ' + string(t_pos));
                break;
            }
            
            // Advance the length of the tag name
            t_pos += t_parent_length;

            // Look for end of closing tag
            if (buffer_peek(t_peek, t_pos, buffer_u8) != 62) {
                xf_log(xf_read_xml, 1, 'Unexpected character at pos ' + string(t_pos) + '. Expected ">".');
                t_error = true;
                break;
            }
            
            // Append nodes to current parent node
            if (t_nodes > -1) {
                ds_list_replace(t_parent_id, xf_prop_children, t_nodes);
                ds_list_mark_as_list(t_parent_id, xf_prop_children);
            }
            
            // Go up 1 level in the tree
            ds_list_delete(t_data, t_depth);
            t_parent_byte = 0;
            t_depth--;
            
            ds_list_delete(t_parent_ids,   t_depth);
            ds_list_delete(t_parent_bytes, t_depth);
            
            // Set the new parent and nodes
            t_nodes = ds_list_find_value(t_data, t_depth);
            
            if (t_nodes > -1) {
                t_nodes_i = ds_list_size(t_nodes) - 1;
            }
            else {
                t_nodes_i = -1;
            }
            
            if (t_depth) {
                t_parent_id     = ds_list_find_value(t_parent_ids,   t_depth - 1);
                t_parent_byte   = ds_list_find_value(t_parent_bytes, t_depth - 1);
                t_parent_length = array_length_1d(t_parent_byte);
            }
            else {
                t_parent_id     = noone;
                t_parent_byte   = 0;
                t_parent_length = 0;
            }
            
            // Advance to next char
            t_pos++;
            continue;
        }
        
        
        /*
        * Parse comment or cdata
        * ======================
        */
        if (t_byte == 33) 
        {
            // Check eof
            if (t_pos + 5 >= t_eof) {
                xf_log(xf_read_xml, 1, 
                    'Unexpected end of string near pos ' + string(t_pos) + '. Expected comment or cdata.'
                );
                t_error = true;
                break;
            }
            
            // Look for regular comment (<!--...-->)
            if (buffer_peek(t_peek, t_pos + 1, buffer_u8) == 45 && buffer_peek(t_peek, t_pos + 2, buffer_u8) == 45) 
            {
                // Advance to next char
                t_pos += 3;
                t_com_pos_end = t_pos;
                
                // Find the end of comment
                while (t_com_pos_end + 2 < t_eof)
                {
                    // Look for -->
                    if (buffer_peek(t_peek, t_com_pos_end, buffer_u8) == 45 
                    && buffer_peek(t_peek, t_com_pos_end + 1, buffer_u8) == 45 
                    && buffer_peek(t_peek, t_com_pos_end + 2, buffer_u8) == 62) {
                        break;
                    }
                    
                    t_com_pos_end++;
                }
                
                // Check eof
                if (t_com_pos_end + 3 > t_eof) {
                    xf_log(xf_read_xml, 1, 
                        'Unexpected end of string near pos ' + string(t_pos) + '. Expected end of comment.'
                    );
                    t_error = true;
                    break;
                }
                
                if (cfg_read_xml_discard_comment) {
                    // Discard the comment
                    t_pos = t_com_pos_end + 3;
                    continue;
                }
                
                // Get the comment string
                t_byte = buffer_peek(t_buff, t_com_pos_end, buffer_u8);
                    
                buffer_poke(t_buff, t_com_pos_end, buffer_u8, 0);
                buffer_seek(t_buff, buffer_seek_start, t_pos);
                t_com_str = buffer_read(t_buff, buffer_string);
                
                buffer_poke(t_buff, t_com_pos_end, buffer_u8, t_byte);
                
                t_pos = t_com_pos_end;
                    
                // Create node
                t_nodes_i++;
                t_node = ds_list_create();
                ds_list_add(t_node, xf_type_comment, t_com_str, t_parent_id, -1, -1, -1, noone);
                t_com_str = "";

                // Store node
                if (t_nodes == -1) {
                    t_nodes = ds_list_create();
                    ds_list_replace(t_data, t_depth, t_nodes);
                }
                        
                ds_list_add(t_nodes, t_node);
                ds_list_mark_as_list(t_nodes, t_nodes_i);
                
                t_pos += 3;
                continue;
            }
            
            // Look for cdata "[CDATA[..]]>"
            if (t_pos + 10 < t_eof) {
                if (buffer_peek(t_peek, t_pos + 1, buffer_u8) == 91 && buffer_peek(t_peek, t_pos + 7, buffer_u8) == 91) 
                {
                    t_pos += 8;
                    t_com_pos_end = t_pos;
                    
                    // Find the end of cdata
                    while (t_com_pos_end + 2 < t_eof)
                    {
                        // Look for ]]>
                        if (buffer_peek(t_peek, t_com_pos_end, buffer_u8) == 93 
                        && buffer_peek(t_peek, t_com_pos_end + 1, buffer_u8) == 93 
                        && buffer_peek(t_peek, t_com_pos_end + 2, buffer_u8) == 62) {
                            break;
                        }
                        
                        t_com_pos_end++;
                    }
                    
                    // Check eof
                    if (t_com_pos_end + 3 > t_eof) {
                        xf_log(xf_read_xml, 1, 
                            'Unexpected end of string near pos ' + string(t_pos) + '. Expected end of cdata.'
                        );
                        t_error = true;
                        break;
                    }
                    
                    // Get the cdata string
                    t_byte = buffer_peek(t_buff, t_com_pos_end, buffer_u8);
                    
                    buffer_poke(t_buff, t_com_pos_end, buffer_u8, 0);
                    buffer_seek(t_buff, buffer_seek_start, t_pos);
                    t_com_str = buffer_read(t_buff, buffer_string);
                    
                    buffer_poke(t_buff, t_com_pos_end, buffer_u8, t_byte);
                    
                    t_pos = t_com_pos_end;
                
                    // Create node
                    t_nodes_i++;
                    t_node = ds_list_create();
                    ds_list_add(t_node, xf_type_cdata, t_com_str, t_parent_id, -1, -1, -1, noone);
                    t_com_str = "";
    
                    // Store node
                    if (t_nodes == -1) {
                        t_nodes = ds_list_create();
                        ds_list_replace(t_data, t_depth, t_nodes);
                    }
                            
                    ds_list_add(t_nodes, t_node);
                    ds_list_mark_as_list(t_nodes, t_nodes_i);
                    
                    t_pos += 3;
                    continue;
                }
            }
            
            // This may be a doctype declaration, ignore it...
            t_pos++;
            
            while (t_pos < t_eof)
            {
                // Look for >, then break out
                if (buffer_peek(t_peek, t_pos, buffer_u8) == 62) break;
                t_pos++;
            }
            
            continue;
        }
        
        
        /*
        * Parse PI
        * ========
        */
        if (t_byte == 63) 
        {
            // Not supported, just look for closing tag and ignore.
            t_pi_start = t_pos;
            
            while (t_pos < t_eof)
            {   
                if (buffer_peek(t_peek, t_pos, buffer_u8) == 62) break;
                t_pos++;
            }
            
            // Check eof
            if (t_pos >= t_eof) {
                xf_log(xf_read_xml, 1, 
                    'Unexpected end of string near pos ' + string(t_pi_start) + '. Expected PI node.'
                );
                t_error = true;
                break;
            }
            
            // Advance one char
            t_pos++;
            continue;
        }
        
        // This actually should never happen
        xf_log(xf_read_xml, 1, 
            'Unexpected character near pos ' + string(t_pos) + '. Expected new element.'
        );
        t_error = true;
        break;
    }
    // End of loop.
    // ============
    
    // Get the resulting data tree
    var t_result = -1;
    
    if (t_error == false && ds_list_empty(t_data) == false) {
        t_result = ds_list_find_value(t_data, 0);
        ds_list_delete(t_data, 0);
        
        // Clear error
        p_error = "";
    }
    
    // Clean-up
    // Destroy parent list
    ds_list_destroy(t_parent_ids);
    
    // Delete data tree left-overs
    var t_list = -1;
    while (!ds_list_empty(t_data))
    {
        t_list = ds_list_find_value(t_data, 0);
        
        if (ds_exists(t_list, ds_type_list)) {
            ds_list_destroy(t_list);
            
        }
        
        ds_list_delete(t_data, 0);
    }
    ds_list_destroy(t_data);
    
    // Delete name bytes list
    t_byte = 0;
    while (!ds_list_empty(t_parent_bytes))
    {
        t_byte = ds_list_find_value(t_parent_bytes, 0);
        t_byte = 0;
        
        ds_list_delete(t_parent_bytes, 0);
    }
    ds_list_destroy(t_parent_bytes);
    
    // Delete buffers
    buffer_delete(t_buff);
    
    if (t_peek != t_buff) {
        buffer_delete(t_peek);
    }
    
    // Lets see what we got...
    if (ds_exists(t_result, ds_type_list)) {
        if (ds_list_size(t_result) == 0) {
            // XML string was empty
            ds_list_destroy(t_result);
            t_result = -1;
        }
        else if (ds_list_size(t_result) == 1) {
            // Unwrap root element
            var t_node = ds_list_find_value(t_result, 0);
            ds_list_replace(t_result, 0, -1);
            ds_list_destroy(t_result);
            t_result = t_node;
        }
        else {
            var t_node = ds_list_create();
            ds_list_add(t_node, xf_type_fragment, "", noone, t_result, -1, -1, noone);
            ds_list_mark_as_list(t_node, xf_prop_children);
            
            // Change parents
            var t_child = noone;
            var t_i = 0; 
            var t_c = ds_list_size(t_result);
            
            while (t_i < t_c)
            {
                t_child = ds_list_find_value(t_result, t_i);
                ds_list_replace(t_child, xf_prop_parent, t_node);
                t_i++;
            }
            
            t_result = t_node;
        }
    }
    
    if (ds_exists(t_result, ds_type_list)) {
        // Callback
        if (p_call_ev_create != noone) {
            script_execute(p_call_ev_create, xf_ev_create, t_result);
        }
    }
    
    return t_result;
}
