/// xf_set_attr(node,attribute,value,...)
// Sets the value of one or more node attributes (name).
// See: www.xmlfir.com/xf-set-attr


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}

with (t__xml)
{
    // Validate argument count
    if (argument_count < 2) {
        return xf_log(xf_set_attr, 1, "Missing argument count: " +  string(2 - argument_count) + ".");
    }
    
    var t_node = argument[0];
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(xf_set_attr, 1, "argument0 is not a valid data structure.");
    }
    
    // Validate type
    var t_type = ds_list_find_value(t_node, xf_prop_type);
    
    if (t_type != xf_type_element) {
        return xf_log(xf_set_attr, 1, "argument0 does not support attributes.");
    }
    
    // Reset error
    p_error = "";
    
    var t_arg_count = argument_count;
    
    // For 3 or more argument, assume key/value pairs
    if (t_arg_count >= 3) {
        if (((t_arg_count - 1) mod 2) != 0) {
            return xf_log(xf_set_attr, 1, "Uneven argument count. Expected " + string(t_arg_count + 1) + ".");
        }
        
        // Get node attributes
        var t_attr_keys = ds_list_find_value(t_node, xf_prop_attrk);
        var t_attr_vals = ds_list_find_value(t_node, xf_prop_attrv);
        
        if (!ds_exists(t_attr_keys, ds_type_list)) {
            t_attr_keys = ds_list_create();
            t_attr_vals = ds_list_create();
            
            ds_list_replace(t_node, xf_prop_attrk, t_attr_keys);
            ds_list_replace(t_node, xf_prop_attrv, t_attr_vals);
            ds_list_mark_as_list(t_node, xf_prop_attrk);
            ds_list_mark_as_list(t_node, xf_prop_attrv);
        }
        
        t_arg_count--;
        
        var t_i   = 1;
        var t_key = "";
        var t_val = "";
        var t_idx = -1;
        
        // Add attributes
        if (p_call_ev_set != noone && p_ev_set_on) {
            // With callback
            while (t_i < t_arg_count)
            {
                t_key = string(argument[t_i]);
                t_val = argument[t_i + 1];
                t_idx = ds_list_find_index(t_attr_keys, t_key);
        
                if (t_idx > -1) {
                    // Replace existing attribute
                    ds_list_replace(t_attr_vals, t_idx, t_val);
                    script_execute(p_call_ev_set, xf_ev_set_att, t_node, t_key, t_val, false);
                }
                else {
                    // Add new attribute
                    ds_list_add(t_attr_keys, t_key);
                    ds_list_add(t_attr_vals, t_val);
                    script_execute(p_call_ev_set, xf_ev_set_att, t_node, t_key, t_val, true);
                }
                
                t_i += 2;
            }
        }
        else {
            // Without callback
            while (t_i < t_arg_count)
            {
                t_key = string(argument[t_i]);
                t_val = argument[t_i + 1];
                t_idx = ds_list_find_index(t_attr_keys, t_key);
        
                if (t_idx > -1) {
                    // Replace existing attribute
                    ds_list_replace(t_attr_vals, t_idx, t_val);
                }
                else {
                    // Add new attribute
                    ds_list_add(t_attr_keys, t_key);
                    ds_list_add(t_attr_vals, t_val);
                }
                
                t_i += 2;
            }
        }
        
        
        p_error = "";
        
        return true;
    }
    

    // 2 arguments; try json or ds_map
    if (!is_real(argument[1])) {
        // We have a string; try to decode it
        t_json = true;
        t_map  = json_decode(argument[1]);
    }
    else {
        var t_json = false;
        var t_map  = argument[1];
    }
    
    // Validate the map
    if (!ds_exists(t_map, ds_type_map)) {
        if (t_json) {
            return xf_log(xf_set_attr, 1, "Failed to decode json attributes.");
        }

        return xf_log(xf_set_attr, 1, "Invalid data type for argument1. Expected ds_map.");
    }
    
    // Check if empty
    if (!ds_map_size(t_map)) {
        if (t_json) {
            ds_map_destroy(t_map);
            return xf_log(xf_set_attr, 1, "json decoded string returned empty ds_map.");
        }

        return xf_log(xf_set_attr, 1, "argument1 is an emty ds_map.");
    }
    
    // Get node attributes
    var t_attr_keys = ds_list_find_value(t_node, xf_prop_attrk);
    var t_attr_vals = ds_list_find_value(t_node, xf_prop_attrv);
    
    if (!ds_exists(t_attr_keys, ds_type_list)) {
        t_attr_keys = ds_list_create();
        t_attr_vals = ds_list_create();
        
        ds_list_replace(t_node, xf_prop_attrk, t_attr_keys);
        ds_list_replace(t_node, xf_prop_attrv, t_attr_vals);
        ds_list_mark_as_list(t_node, xf_prop_attrk);
        ds_list_mark_as_list(t_node, xf_prop_attrv);
    }
    
    var t_key = ds_map_find_first(t_map);
    var t_idx = -1;
    
    if (p_call_ev_set != noone && p_ev_set_on) {
        // With callback
        var t_val = "";
        
        while (is_string(t_key))
        {
            t_idx = ds_list_find_index(t_attr_keys, t_key);
            t_val = ds_map_find_value(t_map, t_key);
            
            if (t_idx > -1) {
                // Replace existing attribute
                ds_list_replace(t_attr_vals, t_idx, t_val);
                script_execute(p_call_ev_set, xf_ev_set_att, t_node, t_key, t_val, false);
            }
            else {
                // Add new attribute
                ds_list_add(t_attr_keys, t_key);
                ds_list_add(t_attr_vals, t_val);
                script_execute(p_call_ev_set, xf_ev_set_att, t_node, t_key, t_val, true);
            }
        
            t_key = ds_map_find_next(t_map, t_key);
        }
    }
    else {
        // Without callback
        while (is_string(t_key))
        {
            t_idx = ds_list_find_index(t_attr_keys, t_key);
            
            if (t_idx != -1) {
                // Replace existing attribute
                ds_list_replace(t_attr_vals, t_idx, ds_map_find_value(t_map, t_key));
            }
            else {
                // Add new attribute
                ds_list_add(t_attr_keys, t_key);
                ds_list_add(t_attr_vals, ds_map_find_value(t_map, t_key));
            }
            
            t_key = ds_map_find_next(t_map, t_key);
        }
    }
    
    
    if (t_json) ds_map_destroy(t_map);
    
    return true;
}
