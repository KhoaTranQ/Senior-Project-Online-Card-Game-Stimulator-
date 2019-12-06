/// xf_set_value(node,value)
// Sets the value of the given node.
// See: www.xmlfir.com/xf-set-value


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Get arguments
    var t_node = argument0;
    var t_val  = argument1;
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(xf_set_value, 1, "argument0 is not a valid data structure.");
    }
    
    // Validate type
    if (ds_list_find_value(t_node, xf_prop_type) == xf_type_fragment) {
        return xf_log(xf_set_value, 1, "argument0 cannot have a value.");
    }
    
    if (is_real(t_val)) {
        xf_log(xf_set_value, 2, "argument1 should be a string.");
        t_val = string(t_val);
    }
    
    // Reset error
    p_error = "";
    
    ds_list_replace(t_node, xf_prop_value, t_val);
    
    // Callback
    if (p_call_ev_value != noone && p_ev_value_on) {
        script_execute(p_call_ev_value, xf_ev_set_value, t_node, t_val);
    }
    
    return true;
}
