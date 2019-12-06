/// xf_get_prev(node)
// Returns the id of the sibling positioned before to the given node.
// See: www.xmlfir.com/xf-get-prev


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Try simple node validation
    if (!is_real(argument0) || !ds_exists(argument0, ds_type_list) || ds_list_size(argument0) != xf_prop_size) {
        return xf_log(noone, xf_get_prev, 1, "argument0 is not a valid xml node.");
    }
    
    // Reset error
    p_error = "";
    
    // Get the parent node
    var t_parent = ds_list_find_value(argument0, xf_prop_parent);
    
    if (t_parent == noone) {
        return noone;
    }
    else if (!ds_exists(t_parent, ds_type_list) || ds_list_size(t_parent) != xf_prop_size) {
        return xf_log(noone, xf_get_prev, 2, "Parent node is not a valid xml structure.");
    }
    
    // Get siblings
    var t_siblings = ds_list_find_value(t_parent, xf_prop_children);
    
    if (!ds_exists(t_siblings, ds_type_list)) {
        return noone;
    }
    
    // Get the index
    var t_count = ds_list_size(t_siblings);
    var t_idx   = t_count - 1;
    
    while (t_idx > -1)
    {
        if (ds_list_find_value(t_siblings, t_idx) == argument0) {
            break;
        }
        
        t_idx--;
    }
    
    if (t_idx == -1) {
        return xf_log(noone, xf_get_prev, 1, "Index not found.");
    }
    else if (t_idx == 0) {
        // This node is the first sibling
        return noone;
    }
    
    return ds_list_find_value(t_siblings, t_idx - 1);
}