/// xf_get_children(parent)
// Creates and returns a ds_list containing all child nodes of a given parent node.
// See: www.xmlfir.com/xf-get-children


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Try simple node validation
    if (!is_real(argument0) || !ds_exists(argument0, ds_type_list) || ds_list_size(argument0) != xf_prop_size) {
        return xf_log(-1, xf_get_children, 1, "argument0 is not a valid xml node.");
    }
    
    // Validate type
    var t_type = ds_list_find_value(argument0, xf_prop_type);
    
    if (t_type != xf_type_element && t_type != xf_type_fragment) {
        return -1;
    }
    
    // Reset error
    p_error = "";
    
    // Get the children
    var t_children = ds_list_find_value(argument0, xf_prop_children);
    
    // Check if this element has children
    if (!ds_exists(t_children, ds_type_list)) {
        return -1;
    }
    
    // Copy the children list
    var t_i = 0;
    var t_count = ds_list_size(t_children);
    var t_list  = ds_list_create();
    

    while (t_i < t_count)
    {
        ds_list_add(t_list, ds_list_find_value(t_children, t_i));
        t_i++;
    }
    
    return t_list;
}