/// xf_write_json(node)
// Encodes the given node including its descendants into a json string.
// See: www.xmlfir.com/xf-write-json


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
            return xf_log("", xf_write_json, 1, "Missing argument count: 1.");
        }
        
        // Try simple node validation
        var t_node = argument[0];
        
        if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
            return xf_log("", xf_write_json, 1, "argument0 contains an invalid xml node.");
        }
        
        // Reset error
        p_error = "";
        
        // Callback
        if (p_call_ev_write != noone && p_ev_write_on) {
            script_execute(p_call_ev_write, xf_ev_write, t_node, 1);
        }
        
        // Encode recursively
        var t_str = xf_write_json(t_node, 0);
        
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
var t_node  = argument[0];
var t_depth = argument[1];

// Validate the node
if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
    return xf_log("", xf_write_json, 1, "argument0 contains an invalid xml node.");
}

// Temp vars
var t_txt         = "";
var t_type_name   = "";
var t_attrib_name = "";
var t_attrib_val  = "";
var t_child_type  = noone;
var t_str  = "";
var t_nl      = "";
var t_space   = "";
var t_space2  = "";
var t_attribk = 0;
var t_attribv = 0;
var t_count   = 0;
var t_i       = 0;
var t_count   = 0;
var t_child   = noone;
var t_type    = 0;
var t_i       = 0;    

if (cfg_write_tidy) {
    t_nl     = chr($0A);
    t_space  = string_repeat(chr($09), t_depth);
    t_space2 = string_repeat(chr($09), t_depth + 1);
}


// Get node type
var t_type = ds_list_find_value(t_node, xf_prop_type);

switch (t_type)
{
    // Encode tags
    case xf_type_element:
        // Encode name
        t_str += '{"?":"el", '

        t_str += '"=":"' + string(ds_list_find_value(t_node, xf_prop_value)) + '"';
        
        
        // Encode attributes
        t_attribk = ds_list_find_value(t_node, xf_prop_attrk);
        
        if (ds_exists(t_attribk, ds_type_list)) {
            t_attribv    = ds_list_find_value(t_node, xf_prop_attrv);
            t_count      = ds_list_size(t_attribk);
            t_attrib_val = "";
            t_i          = 0;
            
            while (t_i < t_count)
            {
                t_attrib_name = string(ds_list_find_value(t_attribk, t_i));
                t_attrib_val  = ds_list_find_value(t_attribv, t_i);
                
                // Validate attribute name
                if (string_length(t_attrib_name) == 1) {
                    if (t_attrib_name == "?" || t_attrib_name == "=" || t_attrib_name == ">") {
                        return xf_log("", xf_write_json, 1, 'Attribute name "' + t_attrib_name + '" is reserved when encoding to json.');
                    }
                }
                
                // Esape characters in attribute value
                if (is_string(t_attrib_val)) {
                    if (string_pos('\', t_attrib_val))     t_attrib_val = string_replace_all(t_attrib_val, '\', '\\');
                    if (string_pos('"', t_attrib_val))     t_attrib_val = string_replace_all(t_attrib_val, '"', '\"');
                    if (string_pos(chr(13), t_attrib_val)) t_attrib_val = string_replace_all(t_attrib_val, chr(13), '\r');
                    if (string_pos(chr(10), t_attrib_val)) t_attrib_val = string_replace_all(t_attrib_val, chr(10), '\n');
                    
                    t_str += ', "' + t_attrib_name + '":"' + string(t_attrib_val) + '"';
                }
                else {
                    t_str += ', "' + t_attrib_name + '":' + string(t_attrib_val) + '';
                }
                
                t_i++;
            }
        }
        
        var t_children = ds_list_find_value(t_node, xf_prop_children);
        
        if (!ds_exists(t_children, ds_type_list)) {
            t_str += "}";
            break;
        }
        
        // Encode children
        t_child_type = 0;
        t_count      = ds_list_size(t_children);
        t_child      = noone;
        t_i          = 0;
        
        t_str += ', ">":' + t_nl + t_space + "["

        while (t_i < t_count)
        {
            t_child = ds_list_find_value(t_children, t_i);
            
            if (!is_real(t_child) || !ds_exists(t_child, ds_type_list) || ds_list_size(t_child) != xf_prop_size) {
                return xf_log("", xf_write_json, 1, "argument0 contains an invalid xml node.");
            }
            
            t_child_type = ds_list_find_value(t_child, xf_prop_type);
            
            switch (t_child_type)
            {
                // Recursively encode tags and fragments
                case xf_type_element:
                case xf_type_fragment:
                    t_str += t_nl + t_space2 + xf_write_json(t_child, t_depth + 1);
                    break;
                    
                // Inline-encode text node, comment, cdata
                case xf_type_text:
                case xf_type_comment:
                case xf_type_cdata:
                    t_txt = string(ds_list_find_value(t_child, xf_prop_value));
                    t_type_name = "";
                    
                    switch (t_child_type)
                    {
                        case xf_type_text:    t_type_name = "tx"; break; 
                        case xf_type_comment: t_type_name = "co"; break;   
                        case xf_type_cdata:   t_type_name = "cd"; break;
                    }
                    
                    // Esape characters
                    if (string_pos('\', t_txt))     t_txt = string_replace_all(t_txt, '\', '\\');
                    if (string_pos('"', t_txt))     t_txt = string_replace_all(t_txt, '"', '\"');
                    if (string_pos(chr(13), t_txt)) t_txt = string_replace_all(t_txt, chr(13), '\r');
                    if (string_pos(chr(10), t_txt)) t_txt = string_replace_all(t_txt, chr(10), '\n');
                    
                    t_str += t_nl + t_space2 + '{"?":"' + t_type_name + '", ' + '"=":"' + t_txt + '"}';
                    break;

                default:
                    // Unknown node type!
                    return xf_log("", xf_write_json, 1, "argument0 contains an invalid xml node.");
                    break;
            }

            t_i++;
            
            if (t_i < t_count) t_str += ",";
        }
        
        t_str += t_nl + t_space + "]}"
        break;
        
    // Encode text node, comment, cdata    
    case xf_type_text:
    case xf_type_comment:
    case xf_type_cdata:
        t_txt = string(ds_list_find_value(t_node, xf_prop_value));
        t_type_name = "";
        
        switch (t_type)
        {
            case xf_type_text:    t_type_name = "tx"; break; 
            case xf_type_comment: t_type_name = "co"; break;   
            case xf_type_cdata:   t_type_name = "cd"; break;
        }
        
        // Esape characters
        if (string_pos('\', t_txt))     t_txt = string_replace_all(t_txt, '\', '\\');
        if (string_pos('"', t_txt))     t_txt = string_replace_all(t_txt, '"', '\"');
        if (string_pos(chr(13), t_txt)) t_txt = string_replace_all(t_txt, chr(13), '\r');
        if (string_pos(chr(10), t_txt)) t_txt = string_replace_all(t_txt, chr(10), '\n');
        
        t_str += t_nl + t_space2 + '{"?":"' + t_type_name + '", ' + '"=":"' + t_txt + '"}';
        break;
       
    // Encode fragment
    case xf_type_fragment:
        t_children = ds_list_find_value(t_node, xf_prop_children);
        
        if (!ds_exists(t_children, ds_type_list)) {
            break;
        }
        
        t_count = ds_list_size(t_children);
        t_child = noone;
        t_i     = 0;
        
        t_str += "["
        
        while (t_i < t_count)
        {
            t_child = ds_list_find_value(t_children, t_i);
            t_str += t_nl + t_space2 + xf_write_json(t_child, t_depth + 1);
            t_i++;
            
            if (t_i < t_count) t_str += ", ";
        }
        
        t_str += "]";
        break;
        
    default:
        // Unknown node type!
        return xf_log("", xf_write_json, 1, "argument0 contains an invalid xml node.");
        break;
}

return t_str;
