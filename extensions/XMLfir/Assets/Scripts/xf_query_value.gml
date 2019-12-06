/// xf_query_value(list,op,value,...)
// Selects nodes in the given ds_list whose value cmp equals true with at least one of the given value args.
// See: www.xmlfir.com/xf-query-value


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Validate argument count
    if (argument_count < 3) {
        return xf_log(xf_query_value, 1, "Missing argument count: " +  string(3 - argument_count) + ".");
    }
    
    // Validate list
    var t_list = argument[0];
    
    if (!ds_exists(t_list, ds_type_list)) {
        return xf_log(xf_query_value, 1, "argument0 is not a valid ds_list.");
    }
    
    // Get operator
    var t_op = string(argument[1]);
    
    // Get the value arguments
    var t_filter = ds_list_create();
    var t_i      = 2;
    
    switch (t_op)
    {
        case "=":
        case "!=":
        case "contains":
        case "contains-not":
        case "starts-with":
        case "starts-not-with":
        case "ends-with":
        case "ends-not-with":
            while (t_i < argument_count)
            {
                ds_list_add(t_filter, string(argument[t_i]));
                t_i++;
            }
            break;
            
        case ">":
        case "<":
        case ">=":
        case "<=":
            while (t_i < argument_count)
            {
                if (!is_real(argument[t_i])) {
                    // Convert string to real
                    if (string(real(argument[t_i])) != argument[t_i]) {
                        return xf_log(xf_query_value, 1, "argument" + string(t_i) + " is not number.");
                    }
                    
                    ds_list_add(t_filter, real(argument[t_i]));
                }
                else {
                    ds_list_add(t_filter, argument[t_i]);
                }
                
                t_i++;
            }
            break;
            
        default:
            return xf_log(xf_query_value, 1, "argument1 is not a valid operator.");
            break;
    }
    
    // Reset error
    p_error = "";
    
    var t_count2 = ds_list_size(t_filter);
    var t_count  = ds_list_size(t_list);
    var t_node   = noone;
    var t_type   = noone;
    var t_found  = false;
    var t_value  = "";
    var t_len    = 0;
    var t_j      = 0;
    
    t_i = 0;
    
    switch (t_op)
    {
        // Handle =
        case "=":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
    
                if (ds_list_find_index(t_filter, string(ds_list_find_value(t_node, xf_prop_value))) == -1) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
    
                t_i++;
            }
            break;
            
        // Handle !=
        case "!=":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                if (ds_list_find_index(t_filter, string(ds_list_find_value(t_node, xf_prop_value))) > -1) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
    
                t_i++;
            }
            break;
            
        case ">":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = ds_list_find_value(t_node, xf_prop_value);
                t_found = false;
                t_j     = 0;
                
                if (!is_real(t_value)) {
                    if (string(real(t_value)) != t_value) {
                        ds_list_delete(t_list, t_i);
                        t_count--;
                        continue;
                    }
                    
                    t_value = real(t_value);
                }
                
                while (t_j < t_count2)
                {
                    if (t_value > ds_list_find_value(t_filter, t_j)) {
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
            break;
            
        case "<":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = ds_list_find_value(t_node, xf_prop_value);
                t_found = false;
                t_j     = 0;
                
                if (!is_real(t_value)) {
                    if (string(real(t_value)) != t_value) {
                        ds_list_delete(t_list, t_i);
                        t_count--;
                        continue;
                    }
                    
                    t_value = real(t_value);
                }
                
                while (t_j < t_count2)
                {
                    if (t_value < ds_list_find_value(t_filter, t_j)) {
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
            break;
            
        case ">=":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = ds_list_find_value(t_node, xf_prop_value);
                t_found = false;
                t_j     = 0;
                
                if (!is_real(t_value)) {
                    if (string(real(t_value)) != t_value) {
                        ds_list_delete(t_list, t_i);
                        t_count--;
                        continue;
                    }
                    
                    t_value = real(t_value);
                }
                
                while (t_j < t_count2)
                {
                    if (t_value >= ds_list_find_value(t_filter, t_j)) {
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
            break;
            
        case "<=":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = ds_list_find_value(t_node, xf_prop_value);
                t_found = false;
                t_j     = 0;
                
                if (!is_real(t_value)) {
                    if (string(real(t_value)) != t_value) {
                        ds_list_delete(t_list, t_i);
                        t_count--;
                        continue;
                    }
                    
                    t_value = real(t_value);
                }
                
                while (t_j < t_count2)
                {
                    if (t_value <= ds_list_find_value(t_filter, t_j)) {
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
            break;
            
        case "contains":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = string(ds_list_find_value(t_node, xf_prop_value));
                t_found = false;
                t_j     = 0;
                
                while (t_j < t_count2)
                {
                    if (string_pos(ds_list_find_value(t_filter, t_j), t_value) != 0) {
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
            break;
            
        case "contains-not":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = string(ds_list_find_value(t_node, xf_prop_value));
                t_found = false;
                t_j     = 0;
                
                while (t_j < t_count2)
                {
                    if (string_pos(ds_list_find_value(t_filter, t_j), t_value) != 0) {
                        t_found = true;
                        break;
                    }
                    t_j++;
                }
                
                if (t_found) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
    
                t_i++;
            }
            break;
            
        case "starts-with":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = string(ds_list_find_value(t_node, xf_prop_value));
                t_found = false;
                t_j     = 0;
                
                while (t_j < t_count2)
                {
                    if (string_pos(ds_list_find_value(t_filter, t_j), t_value) == 1) {
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
            break;
            
        case "ends-with":
            var t_match = "";
            var t_pos   = 0;
            var t_len   = 0;
            var t_flen  = 0;
            
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = string(ds_list_find_value(t_node, xf_prop_value));
                t_found = false;
                t_j     = 0;
                
                while (t_j < t_count2)
                {
                    t_match = ds_list_find_value(t_filter, t_j);
                    t_pos   = string_pos(t_match, t_value);
                    
                    if (t_pos != 0) {
                        t_len  = string_length(t_value);
                        t_flen = string_length(t_match);
                        
                        if (string_copy(t_value, t_len - t_flen + 1, t_len) == t_match) {
                            t_found = true;
                            break;
                        }
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
            break;
            
        case "starts-not-with":
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = string(ds_list_find_value(t_node, xf_prop_value));
                t_found = false;
                t_j     = 0;
                
                while (t_j < t_count2)
                {
                    if (string_pos(ds_list_find_value(t_filter, t_j), t_value) == 1) {
                        t_found = true;
                        break;
                    }
                    t_j++;
                }
                
                if (t_found) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
    
                t_i++;
            }
            break;
            
        case "ends-not-with":
            var t_match = "";
            var t_pos   = 0;
            var t_len   = 0;
            var t_flen  = 0;
            
            while (t_i < t_count)
            {
                t_node = ds_list_find_value(t_list, t_i);
                
                // Try simple node validation
                if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
                
                t_value = string(ds_list_find_value(t_node, xf_prop_value));
                t_found = false;
                t_j     = 0;
                
                while (t_j < t_count2)
                {
                    t_match = ds_list_find_value(t_filter, t_j);
                    t_pos   = string_pos(t_match, t_value);
                    
                    if (t_pos != 0) {
                        t_len  = string_length(t_value);
                        t_flen = string_length(t_match);
                        
                        if (string_copy(t_value, t_len - t_flen + 1, t_len) == t_match) {
                            t_found = true;
                            break;
                        }
                    }
                    
                    t_j++;
                }
                
                if (t_found) {
                    ds_list_delete(t_list, t_i);
                    t_count--;
                    continue;
                }
    
                t_i++;
            }
            break;
    }

    ds_list_destroy(t_filter);
    
    return true;
}
