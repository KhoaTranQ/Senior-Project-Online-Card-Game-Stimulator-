/// xf_query_type(list,op,type,...)
// Selects nodes in the given ds_list matching or not matching at least one of the given node types.
// See: www.xmlfir.com/xf-query-type


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count < 3) {
        return xf_log(xf_query_type, 1, "Missing argument count: " +  string(3 - argument_count) + ".");
    }
    
    // Validate list
    var t_list = argument[0];
    
    if (!ds_exists(t_list, ds_type_list)) {
        return xf_log(xf_query_type, 1, "argument0 is not a valid ds_list.");
    }
    
    // Get operator
    var t_op = string(argument[1]);
    
    if (t_op != "=" && t_op != "!=") {
        return xf_log(xf_query_type, 1, 'argument1 Must be "=" or "!=".');
    }
    
    // Reset error
    p_error = "";
    
    // Get the types
    var t_filter = ds_list_create();
    var t_i = 2;
    
    while (t_i < argument_count)
    {
        ds_list_add(t_filter, real(argument[t_i]));
        t_i++;
    }
    
    var t_count = ds_list_size(t_list);
    var t_node  = noone;
    var t_type  = noone;
    
    t_i = 0;
    
    if (t_op == "!=") {
        // Remove nodes with matching type
        while (t_i < t_count)
        {
            t_node = ds_list_find_value(t_list, t_i);

            if (ds_list_find_index(t_filter, xf_get_type(t_node)) != -1) {
                ds_list_delete(t_list, t_i);
                t_count--;
                continue;
            }
            
            t_i++;
        }
    }
    else {
        // Keep nodes with matching type
        while (t_i < t_count)
        {
            t_node = ds_list_find_value(t_list, t_i);
            
            if (ds_list_find_index(t_filter, xf_get_type(t_node)) == -1) {
                ds_list_delete(t_list, t_i);
                t_count--;
                continue;
            }
            
            t_i++;
        }
    }
    
    ds_list_destroy(t_filter);
    
    return true;
}
