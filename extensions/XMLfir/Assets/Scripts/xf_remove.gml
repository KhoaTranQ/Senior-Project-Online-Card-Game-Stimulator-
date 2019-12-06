/// xf_remove(node)
// Detaches the given node from its current parent element.
// See: www.xmlfir.com/xf-remove


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Get arguments
    var t_node = argument0;
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(t_node, xf_remove, 1, "argument0 is not a valid xml node.");
    }
    
    // Reset error 
    p_error = "";
    
    // Get the parent node
    var t_parent = ds_list_find_value(t_node, xf_prop_parent);
    
    if (t_parent == noone) {
        return t_node;
    }
    else if (!ds_exists(t_parent, ds_type_list) || ds_list_size(t_parent) != xf_prop_size) {
        return xf_log(t_node, xf_remove, 1, "argument0 parent is not a valid xml node.");
    }
    
    // Detach from parent
    var t_siblings = ds_list_find_value(t_parent, xf_prop_children);
    
    // Validate children
    if (!ds_exists(t_siblings, ds_type_list)) {
        return t_node;
    }
    
    // Find the node index
    var t_idx = ds_list_size(t_siblings) - 1;
    
    while (t_idx > -1) 
    {
        if (ds_list_find_value(t_siblings, t_idx) == t_node) {
            break;
        }
        t_idx--;
    }
    
    if (t_idx == -1) {
        return xf_log(t_node, xf_remove, 1, "argument0 index not found.");
    }
    
    // Delete the index
    ds_list_delete(t_siblings, t_idx);
    ds_list_replace(t_node, xf_prop_parent, noone);
    
    // Check if parent child list is empty
    if (ds_list_empty(t_siblings)) {
        ds_list_destroy(t_siblings);
        ds_list_replace(t_parent, xf_prop_children, -1);
    }
    
    // Relocate callback
    if (p_call_ev_relocate != noone && p_ev_relocate_on) {
        // script, event, node, prev parent, new parent, new index
        script_execute(p_call_ev_relocate, xf_ev_relocate, t_node, t_parent, noone, -1);
    }
    
    return t_node;
}