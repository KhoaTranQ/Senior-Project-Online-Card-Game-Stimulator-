/// xf_get_root(node)
// Returns the root node that sits at the top of the given node within its tree structure.
// See: www.xmlfir.com/xf-get-root


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Try simple node validation
    if (!is_real(argument0) || !ds_exists(argument0, ds_type_list) || ds_list_size(argument0) != xf_prop_size) {
        return xf_log(noone, xf_get_root, 1, "argument0 is not a valid xml node.");
    }
    
    // Get the first parent
    var t_root   = argument0;
    var t_parent = ds_list_find_value(argument0, xf_prop_parent);
    
    // Loop the others
    while (t_parent != noone)
    {
        // Validate the parent
        if (!ds_exists(t_parent, ds_type_list) || ds_list_size(t_parent) != xf_prop_size) {
            return xf_log(noone, xf_get_root, 1, "argument0 parent is not a valid xml node.");
        }
        
        t_root   = t_parent;
        t_parent = ds_list_find_value(t_parent, xf_prop_parent);
    }
    
    // Reset error
    p_error = "";
    
    return t_root;
}
