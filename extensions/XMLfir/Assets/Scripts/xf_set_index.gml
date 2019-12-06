/// xf_set_index(node,index)
// Changes the position index of the given node among its siblings.
// See: www.xmlfir.com/xf-set-index


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
        return xf_log(xf_set_index, 1, "argument0 is not a valid data structure.");
    }
    
    // Get the node parent
    var t_parent = ds_list_find_value(t_node, xf_prop_parent);
    
    // Validate the parent
    if (t_parent == noone) {
        return xf_log(xf_set_index, 1, "argument0 parent is not a valid xml node.");
    }
    else if (!is_real(t_parent) || !ds_exists(t_parent, ds_type_list) || ds_list_size(t_parent) != xf_prop_size) {
        return xf_log(xf_set_index, 1, "argument0 parent is not a valid xml node.");
    }
    
    // Get siblings
    var t_siblings = ds_list_find_value(t_parent, xf_prop_children);
    
    // Validate the siblings
    if (!ds_exists(t_siblings, ds_type_list)) {
        return xf_log(xf_set_index, 1, "argument0 parent node has no children.");
    }
    
    // Find the index
    var t_count = ds_list_size(t_siblings);
    var t_idx   = t_count - 1;
    
    while (t_idx > -1)
    {
        if (ds_list_find_value(t_siblings, t_idx) == t_node) {
            break;
        }
        
        t_idx--;
    }
    
    if (t_idx == -1) {
        return xf_log(xf_set_index, 1, "argument0 index not found.");
    }
    
    // Reset error
    p_error = "";
    
    // Wrap position
    if (t_pos >= t_count) {
        t_pos = max(0, t_count - 1);
    }
    else if (t_pos < 0) {
        t_pos = max(0, t_count + t_pos);
    }
    
    // Delete the index
    ds_list_delete(t_siblings, t_idx);
    
    // Add to new position
    ds_list_insert(t_siblings, t_pos, t_node);
    ds_list_mark_as_list(t_siblings, t_pos);
    
    // Relocate callback
    if (p_call_ev_relocate != noone && p_ev_relocate_on) {
        // script, event, node, prev parent, new parent, new index
        script_execute(p_call_ev_relocate, xf_ev_relocate, t_node, t_parent, t_parent, t_pos);
    }
    
    return true;
}
