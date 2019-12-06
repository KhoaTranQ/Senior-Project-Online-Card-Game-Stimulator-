/// xf_get_child(parent,index)
// Returns the child node held at the given position index of the given parent element.
// See: www.xmlfir.com/xf-get-child


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Try simple node validation
    if (!is_real(argument0) || !ds_exists(argument0, ds_type_list) || ds_list_size(argument0) != xf_prop_size) {
        return xf_log(-1, xf_get_child, 1, "argument0 is not a valid xml node.");
    }
    
    // Reset error
    p_error = "";
    
    // Get the children
    var t_children = ds_list_find_value(argument0, xf_prop_children);
    
    // Check if this element has children
    if (!ds_exists(t_children, ds_type_list)) {
        return -1;
    }
    
    var t_pos   = real(argument1);
    var t_count = ds_list_size(t_children);
    
    // Wrap position
    if (t_pos >= t_count) {
        t_pos = max(0, t_count - 1);
    }
    else if (t_pos < 0) {
        t_pos = max(0, t_count + t_pos);
    }
    
    return ds_list_find_value(t_children, t_pos);
}
