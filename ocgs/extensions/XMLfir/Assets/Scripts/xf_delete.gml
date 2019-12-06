/// xf_delete(node,name,...)
// Deletes up to 14 attributes (name) from the given element node.
// See: www.xmlfir.com/xf-delete


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Try simple node validation
    if (argument_count < 2) {
        return xf_log(xf_delete, 1, "Missing argument count: " +  string(2 - argument_count) + ".");
    }
    
    // Get node argument
    var t_node = argument[0];
    
    // Try simple node validate
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(xf_delete, 1, "argument0 is not a valid xml node.");
    }
    
    // Reset error
    p_error = "";
    
    // Get attributes
    var t_attr_keys = ds_list_find_value(t_node, xf_prop_attrk);
    
    if (!ds_exists(t_attr_keys, ds_type_list)) {
        return true;
    }
    
    var t_attr_vals = ds_list_find_value(t_node, xf_prop_attrv);
    var t_i = 1;
    var t_k = -1;
    
    // Loop through the arguments and delete each attr
    if (p_call_ev_delete != noone && p_ev_delete_on) {
        // With callback
        var t_kstr = "";
        
        while (t_i < argument_count)
        {
            t_kstr = string(argument[t_i]);
            t_k    = ds_list_find_index(t_attr_keys, t_kstr);
            
            if (t_k > -1) {
                // Callback
                script_execute(p_call_ev_delete, xf_ev_delete_att, t_node, t_kstr);
                
                ds_list_delete(t_attr_keys, t_k);
                ds_list_delete(t_attr_vals, t_k);
            }
            
            t_i++;
        }
    }
    else {
        // Without callback
        while (t_i < argument_count)
        {
            t_k = ds_list_find_index(t_attr_keys, string(argument[t_i]));
            
            if (t_k > -1) {
                ds_list_delete(t_attr_keys, t_k);
                ds_list_delete(t_attr_vals, t_k);
            }
            
            t_i++;
        }
    }
    
    // Check if attributes are empty
    if (ds_list_empty(t_attr_keys)) {
        // Update the node
        ds_list_destroy(t_attr_keys);
        ds_list_destroy(t_attr_vals);
        ds_list_replace(t_node, xf_prop_attrk, -1);
        ds_list_replace(t_node, xf_prop_attrv, -1);
    }
    
    return true;
}