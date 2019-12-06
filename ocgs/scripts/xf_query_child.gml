/// xf_query_child(list)
// Discards the nodes currently held in the given ds_list and selects their child nodes.
// See: www.xmlfir.com/xf-query-child


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate list
    var t_list = argument0;
    
    if (!ds_exists(t_list, ds_type_list)) {
        return xf_log(xf_query_child, 1, "argument0 is not a valid ds_list.");
    }

    // Reset error
    p_error = "";
    
    var t_count = ds_list_size(t_list);
    var t_node  = 0;
    var t_i     = 0;
    
    var t_children = -1;
    var t_child    = -1;
    var t_count2   = 0;
    var t_j        = 0;


    while (t_i < t_count)
    {
        t_node = ds_list_find_value(t_list, t_i);

        ds_list_delete(t_list, t_i);
        t_count--;
        
        if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
            continue;
        }
        
        t_children = ds_list_find_value(t_node, xf_prop_children);
        
        if (!ds_exists(t_children, ds_type_list)) {
            continue;
        }
        
        t_count2 = ds_list_size(t_children);
        t_j      = 0;
        
        while (t_j < t_count2) 
        {
            t_child = ds_list_find_value(t_children, t_j);
            
            if (!is_real(t_child) || !ds_exists(t_child, ds_type_list) || ds_list_size(t_child) != xf_prop_size) {
                t_j++;
                continue;
            }
            
            if (ds_list_find_index(t_list, t_child) == -1) {
                ds_list_insert(t_list, t_i, t_child);
                t_count++;
                t_i++;
            }

            t_j++;
        }
    }
    

    return true;
}
