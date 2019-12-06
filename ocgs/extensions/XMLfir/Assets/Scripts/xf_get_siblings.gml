/// xf_get_siblings(node,self)
// Creates and returns a ds_list containing all siblings of a given node
// See: www.xmlfir.com/xf-get-siblings


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count == 0) {
        return xf_log(-1, xf_get_siblings, 1, "Missing argument count: 1.");
    }
    
    // Get arguments
    var t_node = real(argument[0]);
    
    if (argument_count == 2) {
        var t_self = argument[1];
    }
    else {
        var t_self = false;
    }
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(-1, xf_get_siblings, 1, "argument0 is not a valid xml node.");
    }
    
    // Reset error
    p_error = "";
    
    // Get the parent node
    var t_parent = ds_list_find_value(t_node, xf_prop_parent);
    
    if (t_parent == noone) {
        return -1;
    }
    else if (!ds_exists(t_parent, ds_type_list) || ds_list_size(t_parent) != xf_prop_size) {
        return xf_log(-1, xf_get_siblings, 1, "argument0 parent is not a valid xml node.");
    }
    
    // Get siblings
    var t_siblings = ds_list_find_value(t_parent, xf_prop_children);
    
    if (!ds_exists(t_siblings, ds_type_list)) {
        return -1;
    }
    
    // Make a copy of the list
    var t_i = 0;
    var t_count = ds_list_size(t_siblings);
    var t_list  = ds_list_create();
    
    while (t_i < t_count)
    {
        ds_list_add(t_list, ds_list_find_value(t_siblings, t_i));
        t_i++;
    }
    
    // Exclude self?
    if (!t_self) {
        ds_list_delete(t_list, ds_list_find_index(t_list, t_node));
    }
    
    return t_list;
}