/// xf_destroy(node)
// Destroys the given node including its descendants.
// See: www.xmlfir.com/xf-destroy


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Try simple node validation
    if (!is_real(argument0) || !ds_exists(argument0, ds_type_list) || ds_list_size(argument0) != xf_prop_size) {
        return xf_log(true, xf_destroy, 2, "argument0 is not a valid xml node.");
    }
    
    // Reset error
    p_error = "";
    
    // Callback
    if (p_call_ev_destroy != noone && p_ev_destroy_on) {
        script_execute(p_call_ev_destroy, xf_ev_destroy, argument0);
    }
    
    // Get the parent node
    var t_parent = ds_list_find_value(argument0, xf_prop_parent);
    
    if (t_parent == noone) {
        // No parent; just destroy the node
        ds_list_destroy(argument0);
        return true;
    }
    
    // Destroy the node anyway if it has a parent
    ds_list_destroy(argument0);
    
    // Validate parent node
    if (!is_real(t_parent) || !ds_exists(t_parent, ds_type_list) || ds_list_size(t_parent) != xf_prop_size) {
        return xf_log(true, xf_destroy, 1, "argument0 parent is not a valid xml node.");
    }
    
    // Detach from parent
    var t_children = ds_list_find_value(t_parent, xf_prop_children);
    
    // Validate children
    if (!ds_exists(t_children, ds_type_list)) {
        return xf_log(true, xf_destroy, 2, "Parent node has no children.");
    }
    
    // Find the node index
    var t_idx = ds_list_size(t_children) - 1;
    
    while (t_idx > -1) 
    {
        if (ds_list_find_value(t_children, t_idx) == argument0) {
            break;
        }
        
        t_idx--;
    }
    
    if (t_idx == -1) {
        return xf_log(true, xf_destroy, 2, "Node index not found.");
    }
    
    // Delete the index
    ds_list_delete(t_children, t_idx);
    
    // Check if child list is empty
    if (ds_list_empty(t_children)) {
        ds_list_replace(t_parent, xf_prop_children, -1);
        ds_list_destroy(t_children);
    }
    
    return true;
}