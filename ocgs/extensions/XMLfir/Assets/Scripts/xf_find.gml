/// xf_find(node,expression)
// Creates and returns a ds_list containing the nodes matching the given XPath expression.
// See: www.xmlfir.com/xf-find



// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Get node argument
    var t_node = argument0;
    
    // Try simple node validate
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(-1, xf_find, 1, "argument0 is not a valid xml node.");
    }
    
    // Validate string argument
    if (!is_string(argument1)) {
        return xf_log(-1, xf_find, 1, "argument1 must be a string.");
    }
    else if (string_length(argument1) == 0) {
        return xf_log(-1, xf_find, 1, "argument1 is empty.");
    }
    
    // Reset error
    p_error = "";
    
    // Write string to buffer
    var t_eof  = string_byte_length(argument1);
    var t_buff = buffer_create(t_eof, buffer_fixed, 1);
    
    buffer_seek(t_buff, buffer_seek_start, 0);
    buffer_write(t_buff, buffer_text, argument1);
    buffer_seek(t_buff, buffer_seek_start, 0);
    
    // Trim string
    var t_end = t_eof - 1;
    var t_pos = 0;
    
    while (t_pos < t_eof) {
        if (buffer_peek(t_buff, t_pos, buffer_u8) > 32) break;
        t_pos++;
    }
    
    while (t_end > t_pos) {
        if (buffer_peek(t_buff, t_end, buffer_u8) > 32) break;
        t_end--;
    }
    
    t_eof = t_end + 1;
    
    // Check eof
    if (t_pos >= t_eof) {
        buffer_delete(t_buff);
        return xf_log(-1, xf_find, 1, "argument1 is empty.");
    }
    
    
    // Setup vars
    var t_result   = ds_list_create();
    var t_filter   = noone;
    var t_parent   = noone;
    var t_children = -1;
    var t_count    = 0;
    var t_i        = 0;
    var t_byte1    = 0;
    var t_byte2    = 0;
    var t_axis     = 46;
    
    // Check if this an absolute path
    if (buffer_peek(t_buff, t_pos, buffer_u8) == 47) {
        // Absolute path
        t_node = xf_get_root(t_node);
        
        if (t_node == noone) {
            buffer_delete(t_buff);
            ds_list_destroy(t_result);
            return xf_log(-1, xf_find, 1, "argument0 root node not found.");
        }
        
        ds_list_add(t_result, t_node);
        t_pos++;
    }
    else {
        // Relative path
        ds_list_add(t_result, t_node);
    }
    
    // Loop vars 
    var t_error = false;
    var t_byte  = 0;
    var t_list  = 0;
    var t_count2 = 0;
    var t_j = 0;
    
    var t_item = 0;
    var t_attrib_keys = 0;
    var t_attrib_vals = 0;
    var t_result_attval = 0;
    var t_str_end = 0;
    var t_str = "";
    var t_idx = 0;
    var t_type = 0;
    var t_elname = "";
    var t_fnname = "";
    var t_fncmp  = -1;
    var t_eof_pred = 0;
    var t_pred = 0;
    var t_op_a = "";
    var t_op_b = "";
    var t_cmp = 0;
    var t_eval = 0;
    
    var t_operator = "";
    
    var t_str_special_chars = ds_list_create();

    ds_list_add(t_str_special_chars,
        91, 93, 40, 41, 47, 60, 61, 62, 33
    );
    
    var t_str_cmp_chars = ds_list_create();

    ds_list_add(t_str_cmp_chars,
        60, 61, 62, 33
    );
    
    /**
    * Begin main loop
    * ===============
    */
    while (t_pos < t_eof)
    {
        // Check for empty result
        if (ds_list_empty(t_result)) {
            break;
        }
        
        // Get current byte
        t_byte = buffer_peek(t_buff, t_pos, buffer_u8);

        
        /**
        * Handle white space
        * ==================
        */
        if (t_byte <= 32) 
        {
            // ignore it
            t_pos++;
            continue;
        }
        
        
        /**
        * Handle new step or axis
        * =======================
        */
        if (t_byte == 47) 
        {
            // Peek behind
            t_byte1 = 0;
            
            if (t_pos > 0) t_byte1 = buffer_peek(t_buff, t_pos - 1, buffer_u8);
            
            // Reset comparison vars
            t_op_a = "";
            t_op_b = "";
            t_cmp  = 0;
            
            // If the previous char was also "/", search in all descendants or self
            if (t_byte1 == 47) {
                t_axis = 47;
                
                t_pos++;
                continue;
            }
            
            // If predicate is open, do nothing
            if (t_pred) {
                t_axis = 0;
                t_pos++;
                continue;
            }
            
            // Start new step and reset vars
            if (t_axis == 92) {
                // If the previous axis was "..", then the new one is "."
                t_axis = 46;
            }
            else {
                t_axis = 0;
            }

            t_pos++;
            continue;
        }
        
        
        /**
        * Handle "." and ".."
        * ===================
        */
        if (t_byte == 46) 
        {
            // Peek ahead
            t_byte1 = 0;

            if (t_pos + 1 < t_eof) t_byte1 = buffer_peek(t_buff, t_pos + 1, buffer_u8);

            // Check the next char is also ".", select parent nodes
            if (t_byte1 == 46) {
                xf_query_parent(t_result);
                t_pos += 2;
                continue;
            }
            
            // Search in current set; do nothing
            t_pos++;
            continue;
        }
        
        /**
        * Handle "@" 
        * ==========
        */
        if (t_byte == 64) 
        {
            if (t_pred == 0) {
                t_error = xf_log(true, xf_find, 1, "Syntax not supported at pos " + string(t_pos) + '. "@" Must be in predicate.');
                break;
            }
            
            if (t_axis == 47) {
                // Select descendants and self
                xf_query_descendant(t_result, true);
            }

            // Search in node attributes
            t_axis = 64;
            t_pos++;
            continue;
        }
        
        
        /**
        * Handle "*"
        * ==========
        */
        if (t_byte == 42) 
        {
            if (t_axis == 64) {
                // Get elements having any number of attributes
                xf_query_attr_name(t_result, "!=", noone);
            }
            else if (t_axis == 46) {
                // Select all element nodes
                xf_query_type(t_result, "=", xf_type_element);
            }
            else if (t_axis == 47) {
                // Select element descendants and self
                xf_query_descendant(t_result, true);
                xf_query_type(t_result, "=", xf_type_element);
                t_axis = 46;
            }
            else {
                // Select all child element nodes
                xf_query_child(t_result);
                xf_query_type(t_result, "=", xf_type_element);
            }
              
            t_pos++;
            continue;
        }
        
        
        /**
        * Handle function
        * ===============
        */
        if (t_byte == 40 && string_length(t_fnname)) 
        {
            // Find the end of the function
            t_pos++;
            t_str_end = t_pos;
            
            while (t_str_end < t_eof)
            {
                if (buffer_peek(t_buff, t_str_end, buffer_u8) == 41) break;
                t_str_end++;
            }
            
            if (buffer_peek(t_buff, t_str_end, buffer_u8) != 41) {
                t_error = xf_log(true, xf_find, 1, "Syntax error near pos " + string(t_str_end) + ". Missing ).");
                break;
            }
            
            // Validate the function name
            t_fncmp = -1;
            
            switch (t_fnname) {
                case "text":    t_fncmp = xf_type_text;    break;
                case "cdata":   t_fncmp = xf_type_cdata;   break;  
                case "comment": t_fncmp = xf_type_comment; break;
                default:
                    t_error = xf_log(true, xf_find, 1, "Function " + string(t_fnname) + "() is not supported.");
                    break;
            }
            
            t_fnname = "";
            if (t_error) break;
            
            if (t_fncmp != -1) {
                if (t_axis == 46) {
                    // Search in current set
                    xf_query_type(t_result, "=", t_fncmp);
                }
                else if (t_axis == 47) {
                    // Select descendants and self
                    xf_query_descendant(t_result, true);
                    xf_query_type(t_result, "=", t_fncmp);
                    t_axis = 46;
                }
                else {
                    // Search in children
                    xf_query_child(t_result);
                    xf_query_type(t_result, "=", t_fncmp);
                }
            }
            
            t_pos = t_str_end + 1;
            continue;
        }
        
        
        /**
        * Handle predicate start
        * ======================
        */
        if (t_byte == 91 && t_pred == 0) 
        {
            t_axis = 46;
            t_pred = 1;
            t_pos++;
            continue;
        }
        
        
        /**
        * Handle eval
        * ===========
        */
        if (t_eval)
        {
            t_eval = 0;
            // t_pos++;
            
            if (t_axis == 64) {
                // In attribute axis
                t_axis = 46;
                
                if (t_operator == "=" || t_operator == "!=") {
                    // Remove the quotes from the 2nd operand
                    var t_end   = string_length(t_op_b);
                    var t_start = 1;
                    
                    t_byte = string_byte_at(t_op_b, 1);
                    
                    if (t_byte == 34 || t_byte == 39) {
                        t_start++;
                        t_end--;
                    }
                    
                    t_byte = string_byte_at(t_op_b, string_length(t_op_b));
                    
                    if (t_byte == 34 || t_byte == 39) {
                        t_end--;
                    }
                    
                    t_op_b = string_copy(t_op_b, t_start, t_end);
                }
                
                if (!xf_query_attr_value(t_result, t_op_a, t_operator, t_op_b)) {
                    t_error = true;
                    break;
                }
                
                t_operator = "";
                t_op_a     = "";
                t_op_b     = "";
                continue;
            }
            

            // Validate operator
            if (t_operator != "<" && t_operator != "<=") {
                if (t_operator == "=" || t_operator == "!=" || t_operator == ">" || t_operator == ">=") {
                    t_error = xf_log(true, xf_find, 1, "Syntax error at pos " + string(t_pos) + '. Can only use "<" or "<=" when selecting indices.');
                }
                else {
                    t_error = xf_log(true, xf_find, 1, "Syntax error at pos " + string(t_pos) + ". Expected index range like [x<y].");
                }
                break;
            }
            
            // In node axis; Index range - Cast both operands to real
            t_count = ds_list_size(t_result);
            t_op_a  = real(t_op_a);
            t_op_b  = real(t_op_b);
            
            // Check if index A exists
            if (t_op_a >= t_count || (t_count + t_op_a) < 0) {
                ds_list_clear(t_result);
                break;
            }
            else if (t_op_a < 0) {
                t_op_a = t_count + t_op_a;
            }
            
            // Check if index B exists
            if (t_op_b >= t_count || (t_count + t_op_b) < 0) {
                ds_list_clear(t_result);
                break;
            }
            else if (t_op_b < 0) {
                t_op_b = t_count + t_op_b;
            }
                
            t_filter = ds_list_create();
            t_i      = 0;
            
            if (t_op_a > t_op_b) {
                // Wrap "<" or "<="
                while (t_op_a < t_count)
                {
                    ds_list_add(t_filter, ds_list_find_value(t_result, t_op_a));
                    t_op_a++;
                }
                
                t_i = 0;
                while (t_i < t_op_b)
                {
                    ds_list_add(t_filter, ds_list_find_value(t_result, t_i));
                    t_i++;
                }
                
                if (t_operator == "<=") ds_list_add(t_filter, ds_list_find_value(t_result, t_i));
            }
            else {
                // Dont wrap
                while (t_op_a < t_op_b)
                {
                    ds_list_add(t_filter, ds_list_find_value(t_result, t_op_a));
                    t_op_a++;
                }
                
                if (t_operator == "<=") ds_list_add(t_filter, ds_list_find_value(t_result, t_op_a));
            }
            
            ds_list_destroy(t_result);
            t_result = t_filter;
            
            t_operator = "";
            t_op_a     = "";
            t_op_b     = "";
            continue;
        }
        
        
        /**
        * Handle predicate end
        * ====================
        */
        if (t_byte == 93 && t_pred == 1) 
        {
            t_pred = 0;

            // If elname is not empty we should have an index query like: /element[0]
            if (string_length(t_elname)) {
                t_elname = real(t_elname);
                t_count  = ds_list_size(t_result);

                // Check if index exists
                if (t_elname < 0) {
                    if ((t_count + t_elname) < 0) {
                        ds_list_destroy(t_result);
                        t_result = -1;
                        break;
                    }
                    else {
                        // Wrap index
                        t_elname = t_count + t_elname;
                    }
                }
                else if (t_elname >= t_count) {
                    ds_list_destroy(t_result);
                    t_result = -1;
                    break;
                }

                t_filter = ds_list_create();
                ds_list_add(t_filter, ds_list_find_value(t_result, t_elname));
                ds_list_destroy(t_result);
                
                t_result = t_filter;
                t_elname = "";
            }

            t_pos++;
            continue;
        }
        
        
        /**
        * Handle element, attribute or function name
        * ==========================================
        */
  
        // Find the length of the string
        t_str_end = t_pos;
        
        while (t_str_end < t_eof)
        {
            t_byte = buffer_peek(t_buff, t_str_end, buffer_u8);
            
            // Break on special char
            if (ds_list_find_index(t_str_special_chars, t_byte) > -1) {
                break;
            }

            t_str_end++;
        }
        
        // Right trim
        var t_pos2 = t_str_end;

        while (t_str_end - 1 > t_pos) 
        {
            if (buffer_peek(t_buff, t_str_end - 1, buffer_u8) > 32) break;
            t_str_end--;
        }
        
        // Empty string?
        if (t_str_end == t_pos) {
            t_pos = t_pos2;
            continue;
        }

        // Get the element name
        if (t_str_end < t_eof) {
            t_byte = buffer_peek(t_buff, t_str_end, buffer_u8);
            
            buffer_poke(t_buff, t_str_end, buffer_u8, 0);
            buffer_seek(t_buff, buffer_seek_start, t_pos);
            t_elname = buffer_read(t_buff, buffer_string);

            buffer_poke(t_buff, t_str_end, buffer_u8, t_byte);
        }
        else {
            buffer_seek(t_buff, buffer_seek_start, t_pos);
            t_elname = buffer_read(t_buff, buffer_string);
        }
        
        // Update position
        t_pos  = t_pos2;
        t_byte = buffer_peek(t_buff, t_pos, buffer_u8);
        
        // Check if this is a function
        if (t_byte == 40) {
            t_fnname = t_elname;
            t_elname = "";
            continue;
        }
        
        // If in predicate...
        if (t_pred) {
            // Check if this is the 2nd operand
            if (t_operator != "") {
                t_op_b   = t_elname;
                t_elname = "";
                t_eval   = 1;
                continue;
            }
            
            // Check if this is the 1st operand
            if (ds_list_find_index(t_str_cmp_chars, t_byte) != -1) {
                t_op_a   = t_elname;
                t_op_b   = "";
                t_elname = "";
                
                // Get the operator too
                t_operator = chr(t_byte);
                t_byte1    = 0;
                
                if (t_pos + 1 < t_eof) {
                    t_byte1 = buffer_peek(t_buff, t_pos + 1, buffer_u8);
                    
                    if (ds_list_find_index(t_str_cmp_chars, t_byte1) != -1) {
                        t_operator += chr(t_byte1);
                        t_pos++;
                    }
                }
                
                t_pos++;
                continue;
            }
            else if (t_byte == 93) {
                // End of predicate
                if (t_axis != 64) {
                    continue;
                }
            }
        }
        
            
        // Search attribute name
        if (t_axis == 64) {
            xf_query_type(t_result, "=", xf_type_element);
            xf_query_attr_name(t_result, "=", t_elname);
            t_elname = "";
        }
        else {
            if (t_axis == 46) {
                // Search in current set
                xf_query_type(t_result, "=", xf_type_element);
                xf_query_value(t_result, "=", t_elname);
            }
            else if (t_axis == 47) {
                // Search in descendants and self
                xf_query_descendant(t_result, true);
                xf_query_type(t_result,"=", xf_type_element);
                xf_query_value(t_result, "=", t_elname);
                t_axis = 46;
            }
            else {
                // Search in child elements
                xf_query_child(t_result);
                xf_query_type(t_result, "=", xf_type_element);
                xf_query_value(t_result, "=", t_elname);
            }
        }
    }
    /**
    * End of loop
    * ===========
    */
    
    if (t_error) {
        ds_list_destroy(t_result);
        t_result = -1;
    }
    else {
        if (ds_list_size(t_result) == 0) {
            ds_list_destroy(t_result);
            t_result = -1;
        }
    }
    
    ds_list_destroy(t_str_special_chars);
    ds_list_destroy(t_str_cmp_chars);
    buffer_delete(t_buff);
    
    if (t_filter != t_result && ds_exists(t_filter, ds_type_list)) {
        ds_list_destroy(t_filter);
    }
    
    return t_result;
}