/// xf_add_copy(parent,node,...)
// Copies and appends up to 14 nodes at the end of the given parent node.
// See: www.xmlfir.com/xf-add-copy


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count < 2) {
        return xf_log(xf_add_copy, 1, "Missing argument count: " +  string(2 - argument_count) + ".");
    }
    
    // Get node argument
    var t_node = argument[0];
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(xf_add_copy, 1, "argument0 is not a valid xml node.");
    }
    
    // Validate type
    var t_type = ds_list_find_value(t_node, xf_prop_type);
    
    if (t_type != xf_type_element && t_type != xf_type_fragment) {
        return xf_log(xf_add_copy, 1, "argument0 does not support nested elements.");
    }
    
    // First pass: Copy all arguments
    var t_arg_count = argument_count;
    var t_copies    = ds_list_create();
    var t_copy = -1;
    var t_val  = 0;
    var t_i    = 1;
    
    // Disable callback temporarily
    var t_call = p_call_ev_copy;
    p_call_ev_copy = noone;
    
    while (t_i < t_arg_count)
    {
        t_val = argument[t_i];
        
        // Try to copy the value
        t_copy = xf_copy(t_val, all);
        
        // Check for error
        if (t_copy == -1) {
            p_call_ev_copy = t_call;
            ds_list_destroy(t_copies);
            return xf_log(xf_add_copy, 1, "Failed to copy argument" + string(t_i) + ".");
        }
        
        // Save the copy for later
        ds_list_add(t_copies, t_copy);
        ds_list_mark_as_list(t_copies, t_i - 1);
        
        t_i++;
    }
    
    // Re-establish the copy callback
    p_call_ev_copy = t_call;
    
    // Reset error
    p_error = "";
    
    // Init the node list of children
    var t_list = ds_list_find_value(t_node, xf_prop_children);
    
    if (!ds_exists(t_list, ds_type_list)) {
        t_list = ds_list_create();
        
        ds_list_replace(t_node, xf_prop_children, t_list);
        ds_list_mark_as_list(t_node, xf_prop_children);
    }
    
    
    // Second pass: Add children
    var t_original_children = noone;
    var t_original_child    = noone;
    
    var t_children = -1;
    var t_child    = -1;
    var t_idx      = -1;
    var t_count2   = 0;
    
    t_i = 0;
    t_arg_count = ds_list_size(t_copies);
    
    while (t_i < t_arg_count)
    {
        t_val = ds_list_find_value(t_copies, t_i);
        ds_list_replace(t_copies, t_i, -1);
            
        // Get node type
        t_type = ds_list_find_value(t_val, xf_prop_type);
        
        if (t_type != xf_type_fragment) {
            // Value is not a fragment
            
            // Copy callback
            if (p_call_ev_copy != noone && p_ev_copy_on) {
                script_execute(p_call_ev_copy, xf_ev_copy, argument[t_i + 1], t_val, all);
            }
        
            // Attach to new parent
            ds_list_add(t_list, t_val);
            ds_list_mark_as_list(t_list, ds_list_size(t_list) - 1);
            ds_list_replace(t_val, xf_prop_parent, t_node);
            
            // Relocate callback
            if (p_call_ev_relocate != noone && p_ev_relocate_on) {
                // script, event, node, prev parent, new parent, new index
                script_execute(p_call_ev_relocate, xf_ev_relocate, t_val, noone, t_node, ds_list_size(t_list) - 1);
            }
            
            t_i++;
            continue;
        }
        
        // Fragments are never added to the dom; only their children!
        t_children = ds_list_find_value(t_val, xf_prop_children);
        
        if (!ds_exists(t_children, ds_type_list)) {
            ds_list_destroy(t_val);
            t_i++;
            continue;
        }
        else if (ds_list_empty(t_children)) {
            ds_list_destroy(t_val);
            t_i++;
            continue;
        }
        
        // Add fragment children to the node
        t_original_children = ds_list_find_value(argument[t_i + 1], xf_prop_children);
        t_count2 = ds_list_size(t_children);
        t_idx    = 0;
        
        while (t_idx < t_count2)
        {
            t_child = ds_list_find_value(t_children, t_idx);
            
            // Replace index
            ds_list_replace(t_children, t_idx, -1);
            
            // Copy callback
            if (p_call_ev_copy != noone && p_ev_copy_on) {
                t_original_child = ds_list_find_value(t_original_children, t_idx);
                ds_list_replace(t_child, xf_prop_parent, noone);
                script_execute(p_call_ev_copy, xf_ev_copy, t_original_child, t_child, all);
            }
            
            // Attach to new parent
            ds_list_add(t_list, t_child);
            ds_list_mark_as_list(t_list, ds_list_size(t_list) - 1);
            ds_list_replace(t_child, xf_prop_parent, t_node);
            
            // Relocate callback
            if (p_call_ev_relocate != noone && p_ev_relocate_on) {
                // script, event, node, prev parent, new parent, new index
                script_execute(p_call_ev_relocate, xf_ev_relocate, t_child, noone, t_node, ds_list_size(t_list) - 1);
            }
            
            t_idx++;
        }
        
        // Destroy the fragment
        xf_destroy(t_val);
        
        t_i++;
    }
    
    // Destroy copy list
    ds_list_destroy(t_copies);

    return true;
}