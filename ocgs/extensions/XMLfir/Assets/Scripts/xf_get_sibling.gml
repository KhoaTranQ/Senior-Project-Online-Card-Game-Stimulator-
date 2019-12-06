/// xf_get_sibling(node,index)
// Returns the sibling held at the given position index of the given node.
// See: www.xmlfir.com/xf-get-sibling


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Get arguments
    var t_node = argument0;
    var t_pos  = real(argument1);

    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(-1, xf_get_sibling, 1, "argument0 is not a valid xml node.");
    }
    
    // Get the parent node
    var t_parent = ds_list_find_value(t_node, xf_prop_parent);
    
    if (t_parent == noone) {
        return -1;
    }
    else if (!ds_exists(t_parent, ds_type_list) || ds_list_size(t_parent) != xf_prop_size) {
        return xf_log(-1, xf_get_sibling, 1, "argument0 parent is not a valid xml node.");
    }
    
    // Reset error
    p_error = "";
    
    // Get siblings
    var t_siblings = ds_list_find_value(t_parent, xf_prop_children);
    
    if (!ds_exists(t_siblings, ds_type_list)) {
        return -1;
    }
    
    var t_count = ds_list_size(t_siblings);
    
    // Wrap position
    if (t_pos >= t_count) {
        t_pos = max(0, t_count - 1);
    }
    else if (t_pos < 0) {
        t_pos = max(0, t_count + t_pos);
    }
    
    return ds_list_find_value(t_siblings, t_pos);
}