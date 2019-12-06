/// xf_create(type,value)
// Creates and returns a new node of the given type and value.
// See: www.xmlfir.com/xf-create


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count == 0) {
        return xf_log(-1, xf_create, 1, "Missing argument count: 1.");
    }
    
    // If the 1st argument is a string, create new element
    if (!is_real(argument[0])) {
        // No 2nd argument? Then we're done here
        if (argument_count == 1) {
            var t_node = ds_list_create();
            ds_list_add(t_node, xf_type_element, argument[0], noone, -1, -1, -1, noone);
            
            p_error = "";
            
            // Callback
            if (p_call_ev_create != noone && p_ev_create_on) {
                script_execute(p_call_ev_create, xf_ev_create, t_node);
            }
            return t_node;
        } 
        
        // We have a string; try to decode it with json_decode
        if (!is_real(argument[1])) {
            var t_map  = json_decode(argument[1]);
            var t_json = true;
        }
        else {
            var t_json = false;
            var t_map  = argument[1];
        }
        
        // Validate the ds_map
        if (!ds_exists(t_map, ds_type_map)) {
            if (t_json) {
                return xf_log(-1, xf_create, 1, "Failed to decode json attributes.");
            }

            return xf_log(-1, xf_create, 1, "Invalid data type for argument1. Expected ds_map.");
        }
        
        // Check if ds_map is empty
        if (!ds_map_size(t_map)) {
            if (t_json) {
                ds_map_destroy(t_map);
                return xf_log(-1, xf_create, 1, "json decoded string returned empty ds_map.");
            }
            
            return xf_log(-1, xf_create, 1, "ds_map is empty.");
        }
        
        // Copy the map data
        var t_attr_keys = ds_list_create();
        var t_attr_vals = ds_list_create();
        var t_key       = ds_map_find_first(t_map);
            
        while (is_string(t_key))
        {
            ds_list_add(t_attr_keys, t_key);
            ds_list_add(t_attr_vals, ds_map_find_value(t_map, t_key));
            t_key = ds_map_find_next(t_map, t_key);
        }
        
        // Destroy ds_map
        if (t_json) ds_map_destroy(t_map);
        
        // And finally create the node
        var t_node = ds_list_create();
        ds_list_add(t_node, xf_type_element, argument[0], noone, -1, t_attr_keys, t_attr_vals, noone);
        
        ds_list_mark_as_list(t_node, xf_prop_attrk);
        ds_list_mark_as_list(t_node, xf_prop_attrv);
        
        // Reset error
        p_error = "";
        
        // Callback
        if (p_call_ev_create != noone && p_ev_create_on) {
            script_execute(p_call_ev_create, xf_ev_create, t_node);
        }
            
        return t_node;
    }
    
    // If the 1st argument is a real value, assume a comment, text or cdata node
    switch (argument[0])
    {
        case xf_type_comment:
        case xf_type_text:
        case xf_type_cdata:
            if (argument_count == 2) {
                // Value argument must be a string
                if (is_real(argument[1])) {
                    xf_log(xf_create, 2, "Invalid data type for argument1. Casting to string.");
                    
                    var t_node = ds_list_create();
                    ds_list_add(t_node, argument[0], string(argument[1]), noone, -1, -1, -1, noone);
                    
                    // Reset error
                    p_error = "";
                    
                    // Callback
                    if (p_call_ev_create != noone && p_ev_create_on) {
                        script_execute(p_call_ev_create, xf_ev_create, t_node);
                    }
                    
                    return t_node;
                }
                
                // Create the node
                var t_node = ds_list_create();
                ds_list_add(t_node, argument[0], argument[1], noone, -1, -1, -1, noone);
                
                // Reset error
                p_error = "";
                
                // Callback
                if (p_call_ev_create != noone && p_ev_create_on) {
                    script_execute(p_call_ev_create, xf_ev_create, t_node);
                }
                
                return t_node;
            }
            else {
                // No value given, create an empty node
                var t_node = ds_list_create();
                ds_list_add(t_node, argument[0], "", noone, -1, -1, -1, noone);
                
                // Reset error
                p_error = "";
                
                // Callback
                if (p_call_ev_create != noone && p_ev_create_on) {
                    script_execute(p_call_ev_create, xf_ev_create, t_node);
                }
                
                return t_node;
            }
            break;
            
        case xf_type_fragment:
            var t_node = ds_list_create();
            ds_list_add(t_node, argument[0], "", noone, -1, -1, -1, noone);
            
            // Callback
            if (p_call_ev_create != noone && p_ev_create_on) {
                script_execute(p_call_ev_create, xf_ev_create, t_node);
            }
            
            return t_node;
            break;
            
        default:
            // Unknown argument value
            xf_log(xf_create, 1, "argument0 is not a valid node type.");
            return -1;
            break;
    }
}
