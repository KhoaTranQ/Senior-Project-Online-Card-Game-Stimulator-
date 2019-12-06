/// xf_query_descendant(list,self)
// Selects all descendants of the nodes held in the given ds_list.
// See: www.xmlfir.com/xf-query-descendant


if (argument_count <= 2) {
    // Get an instance of the xml controller
    var t__xml = instance_find(xf_asset_object_controller, 0);
    
    if (t__xml == noone) {
        t__xml = instance_create(0, 0, xf_asset_object_controller);
    }
    
    
    with (t__xml)
    {
        // Validate argument count
        if (argument_count == 0) {
            return xf_log(xf_query_descendant, 1, "Missing argument count: " + string(2 - argument_count) + ".");
        }
        
        // Validate list
        var t_list = argument[0];
        
        if (!ds_exists(t_list, ds_type_list)) {
            return xf_log(xf_query_descendant, 1, "argument0 is not a valid ds_list.");
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
        
        var t_descendants = -1;
        
        var t_count    = ds_list_size(t_list);
        var t_count2   = 0;
        var t_children = -1;
        var t_child    = -1;
        
        var t_node = 0;
        var t_num  = 0;
        var t_i    = 0;
        var t_j    = 0;

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
                
                t_children = ds_list_find_value(t_node, xf_prop_children);
                
                if (!ds_exists(t_children, ds_type_list)) {
                    t_i++;
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
                    
                    t_descendants = ds_list_find_value(t_child, xf_prop_children);
                    
                    if (!ds_exists(t_descendants, ds_type_list)) {
                        if (ds_list_find_index(t_list, t_child) == -1) {
                            t_i++;
                            t_count++;
                            ds_list_insert(t_list, t_i, t_child);
                        }
                        
                        t_j++;
                        continue;
                    }
                    
                    t_num = xf_query_descendant(t_list, true, t_child, (t_i + 1));
                    
                    t_count += t_num;
                    t_i     += t_num;

                    t_j++;
                }
        
                t_i++;
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
                    
                    t_descendants = ds_list_find_value(t_child, xf_prop_children);
                    
                    if (!ds_exists(t_descendants, ds_type_list)) {
                        if (ds_list_find_index(t_list, t_child) == -1) {
                            ds_list_insert(t_list, t_i, t_child);
                            t_i++;
                            t_count++;
                        }
                        
                        t_j++;
                        continue;
                    }
                    
                    t_num = xf_query_descendant(t_list, true, t_child, t_i);
                    
                    t_count += t_num;
                    t_i     += t_num;

                    t_j++;
                }
            }
        }

        return true;
    }
}


// Get arguments from recursive call
var t_list = argument[0];
var t_self = argument[1];
var t_node = argument[2];
var t_pos  = argument[3];
var t_num  = 0;


// Add the node
if (ds_list_find_index(t_list, t_node) == -1) {
    ds_list_insert(t_list, t_pos, t_node);
    t_pos++;
    t_num++;
}

// Get node children
var t_children = ds_list_find_value(t_node, xf_prop_children);

if (!ds_exists(t_children, ds_type_list)) {
    return t_num;
}

var t_descendants = -1;

var t_count = ds_list_size(t_children);
var t_child = -1;
var t_i     = 0;
var t_j     = 0;


while (t_i < t_count)
{
    t_child = ds_list_find_value(t_children, t_i);
    
    // Try simple node validation
    if (!is_real(t_child) || !ds_exists(t_child, ds_type_list) || ds_list_size(t_child) != xf_prop_size) {
        t_i++;
        continue;
    }
    
    t_descendants = ds_list_find_value(t_child, xf_prop_children);
    
    if (!ds_exists(t_descendants, ds_type_list)) {
        if (ds_list_find_index(t_list, t_child) == -1) {
            ds_list_insert(t_list, t_pos, t_child);
            t_num++;
            t_pos++;
        }
        
        t_i++;
        continue;
    }
    
    t_j = xf_query_descendant(t_list, false, t_child, t_pos);
    
    t_num += t_j;
    t_pos += t_j;
    
    t_i++;
}

return t_num;