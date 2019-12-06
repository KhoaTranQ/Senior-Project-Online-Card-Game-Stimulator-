/// xf_query_attr_name(list,op,name,...)
// Selects nodes in the given ds_list having or not having (op) at least one of the given attribute names.
// See: www.xmlfir.com/xf-query-attr-name


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count < 3) {
        return xf_log(xf_query_attr_name, 1, "Missing argument count: " +  string(3 - argument_count) + ".");
    }
    
    // Validate list
    var t_list = argument[0];
    
    if (!ds_exists(t_list, ds_type_list)) {
        return xf_log(xf_query_attr_name, 1, "argument0 is not a valid ds_list.");
    }
    
    // Get operator
    var t_op = string(argument[1]);
    
    if (t_op != "=" && t_op != "!=") {
        return xf_log(xf_query_attr_name, 1, 'argument1 Must be "=" or "!=".');
    }
    
    // Reset error
    p_error = "";
    
    // Special case: Check if we want to find element having any or no attributes
    if (argument_count == 3 && is_real(argument[2]) && argument[2] == noone) {
        var t_count = ds_list_size(t_list);
        var t_node  = noone;
        var t_i     = 0;
        
        if (t_op == "!=") {
            // Remove nodes that have no attributes
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                if (!ds_exists(ds_list_find_value(t_node, xf_prop_attrk), ds_type_list)) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_i++;
            }
        }
        else {
            // Remove nodes that have attributes
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                if (ds_exists(ds_list_find_value(t_node, xf_prop_attrk), ds_type_list)) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_i++;
            }
        }
        
        return t_list;
    }
    
    
    // Find by attribute name
    var t_filter = ds_list_create();
    var t_i      = 2;
    
    while (t_i < argument_count)
    {
        ds_list_add(t_filter, string(argument[t_i]));
        t_i++;
    }
    
    var t_count  = ds_list_size(t_list);
    var t_count2 = ds_list_size(t_filter);
    
    var t_node  = noone;
    var t_type  = noone;
    var t_keys  = noone;
    var t_found = false;
    var t_j     = 0;
    
    t_i = 0;
    
    if (t_op == "!=") {
        // Remove node with matching attribute name
        while (t_i < t_count)
        {
            t_node = ds_list_find_value(t_list, t_i);
            
            // Try simple node validation
            if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                ds_list_delete(t_list, t_i);
                t_count--;
                continue;
            }

            t_keys = ds_list_find_value(t_node, xf_prop_attrk);
            
            if (!ds_exists(t_keys, ds_type_list)) {
                t_i++;
                continue;
            }
            
            t_found = false;
            t_j = 0;
            
            while (t_j < t_count2)
            {
                if (ds_list_find_index(t_keys, ds_list_find_value(t_filter, t_j)) > -1) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    t_found = true;
                    break;
                }
                
                t_j++;
            }
            
            if (t_found) continue;

            t_i++;
        }
    }
    else {
        // Keep nodes with matching attribute name
        while (t_i < t_count)
        {
            t_node = ds_list_find_value(t_list, t_i);
            
            // Try simple node validation
            if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                ds_list_delete(t_list, t_i);
                t_count--;
                continue;
            }
            

            t_keys = ds_list_find_value(t_node, xf_prop_attrk);
            
            if (!ds_exists(t_keys, ds_type_list)) {
                ds_list_delete(t_list, t_i);
                t_count--;
                continue;
            }
            
            t_found = false;
            t_j     = 0;
            
            while (t_j < t_count2)
            {
                if (ds_list_find_index(t_keys, ds_list_find_value(t_filter, t_j)) > -1) {
                    t_found = true;
                    break;
                }
                
                t_j++;
            }
            
            if (!t_found) {
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
