/// xf_write_xml(node)
// Takes the given node including its descendants and returns an xml string.
// See: www.xmlfir.com/xf-write-xml


/**
* User call
* =========
*/
if (argument_count <= 1) {
    // Get an instance of the xml controller
    var t__xml = instance_find(xf_asset_object_controller, 0);
    
    if (t__xml == noone) {
        t__xml = instance_create(0, 0, xf_asset_object_controller);
    }
    
    
    with (t__xml)
    {
        // Validate argument count
        if (argument_count < 1) {
            return xf_log("", xf_write_xml, 1, "Missing argument count: 1.");
        }
        
        // Try simple node validation
        var t_node = argument[0];
        
        if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
            return xf_log("", xf_write_xml, 1, "argument0 contains an invalid xml node.");
        }
        
        // Reset error
        p_error = "";
        
        // Callback
        if (p_call_ev_write != noone && p_ev_write_on) {
            script_execute(p_call_ev_write, xf_ev_write, t_node, 2);
        }
        
        // Encode recursively
        var t_str = xf_write_xml(t_node, 0);
        
        // Check for error
        if (string_length(p_error)) {
            t_str = "";
        }
        
        return t_str;
    }
}


/**
* Internal call
* =============
*/
var t_node   = argument[0];
var t_depth  = argument[1];

// Validate the node
if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
    return xf_log("", xf_write_xml, 1, "argument0 contains an invalid xml node.");
}

// Temp vars
var t_child      = noone;
var t_child_type = 0;
var t_attr_num   = 0;
var t_attr_i     = 0;
var t_count      = 0;
var t_i          = 0;
var t_attr_keys  = -1;
var t_attr_vals  = -1;
var t_children   = -1;
var t_tag_name   = "";
var t_char       = "";
var t_attr_key   = "";
var t_attr_val   = "";
var t_tidy       = "";
var t_txt        = "";
var t_str_start  = "";
var t_str_end    = "";
var t_str        = "";


// Get node type
var t_type = ds_list_find_value(t_node, xf_prop_type);

switch (t_type)
{
    // Encode element
    case xf_type_element:
        // Get tag name
        t_tag_name = string(ds_list_find_value(t_node, xf_prop_value));
        t_char     = string_char_at(t_tag_name, 1);
        
        // Validate tag name
        if (ord(t_char) <= 64) {
            return xf_log("", xf_write_xml, 1, 'Tag "' + t_tag_name + '" must not start with "' + t_char + '".');
        }
        
        // Encode tag name
        t_str += "<" + t_tag_name;
        
        // Encode attributes
        t_attr_keys = ds_list_find_value(t_node, xf_prop_attrk);
        
        // Break if there are no attributes
        if (ds_exists(t_attr_keys, ds_type_list)) {
            t_attr_vals = ds_list_find_value(t_node, xf_prop_attrv);
            t_attr_num  = ds_list_size(t_attr_keys);
            t_attr_i    = 0;
            
            if (cfg_write_xml_entities_encode) {
                // Encode entities
                
                t_attr_val = "";
                
                if (cfg_write_xml_replace_attname_space) {
                    // Replace attribute name white space
                    while (t_attr_i < t_attr_num)
                    {
                        t_attr_key = ds_list_find_value(t_attr_keys, t_attr_i);
                        t_attr_val = ds_list_find_value(t_attr_vals, t_attr_i);
                        
                        if (string_pos(" ", t_attr_key)) {
                            t_attr_key = string_replace_all(t_attr_key, " ", cfg_write_xml_replace_attname_char);
                        }
                        
                        if (is_string(t_attr_val)) {
                            if (string_pos(">", t_attr_val)) t_attr_val = string_replace_all(t_attr_val, ">", "&gt;");
                            if (string_pos("<", t_attr_val)) t_attr_val = string_replace_all(t_attr_val, "<", "&lt;");
                            if (string_pos('"', t_attr_val)) t_attr_val = string_replace_all(t_attr_val, '"', "&quot;");
                            if (string_pos("'", t_attr_val)) t_attr_val = string_replace_all(t_attr_val, "'", "&apos;");
                        }
    
                        t_str += " " + t_attr_key + '="' + string(t_attr_val) + '"';
                                 
                        t_attr_i++;
                    }
                }
                else {
                    // Entities only...
                    while (t_attr_i < t_attr_num)
                    {
                        t_attr_val = ds_list_find_value(t_attr_vals, t_attr_i);
                        
                        if (is_string(t_attr_val)) {
                            if (string_pos(">", t_attr_val)) t_attr_val = string_replace_all(t_attr_val, ">", "&gt;");
                            if (string_pos("<", t_attr_val)) t_attr_val = string_replace_all(t_attr_val, "<", "&lt;");
                            if (string_pos('"', t_attr_val)) t_attr_val = string_replace_all(t_attr_val, '"', "&quot;");
                            if (string_pos("'", t_attr_val)) t_attr_val = string_replace_all(t_attr_val, "'", "&apos;");
                        }
    
                        t_str += " " + string(ds_list_find_value(t_attr_keys, t_attr_i))
                               +  '="' + string(t_attr_val) + '"';
                                 
                        t_attr_i++;
                    }
                }
                
            }
            else {
                // No entities
                if (cfg_write_xml_replace_attname_space) {
                    // Replace attribute name white space
                    while (t_attr_i < t_attr_num)
                    {
                        t_attr_key = string(ds_list_find_value(t_attr_keys, t_attr_i));
                        
                        if (string_pos(" ", t_attr_key)) {
                            t_attr_key = string_replace_all(t_attr_key, " ", cfg_write_xml_replace_attname_char);
                        }
                        
                        t_str += " "  + t_attr_key
                        +  '="' + string(ds_list_find_value(t_attr_vals, t_attr_i)) + '"';
                                 
                        t_attr_i++;
                    }
                }
                else {
                    // Keep as is
                    while (t_attr_i < t_attr_num)
                    {
                        t_str += " "  + string(ds_list_find_value(t_attr_keys, t_attr_i)) 
                                 +  '="' + string(ds_list_find_value(t_attr_vals, t_attr_i)) + '"';
                                 
                        t_attr_i++;
                    }
                }
                
            }
        }
        
        // Get children
        t_children = ds_list_find_value(t_node, xf_prop_children);
        
        // Break if no children exist
        if (!ds_exists(t_children, ds_type_list)) {
            t_str += "/>";
            break;
        }
        
        t_str += ">";
        
        // Encode children
        t_count = ds_list_size(t_children);
        t_child = noone;
        t_i     = 0;
        t_tidy  = "";
        
        t_child_type = 0;
        
        if (cfg_write_tidy) {
            // Tidy code - Add tabs and new lines
            t_tidy = chr($0A) + string_repeat(chr($09), t_depth + 1);
        }
        
        // Encode child elements
        while (t_i < t_count)
        {
            t_child = ds_list_find_value(t_children, t_i);
            
            // Validate the child
            if (!is_real(t_child) || !ds_exists(t_child, ds_type_list) || ds_list_size(t_child) != xf_prop_size) {
                return xf_log("", xf_write_xml, 1, "argument0 contains an invalid xml node.");
            }
            
            t_child_type = ds_list_find_value(t_child, xf_prop_type);
            
            switch (t_child_type)
            {
                // Recursively encode elements and fragments
                case xf_type_element:
                case xf_type_fragment:
                    t_str += t_tidy + xf_write_xml(t_child, t_depth + 1);
                    break;
                    
                // Inline encode text
                case xf_type_text:
                    if (cfg_write_xml_entities_encode) {
                        // Encode entities
                        t_txt = string(ds_list_find_value(t_child, xf_prop_value));
                        
                        if (string_pos(">", t_txt)) t_txt = string_replace_all(t_txt, ">", "&gt;");
                        if (string_pos("<", t_txt)) t_txt = string_replace_all(t_txt, "<", "&lt;");
                        if (string_pos('"', t_txt)) t_txt = string_replace_all(t_txt, '"', "&quot;");
                        if (string_pos("'", t_txt)) t_txt = string_replace_all(t_txt, "'", "&apos;");
                        
                        t_str += t_txt;
                    }
                    else {
                        t_str += string(ds_list_find_value(t_child, xf_prop_value));
                    }
                    break;
                    
                // Inline encode comment
                case xf_type_comment:
                    t_str += t_tidy + "<!-- " + string(ds_list_find_value(t_child, xf_prop_value)) + " -->";
                    break;
                    
                case xf_type_cdata:
                    t_str += t_tidy + "<![CDATA[" + string(ds_list_find_value(t_child, xf_prop_value)) + "]]>";
                    break;
                
                default:
                    // Unknown element type!
                    return xf_log("", xf_write_xml, 2, "argument0 contains an invalid xml node.");
                    break;
            }
            
            t_i++;
        }
        
        // Encode closing tag
        if (cfg_write_tidy == false) {
            t_str += "</" + t_tag_name + ">";
            break;
        }
        
        if (t_child_type == xf_type_element) {
            t_str += chr($0A) + string_repeat(chr($09), t_depth) + "</" + t_tag_name + ">";
            break;
        }
        
        t_str += "</" + t_tag_name + ">";
        break;
        
    // Encode text
    case xf_type_text:
        if (cfg_write_xml_entities_encode) {
            // Encode entities
            t_txt = string(ds_list_find_value(t_node, xf_prop_value));
            
            if (string_pos(">", t_txt)) t_txt = string_replace_all(t_txt, ">", "&gt;");
            if (string_pos("<", t_txt)) t_txt = string_replace_all(t_txt, "<", "&lt;");
            if (string_pos('"', t_txt)) t_txt = string_replace_all(t_txt, '"', "&quot;");
            if (string_pos("'", t_txt)) t_txt = string_replace_all(t_txt, "'", "&apos;");
            
            t_str += t_txt;
        }
        else {
            t_str += string(ds_list_find_value(t_node, xf_prop_value));
        }
        break;
        
    // Encode comment
    case xf_type_comment:
        t_str += "<!-- " + string(ds_list_find_value(t_node, xf_prop_value)) + " -->";
        break;
        
    // Encode cdata
    case xf_type_cdata:
        t_str += "<![CDATA[" + string(ds_list_find_value(t_node, xf_prop_value)) + "]]>";
        break;
        
    // Encode fragment
    case xf_type_fragment:
        t_children = ds_list_find_value(t_node, xf_prop_children);
        if (!ds_exists(t_children, ds_type_list)) break;
        
        t_count = ds_list_size(t_children);
        t_i     = 0;
        
        while (t_i < t_count)
        {
            t_str += xf_write_xml(ds_list_find_value(t_children, t_i), t_depth);
            t_i++;
        }
        break;
        
    default:
        // Unknown element type!
        return xf_log("", xf_write_xml, 2, "argument0 contains an invalid xml node.");
        break;
}

return t_str;
