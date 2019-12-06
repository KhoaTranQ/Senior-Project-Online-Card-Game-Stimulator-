/// xf_add(parent,node,...)
// Appends up to 14 nodes at the end of the given parent node.
// See: www.xmlfir.com/xf-add


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count < 2) {
        return xf_log(xf_add, 1, "Missing argument count: " +  string(2 - argument_count) + ".");
    }
    
    // Get node argument
    var t_node = argument[0];
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(xf_add, 1, "argument0 is not a valid xml node.");
    }
    
    // Validate type
    var t_type = ds_list_find_value(t_node, xf_prop_type);
    
    if (t_type != xf_type_element && t_type != xf_type_fragment) {
        return xf_log(xf_add, 1, "argument0 does not support nested elements.");
    }
    
    var t_parent = ds_list_find_value(t_node, xf_prop_parent);
    
    
    // First pass: Validate the arguments
    var t_arg_count = argument_count;
    var t_val_type  = 0;
    var t_list = -1;
    var t_val  = 0;
    var t_i    = 1;
    
    while (t_i < t_arg_count)
    {
        t_val = argument[t_i];
        
        // Try simple node validate
        if (!is_real(t_val) || !ds_exists(t_val, ds_type_list) || ds_list_size(t_val) != xf_prop_size) {
            return xf_log(xf_add, 1, "argument" + string(t_i) + " is not a valid xml node.");
        }
        
        // Get node type
        t_val_type = ds_list_find_value(t_val, xf_prop_type);
        
        // Make sure the parent is not a child of val
        if (t_parent != noone && (t_val_type == xf_type_element || t_val_type == xf_type_fragment)) {
            // Get the list of children for this value
            t_list = ds_list_create();
            ds_list_add(t_list, t_val);
            xf_query_descendant(t_list, true);
            
            // Check for error
            if (t_list == -1) {
                return xf_log(xf_add, 1, "argument" + string(t_i) + " contains an invalid xml node.");
            }
            
            if (ds_list_find_index(t_list, t_node) > -1) {
                ds_list_destroy(t_list);
                return xf_log(xf_add, 1, "Cannot make argument" + string(t_i) + " a child of itself.");
            }
            
            // Destroy the list
            ds_list_destroy(t_list);
        }
        
        t_i++;
    }
    
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
    var t_parent   = noone;
    var t_children = -1;
    var t_child    = -1;
    var t_idx      = -1;
    var t_count2   = 0;
    
    t_i = 1;
    
    while (t_i < t_arg_count)
    {
        t_val = argument[t_i];
        
        // Get node type
        t_val_type = ds_list_find_value(t_val, xf_prop_type);
        
        if (t_val_type != xf_type_fragment) 
        {
            // Value is not a fragment...
            t_parent = ds_list_find_value(t_val, xf_prop_parent);
            
            if (t_parent == noone) {
                // Node has no parent
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
            
            // Detach node from current parent
            if (ds_exists(t_parent, ds_type_list)) {
                t_children = ds_list_find_value(t_parent, xf_prop_children);
                
                if (ds_exists(t_children, ds_type_list)) {
                    // Due to a bug in v1.4.1567, this will always return -1
                    // t_idx = ds_list_find_index(t_children, t_val);
                    // Have to find the index manually :(
                    t_idx = ds_list_size(t_children) - 1;
                    
                    while (t_idx > -1)
                    {
                        if (ds_list_find_value(t_children, t_idx) == t_val) break;
                        t_idx--;
                    }
                    
                    if (t_idx == -1) {
                        xf_log(xf_add, 2, "argument" + string(t_i) + " has an invalid parent element.");
                    }
                    else {
                        // Detach from parent
                        ds_list_delete(t_children, t_idx);
                        
                        // Clean-up parent
                        if (ds_list_empty(t_children) && t_parent != t_node) {
                            ds_list_destroy(t_children);
                            ds_list_replace(t_parent, xf_prop_children, -1);
                        }
                    }
                }
                else {
                    xf_log(xf_add, 2, "argument" + string(t_i) + " has an invalid parent element.");
                }
            }
            else {
                xf_log(xf_add, 2, "argument" + string(t_i) + " has an invalid parent element.");
            }
            
            // Attach to new parent
            ds_list_add(t_list, t_val);
            ds_list_mark_as_list(t_list, ds_list_size(t_list) - 1);
            ds_list_replace(t_val, xf_prop_parent, t_node);
            
            // Relocate callback
            if (p_call_ev_relocate != noone && p_ev_relocate_on) {
                // script, event, node, prev parent, new parent, new index
                script_execute(p_call_ev_relocate, xf_ev_relocate, t_val, t_parent, t_node, ds_list_size(t_list) - 1);
            }
            
            // Continue
            t_i++;
            continue;
        }

        // Fragments are never added; only their children!
        t_children = ds_list_find_value(t_val, xf_prop_children);
        
        if (!ds_exists(t_children, ds_type_list) || ds_list_empty(t_children)) {
            t_i++;
            continue;
        }
        
        t_count2 = ds_list_size(t_children);
        t_idx    = 0;

        // Add fragment children to the node
        while (t_idx < t_count2)
        {
            t_child = ds_list_find_value(t_children, t_idx);
            
            // Attach to new parent
            ds_list_add(t_list, t_child);
            ds_list_mark_as_list(t_list, ds_list_size(t_list) - 1);
            ds_list_replace(t_child, xf_prop_parent, t_node);

            // Replace index
            ds_list_replace(t_children, t_idx, -1);

            // Relocate callback
            if (p_call_ev_relocate != noone && p_ev_relocate_on) {
                // script, event, node, prev parent, new parent, new index
                script_execute(p_call_ev_relocate, xf_ev_relocate, t_child, t_val, t_node, ds_list_size(t_list) - 1);
            }
            
            t_idx++;
        }
        
        // Delete fragment child list
        ds_list_destroy(t_children);
        ds_list_replace(t_val, xf_prop_children, -1);
        
        t_i++;
    }

    return true;
}