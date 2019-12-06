/// xf_query_parent(list)
// Discards the nodes currently held in the given ds_list and selects their parent nodes.
// See: www.xmlfir.com/xf-query-parent


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
        return xf_log(xf_query_parent, 1, "argument0 is not a valid ds_list.");
    }

    // Reset error
    p_error = "";
    
    var t_count  = ds_list_size(t_list);
    var t_parent = noone;
    var t_node   = 0;
    var t_i      = 0;
    
    while (t_i < t_count)
    {
        t_node = ds_list_find_value(t_list, t_i);

        if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
            ds_list_delete(t_list, t_i);
            t_count--;
            continue;
        }
        
        t_parent = ds_list_find_value(t_node, xf_prop_parent);
        
        if (ds_exists(t_parent, ds_type_list)) {
            if (ds_list_find_index(t_list, t_parent) == -1) {
                ds_list_replace(t_list, t_i, t_parent);
                t_i++;
            }
            else {
                ds_list_delete(t_list, t_i);
                t_count--;
                continue;
            }
        }
        else {
            ds_list_delete(t_list, t_i);
            t_count--;
            continue;
        }
    }
    
    return true;
}