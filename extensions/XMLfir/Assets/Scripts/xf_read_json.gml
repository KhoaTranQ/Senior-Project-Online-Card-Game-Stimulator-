/// xf_read_json(string)
// Reads the given json string and returns the root node.
// See: www.xmlfir.com/xf-read-json


/**
* User call
* =========
*/
if (argument_count <= 1) {
    // Get instance of the xml controller
    var t__xml = instance_find(xf_asset_object_controller, 0);
    
    if (t__xml == noone) {
        t__xml = instance_create(0, 0, xf_asset_object_controller);
    }
    
    
    with (t__xml)
    {
        // Validate argument count
        if (argument_count < 1) {
            return xf_log(-1, xf_read_json, 1, "Missing argument count: 1.");
        }
        
        // Decode json
        var t_map = json_decode(argument[0]);

        // Check for error
        if (t_map == -1) {
            return xf_log(-1, xf_read_json, 1, "Failed to decode string.");
        }
        else if (ds_map_empty(t_map)) {
            ds_map_destroy(t_map);
            return xf_log(-1, xf_read_json, 1, "Failed to decode string.");
        }
        
        // Reset error
        p_error = "";
        
        if (ds_map_exists(t_map, "default")) {
            // Turn "default" map to fragment
            var t_node = ds_list_create();
            ds_list_add(t_node, xf_type_fragment, "", noone, -1, -1, -1, noone);
            
            var t_map_children = ds_map_find_value(t_map, "default");
            var t_children     = ds_list_create();
            
            var t_map_child = noone;
            var t_child     = noone;
            var t_count     = ds_list_size(t_map_children);
            var t_i         = 0;
            
            while (t_i < t_count)
            {
                t_map_child = ds_list_find_value(t_map_children, t_i);
                t_child     = xf_read_json("", t_map_child, t_node);
                
                if (t_child > -1) {
                    ds_list_add(t_children, t_child);
                    ds_list_mark_as_list(t_children, ds_list_size(t_children) - 1);
                }
            
                t_i++;
            }
            
            ds_list_replace(t_node, xf_prop_children, t_children);
            ds_list_mark_as_list(t_node, xf_prop_children);
            
            ds_map_destroy(t_map);
            
            var t_result = t_node;
        }
        else {
            // Format data
            var t_result = xf_read_json("", t_map, noone);
            ds_map_destroy(t_map);
        }
        
        // Check for error
        if (string_length(p_error)) {
            if (ds_exists(t_result, ds_type_list)) {
                ds_list_destroy(t_result);
            }
            
            t_result = -1;
        }
        
        // Callback
        if (ds_exists(t_result, ds_type_list)) {
            if (p_call_ev_create != noone) {
                script_execute(p_call_ev_create, xf_ev_create, t_result);
            }
        }
        
        return t_result;
    }
}


/**
* Internal call
* =============
*/
var t_str    = argument[0];
var t_map    = argument[1];
var t_parent = argument[2];


// Validate the map
if (!ds_exists(t_map, ds_type_map)) {
    return xf_log(-1, xf_read_json, 1, "Unexpected data type. Expected ds_map.");
}
else if (!ds_map_exists(t_map, "?")) {
    return xf_log(-1, xf_read_json, 1, 'Missing object type member "?".');
}

if (!ds_map_exists(t_map, "=")) {
    return xf_log(-1, xf_read_json, 1, 'Missing object value member "=".');
}

var t_map_type = ds_map_find_value(t_map, "?");
var t_type     = -1;

ds_map_delete(t_map, "?");

switch (t_map_type)
{
    case "el": t_type = xf_type_element; break;
    case "tx": t_type = xf_type_text;    break;
    case "co": t_type = xf_type_comment; break;
    case "cd": t_type = xf_type_cdata;   break;
        
    default:
        return xf_log(-1, xf_read_json, 1, 'Unknown element type found.');
        break;
}

// Get the value
var t_map_value = ds_map_find_value(t_map, "=");
ds_map_delete(t_map, "=");

// Get any children
var t_map_children = -1;

if (ds_map_exists(t_map, ">")) {
    t_map_children = ds_map_find_value(t_map, ">");
}

// Get attributes
var t_attribk = -1;
var t_attribv = -1;
    
var t_has_attr = ds_map_size(t_map);

if (t_has_attr >= 2 || (t_has_attr >= 1 && t_map_children == -1)) {
    var t_count = ds_map_size(t_map);
    var t_val = "";
    var t_k   = ds_map_find_first(t_map);
    
    t_attribk = ds_list_create();
    t_attribv = ds_list_create();
    
    if (t_map_children > -1) {
        while (is_string(t_k)) 
        {
            if (string(t_k) != ">") {
                t_val = ds_map_find_value(t_map, t_k);
                
                if (is_string(t_val)) {
                    // Decode entities
                    if (string_pos('\\', t_val)) t_val = string_replace_all(t_val, '\\', '\');
                    if (string_pos('\"', t_val)) t_val = string_replace_all(t_val, '\"', '"');
                    if (string_pos('\r', t_val)) t_val = string_replace_all(t_val, '\r', chr(13));
                    if (string_pos('\n', t_val)) t_val = string_replace_all(t_val, '\n', chr(10));
                }
                
                ds_list_add(t_attribk, t_k);
                ds_list_add(t_attribv, t_val);
            }
            
            t_k = ds_map_find_next(t_map, t_k);
        }
    }
    else {
        while (is_string(t_k)) 
        {
            t_val = ds_map_find_value(t_map, t_k);
                
            if (is_string(t_val)) {
                // Decode entities
                if (string_pos('\\', t_val)) t_val = string_replace_all(t_val, '\\', '\');
                if (string_pos('\"', t_val)) t_val = string_replace_all(t_val, '\"', '"');
                if (string_pos('\r', t_val)) t_val = string_replace_all(t_val, '\r', chr(13));
                if (string_pos('\n', t_val)) t_val = string_replace_all(t_val, '\n', chr(10));
            }
            
            ds_list_add(t_attribk, t_k);
            ds_list_add(t_attribv, t_val);
            
            t_k = ds_map_find_next(t_map, t_k);
        }
    }
}


// Create the node
var t_node = ds_list_create();
ds_list_add(t_node, t_type, t_map_value, t_parent, -1, t_attribk, t_attribv, noone);

if (t_attribk > -1) {
    ds_list_mark_as_list(t_node, xf_prop_attrk);
    ds_list_mark_as_list(t_node, xf_prop_attrv);
}

if (t_map_children == -1) {
    return t_node;
}

// Handle child nodes recursively
var t_children  = ds_list_create();
var t_map_child = noone;
var t_child     = noone;

var t_c = ds_list_size(t_map_children);
var t_i = 0;

while (t_i < t_c)
{
    t_map_child = ds_list_find_value(t_map_children, t_i);
    t_child     = xf_read_json("", t_map_child, t_node);
    
    if (t_child > -1) {
        ds_list_add(t_children, t_child);
        ds_list_mark_as_list(t_children, ds_list_size(t_children) - 1);
    }
    
    t_i++;
}

if (ds_list_size(t_children)) {
    ds_list_replace(t_node, xf_prop_children, t_children);
    ds_list_mark_as_list(t_node, xf_prop_children);
}
else {
    ds_list_destroy(t_children);
}

return t_node;
