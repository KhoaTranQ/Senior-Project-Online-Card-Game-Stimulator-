/// xf_size(node,context)
// Returns the size of the node in the given context
// See: www.xmlfir.com/xf-size


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count == 0) {
        return xf_log(0, xf_size, 1, "Missing argument count: 1.");
    }
    
    // Get node arg
    var t_node = real(argument[0]);
    
    // Try simple node validation
    if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
        return xf_log(0, xf_size, 1, "argument0 is not a valid xml node.");
    }
    
    // Reset error
    p_error = "";
    
    // Get node type
    var t_type = ds_list_find_value(t_node, xf_prop_type);
    
    // Get the 2nd argument
    if (argument_count == 2) {
        var t_all = argument[1];
        if (t_all) t_all = all;
    }
    else {
        switch (t_type)
        {
            case xf_type_comment:
            case xf_type_cdata:
            case xf_type_text:
                var t_all = self;
                break;
                
            default:
                var t_all = 0;
                break;
        }
    }
    
    // If the second arg is "self"...
    if (t_all == self) {
        switch (t_type)
        {
            case xf_type_element:
                // ...Return attribute count
                var t_keys = ds_list_find_value(t_node, xf_prop_attrk);
                if (!ds_exists(t_keys, ds_type_list)) {
                    return 0;
                }
                return ds_list_size(t_keys);
                break;
                
            case xf_type_comment:
            case xf_type_cdata:
            case xf_type_text:
                // ...Return string length
                var t_value = ds_list_find_value(t_node, xf_prop_value);
                return string_length(t_value);
                break;
                
            case xf_type_fragment:
                // ...Return nothing
                return 0;
                break;
        }
    }
    
    // If the second argument is "all" or 0...
    
    if (t_type != xf_type_element && t_type != xf_type_fragment) {
        // Only works on tags with children and fragment nodes...
        return 0;
    }
    
    // Get the children
    var t_children = ds_list_find_value(t_node, xf_prop_children);
    
    if (!ds_exists(t_children, ds_type_list)) {
        return 0;
    }
    
    if (t_all != all) {
        return ds_list_size(t_children);
    }
    
    // Count all descendants
    var t_count = ds_list_size(t_children);
    var t_num   = t_count;
    var t_i = 0;
    
    // Loop recursively
    while (t_i < t_num)
    {
        t_count += xf_size(ds_list_find_value(t_children, t_i), all);
        t_i++;
    }
    
    return t_count;
}
