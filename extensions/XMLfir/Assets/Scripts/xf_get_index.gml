/// xf_get_index(node)
// Returns the position index of the given node.
// See: www.xmlfir.com/xf-get-index


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    var t_node = argument0;
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(-1, xf_get_index, 1, "argument0 is not a valid xml node.");
    }
    
    // Reset error
    p_error = "";
    
    // Validate the parent
    var t_parent = ds_list_find_value(t_node, xf_prop_parent);
    
    if (t_parent == noone) {
        return -1;
    }
    else if (!ds_exists(t_parent, ds_type_list) || ds_list_size(t_parent) != xf_prop_size) {
        return xf_log(-1, xf_get_index, 1, "argument0 parent is not a valid xml node.");
    }
    
    // Validate the siblings
    var t_siblings = ds_list_find_value(t_parent, xf_prop_children);
    
    if (!ds_exists(t_siblings, ds_type_list)) {
        xf_log(-1, xf_get_index, 1, "argument0 parent node has no children.");
    }
    
    // Find the index
    var t_idx = ds_list_size(t_siblings) - 1;
    
    while (t_idx > -1)
    {
        if (ds_list_find_value(t_siblings, t_idx) == t_node) {
            break;
        }
        
        t_idx--;
    }
    
    return t_idx;
}