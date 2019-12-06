/// xf_get_attr(node,name,alt,set)
// Returns the value of a node attribute (name).
// See: www.xmlfir.com/xf-get-attr


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count < 2) {
        return xf_log(noone, xf_get_attr, 1, "Missing argument count: " +  string(2 - argument_count) + ".");
    }
    
    // Get arguments
    var t_node = argument[0];
    var t_key  = argument[1];

    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(noone, xf_get_attr, 1, "argument0 is not a valid xml node.");
    }
    
    var t_all = false;
    
    if (is_real(t_key)) {
        if (t_key != all) {
            return xf_log(noone, xf_get_attr, 1, "argument1 must be a string or all.");
        }
        
        t_all = true;
    }
    
    // Validate type
    var t_type = ds_list_find_value(t_node, xf_prop_type);
    
    if (t_type != xf_type_element) {
        return xf_log(noone, xf_get_attr, 1, "argument0 does not support attributes.");
    }
    
    // Reset error
    p_error = "";
    
    // Get attributes
    var t_attr_keys = ds_list_find_value(t_node, xf_prop_attrk);
    var t_exists    = ds_exists(t_attr_keys, ds_type_list);
    
    if (t_exists) {
        // Return ds_map?
        if (t_all) {
            var t_attr_vals = ds_list_find_value(t_node, xf_prop_attrv);
            var t_count     = ds_list_size(t_attr_keys);
            var t_map       = ds_map_create();
            
            var t_i = 0;
            
            while (t_i < t_count)
            {
                ds_map_add(t_map, 
                    string(ds_list_find_value(t_attr_keys, t_i)),
                    ds_list_find_value(t_attr_vals, t_i)
                );
                
                t_i++;
            }
            
            return t_map;
        }
        
        var t_idx = ds_list_find_index(t_attr_keys, t_key);
        
        // Return the value if it exists
        if (t_idx > -1) {
            return ds_list_find_value(ds_list_find_value(t_node, xf_prop_attrv), t_idx);
        }
    }
    else if (t_all) {
        // If the user wanted all, return alt
        if (argument_count >= 3) {
            return argument[2];
        }
        
        return noone;
    }
    
    // Get the other 2 arguments
    if (argument_count >= 3) {
        var t_alt = argument[2];
        
        if (argument_count == 4) {
            var t_set = argument[3];
        }
        else {
            return t_alt;
        }
    }
    else {
        return noone;
    }

    // Set alt value?
    if (t_set) {
        if (!t_exists) {
            // Create attribute lists if needed
            t_attr_keys = ds_list_create();
            var t_attr_vals = ds_list_create();
            ds_list_replace(t_node, xf_prop_attrk, t_attr_keys);
            ds_list_replace(t_node, xf_prop_attrv, t_attr_vals);
            ds_list_mark_as_list(t_node, xf_prop_attrk);
            ds_list_mark_as_list(t_node, xf_prop_attrv);
        }
        else {
            var t_attr_vals = ds_list_find_value(t_node, xf_prop_attrv);
        }
        
        // Add alt value
        ds_list_add(t_attr_keys, t_key);
        ds_list_add(t_attr_vals, t_alt);
        
        // Callback
        if (p_call_ev_set != noone && p_ev_set_on) {
            script_execute(p_call_ev_set, xf_ev_set_att, t_node, t_key, t_alt, true);
        }
    }
    
    return t_alt;
}
