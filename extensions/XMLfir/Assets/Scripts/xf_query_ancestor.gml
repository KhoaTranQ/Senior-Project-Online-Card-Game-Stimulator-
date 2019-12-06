/// xf_query_ancestor(list,self)
// Selects all ancestors of the nodes held in the given ds_list.
// See: www.xmlfir.com/xf-query-ancestor


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count == 0) {
        return xf_log(xf_query_ancestor, 1, "Missing argument count: 1.");
    }
        
    // Validate list
    var t_list = argument[0];
    
    if (!ds_exists(t_list, ds_type_list)) {
        return xf_log(xf_query_ancestor, 1, "argument0 is not a valid ds_list.");
    }

    // Reset error
    p_error = "";
    
    // Get the other argument
    if (argument_count >= 2) {
        var t_self = real(argument[1]);
    }
    else {
        var t_self = false;
    }
        
    var t_count  = ds_list_size(t_list);
    var t_parent = noone;
    var t_node   = 0;
    var t_i      = 0;
    var t_num    = 0;
    
    if (t_self) {
        // Including self
        while (t_i < t_count)
        {
            t_node = ds_list_find_value(t_list, t_i);

            if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                ds_list_delete(t_list, t_i);
                t_count--;
                continue;
            }
            
            t_num    = 0;
            t_parent = ds_list_find_value(t_node, xf_prop_parent);
            
            while (ds_exists(t_parent, ds_type_list))
            {
                if (ds_list_find_index(t_list, t_parent) != -1) {
                    t_parent = ds_list_find_value(t_parent, xf_prop_parent);
                    continue;
                }
                
                ds_list_insert(t_list, t_i, t_parent);
                t_count++;
                t_num++;
                
                t_parent = ds_list_find_value(t_parent, xf_prop_parent);
            }
            
            t_i += t_num + 1;
        }
    }
    else {
        // Excluding self
        while (t_i < t_count)
        {
            t_node = ds_list_find_value(t_list, t_i);
            
            ds_list_delete(t_list, t_i);
            t_count--;
                
            if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                continue;
            }
            
            t_num    = 0;
            t_parent = ds_list_find_value(t_node, xf_prop_parent);
            
            while (ds_exists(t_parent, ds_type_list))
            {
                if (ds_list_find_index(t_list, t_parent) != -1) {
                    t_parent = ds_list_find_value(t_parent, xf_prop_parent);
                    continue;
                }
                
                ds_list_insert(t_list, t_i, t_parent);
                t_count++;
                t_num++;
                
                t_parent = ds_list_find_value(t_parent, xf_prop_parent);
            }
            
            t_i += t_num;
        }
    }
    
    return true;
}