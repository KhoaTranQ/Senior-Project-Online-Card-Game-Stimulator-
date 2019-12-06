/// xf_set_instance(node,ins)
// Links the given instance to the node
// See: www.xmlfir.com/xf-set-instance


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Get arguments
    var t_node = argument0;
    var t_ins  = argument1;
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(xf_set_instance, 1, "argument0 is not a valid data structure.");
    }
    
    // Validate the instance
    if (!is_real(t_ins)) {
        return xf_log(xf_set_instance, 1, "argument1 is not of type real.");
    }
    else if (t_ins != noone && instance_exists(t_ins) == false) {
        return xf_log(xf_set_instance, 1, "argument1 instance not found.");
    }
    
    // Reset error
    p_error = "";
    
    ds_list_replace(t_node, xf_prop_instance, t_ins);
    
    return true;
}
