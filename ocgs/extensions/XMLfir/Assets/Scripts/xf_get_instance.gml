/// xf_get_instance(node)
// Returns the instance id of the given node.
// See: www.xmlfir.com/xf-get-instance


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Try simple node validation
    if (!is_real(argument0) || !ds_exists(argument0, ds_type_list) || ds_list_size(argument0) != xf_prop_size) {
        return xf_log("", xf_get_instance, 1, "argument0 is not a valid xml node.");
    }
    
    // Reset error
    p_error = "";
    
    return ds_list_find_value(argument0, xf_prop_instance);
}
