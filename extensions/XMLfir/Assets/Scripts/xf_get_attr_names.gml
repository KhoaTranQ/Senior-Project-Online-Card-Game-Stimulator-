/// xf_get_attr_names(node)
// Returns the attribute names of a given element node in a ds_list.
// See: www.xmlfir.com/xf-get-attr-names


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Try simple node validation
    if (!is_real(argument0) || !ds_exists(argument0, ds_type_list) || ds_list_size(argument0) != xf_prop_size) {
        return xf_log(-1, xf_get_attr_names, 1, "argument0 is not a valid xml node.");
    }
    
    // Validate type
    var t_type = ds_list_find_value(argument0, xf_prop_type);
    
    if (t_type != xf_type_element) {
        return -1;
    }
    
    // Reset error
    p_error = "";
    
    // Get the attribute names
    var t_att_keys = ds_list_find_value(argument0, xf_prop_attrk);
    
    if (!ds_exists(t_att_keys, ds_type_list)) {
        return -1;
    }
    
    // Copy the list
    var t_copy = ds_list_create();
    ds_list_copy(t_copy, t_att_keys);
    
    return t_copy;
}