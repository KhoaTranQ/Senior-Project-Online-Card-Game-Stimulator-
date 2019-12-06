/// xf_copy(node,all)
// Creates and returns a deep (all) or shallow copy of the given node.
// See: www.xmlfir.com/xf-copy


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count == 0) {
        return xf_log(-1, xf_copy, 1, "Missing argument count: 1.");
    }
    
    // Get arguments
    var t_node = argument[0];
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(-1, xf_copy, 1, "argument0 is not a valid xml node.");
    }
    
    // Validate the node type
    var t_type = ds_list_find_value(t_node, xf_prop_type);
    
    if (t_type < 1 || t_type > 6) {
        // Invalid type
        return xf_log(-1, xf_copy, 1, "argument0 is not a valid xml structure.");
    }
    
    // Reset error
    p_error = "";
    
    // Get the rest of the arguments
    if (argument_count >= 2) {
        var t_all = real(argument[1]);
        
        // Convert true to "all"
        if (t_all) t_all = all;
        
        if (argument_count == 3) {
            var t_parent = argument[2];
        }
        else {
            var t_parent = noone;
        } 
    }
    else {
        var t_all    = all;
        var t_parent = noone;
    }
    
    // Clone attributes and create the clone
    var t_clone = ds_list_create();
    
    if (t_type == xf_type_element) {
        var t_attr_keys = ds_list_find_value(t_node, xf_prop_attrk);
        
        if (ds_exists(t_attr_keys, ds_type_list)) {
            // Copy attributes
            var t_clone_attr_keys = ds_list_create();
            var t_clone_attr_vals = ds_list_create();
            
            ds_list_copy(t_clone_attr_keys, t_attr_keys);
            ds_list_copy(t_clone_attr_vals, ds_list_find_value(t_node, xf_prop_attrv));
            
            ds_list_add(t_clone, t_type, 
                ds_list_find_value(t_node, xf_prop_value), 
                t_parent, -1, 
                t_clone_attr_keys, t_clone_attr_vals,
                noone
            );
            
            ds_list_mark_as_list(t_clone, xf_prop_attrk);
            ds_list_mark_as_list(t_clone, xf_prop_attrv);
        }
        else {
            // This node has no attributes
            ds_list_add(t_clone, t_type, 
                ds_list_find_value(t_node, xf_prop_value), 
                t_parent, -1, -1, -1, noone
            );
        }
    }
    else {
        // This node does not support attributes
        ds_list_add(t_clone, t_type, 
            ds_list_find_value(t_node, xf_prop_value), 
            t_parent, -1, -1, -1, noone
        );
    }
    
    // Return the clone?
    if (t_all != all || (t_type != xf_type_fragment && t_type != xf_type_element)) {
        // Callback
        if (argument_count != 3 && p_ev_copy_on && p_call_ev_copy != noone) {
            script_execute(p_call_ev_copy, xf_ev_copy, t_node, t_clone, t_all);
        }
        
        return t_clone;
    }
    
    // Clone the children
    var t_children = ds_list_find_value(t_node, xf_prop_children);
    
    // Check if it has any...
    if (!ds_exists(t_children, ds_type_list)) {
        // Callback
        if (argument_count != 3 && p_ev_copy_on && p_call_ev_copy != noone) {
            script_execute(p_call_ev_copy, xf_ev_copy, t_node, t_clone, t_all);
        }
        
        return t_clone;
    }
    else if (ds_list_empty(t_children)) {
        // Callback
        if (argument_count != 3 && p_ev_copy_on && p_call_ev_copy != noone) {
            script_execute(p_call_ev_copy, xf_ev_copy, t_node, t_clone, t_all);
        }
        
        return t_clone;
    }
    
    
    var t_clone_children = ds_list_create();
    var t_count = ds_list_size(t_children);
    var t_child = -1;
    var t_i     = 0;
    
    // Clone the children
    while (t_i < t_count)
    {
        t_child = xf_copy(ds_list_find_value(t_children, t_i), t_all, t_clone);
        
        if (t_child == -1) {
            ds_list_destroy(t_clone_children);
            ds_list_destroy(t_clone);
            return -1;
        }
        
        ds_list_add(t_clone_children, t_child);
        ds_list_mark_as_list(t_clone_children, t_i);
        
        t_i++;
    }
    
    // Attach children to clone
    ds_list_replace(t_clone, xf_prop_children, t_clone_children);
    ds_list_mark_as_list(t_clone, xf_prop_children);
    
    // Callback
    if (argument_count != 3 && p_ev_copy_on && p_call_ev_copy != noone) {
        script_execute(p_call_ev_copy, xf_ev_copy, t_node, t_clone, t_all);
    }
        
    return t_clone;
}
