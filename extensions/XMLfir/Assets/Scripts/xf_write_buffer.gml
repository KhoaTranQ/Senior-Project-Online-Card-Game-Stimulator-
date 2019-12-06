/// xf_write_buffer(node)
// Writes the given node including its descendants into a buffer.
// See: www.xmlfir.com/xf-write-buffer


/**
* User call
* =========
*/
if (argument_count <= 1) {
    // Get an instance of the xml controller
    var t__xml = instance_find(xf_asset_object_controller, 0);
    
    if (t__xml == noone) {
        t__xml = instance_create(0, 0, xf_asset_object_controller);
    }
    
    
    with (t__xml)
    {
        // Validate argument count
        if (argument_count < 1) {
            return xf_log(-1, xf_write_buffer, 1, "Missing argument count: 1.");
        }
        
        // Validate the node
        var t_node = argument[0];
        
        if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
            return xf_log(-1, xf_write_buffer, 1, "argument0 is not a valid xml node.");
        }
        
        // Callback
        if (p_call_ev_write != noone && p_ev_write_on) {
            script_execute(p_call_ev_write, xf_ev_write, t_node, 0);
        }
        
        // Create buffer
        var t_buffer = buffer_create(16, buffer_grow, 1);
        buffer_seek(t_buffer, buffer_seek_start, 0);
        
        // Write header - Signature
        buffer_write(t_buffer, buffer_string, "XMLFIR");
        
        // Write header - Version
        buffer_write(t_buffer, buffer_u16, xf_version);
        
        // Write header - Element count
        var t_pos_count = buffer_tell(t_buffer);
        buffer_write(t_buffer, buffer_u32, 0);
        
        // Reset error
        p_error = "";
        
        // Write nodes to buffer
        var t_count = xf_write_buffer(t_node, t_buffer);

        // Write header - Updated element count
        buffer_poke(t_buffer, t_pos_count, buffer_u32, t_count);
        
        // Check for error
        if (t_count == 0) {
            buffer_delete(t_buffer);
            t_buffer = -1;
        }
        else if (string_length(p_error)) {
            buffer_delete(t_buffer);
            t_buffer = -1;
        }
        
        return t_buffer;
    }
}


/**
* Internal call
* =============
*/
var t_node   = argument[0];
var t_buffer = argument[1];

if (!is_real(t_node) || !ds_exists(t_node, ds_type_list) || ds_list_size(t_node) != xf_prop_size) {
    return xf_log(0, xf_write_buffer, 1, "argument0 contains an invalid data structure.");
}

// Get node type
var t_type = ds_list_find_value(t_node, xf_prop_type);

// Validate type
if (t_type < 1 || t_type > 6) {
    return xf_log(0, xf_write_buffer, 1, "argument0 contains an invalid data structure.");
}

// Set node counter to 1
var t_count = 1;


// Write type
buffer_write(t_buffer, buffer_u8, t_type);

// Write value
var t_value = string(ds_list_find_value(t_node, xf_prop_value));
buffer_write(t_buffer, buffer_string, t_value);

// Write attributes
var t_attr_keys = ds_list_find_value(t_node, xf_prop_attrk);

if (ds_exists(t_attr_keys, ds_type_list)) {
    t_attr_count = ds_list_size(t_attr_keys);

    // Write attribute count
    buffer_write(t_buffer, buffer_u32, t_attr_count);
    
    var t_attr_vals = ds_list_find_value(t_node, xf_prop_attrv);
    var t_attr_i    = 0;
    var t_attr_k    = "";
    var t_attr_v    = "";
    
    while (t_attr_i < t_attr_count)
    {
        t_attr_k = string(ds_list_find_value(t_attr_keys, t_attr_i));
        t_attr_v = ds_list_find_value(t_attr_vals, t_attr_i);
        
        // Write attribute key
        buffer_write(t_buffer, buffer_string, t_attr_k);
        
        // Write attribute value
        if (is_real(t_attr_v)) {
            // Write attribute value data type (real)
            buffer_write(t_buffer, buffer_u8, 0);
            
            // Write attribute value data
            buffer_write(t_buffer, buffer_f64, t_attr_v);
        }
        else {
            // Write attribute value data type (string)
            buffer_write(t_buffer, buffer_u8, 1);
            
            // Write attribute value data
            buffer_write(t_buffer, buffer_string, t_attr_v);
        }
        
        t_attr_i++;
    }
}
else {
    // Write attribute count
    buffer_write(t_buffer, buffer_u32, 0);
}

 
// Write children
var t_children = ds_list_find_value(t_node, xf_prop_children);

if (ds_exists(t_children, ds_type_list)) {
    var t_child_count = ds_list_size(t_children);
    var t_child    = noone;
    var t_child_i  = 0;
    
    var t_attr_vals = -1;
    var t_attr_i    = 0;
    var t_attr_k    = "";
    var t_attr_v    = "";
         
    var t_child_children = -1;
    var t_child_children_count = 0;
    var t_child_child    = noone;
    var t_child_child_i  = 0;
    var t_child_child_num = 0;
    var t_pos_child_children = 0;
    
    var t_pos_children = buffer_tell(t_buffer);
    var t_child_num    = 0;
    
    // Write child count
    buffer_write(t_buffer, buffer_u32, t_child_count);
    
    // Write each child
    while (t_child_i < t_child_count)
    {
        t_child = ds_list_find_value(t_children, t_child_i);
        
        // Validate child
        if (!is_real(t_child) || !ds_exists(t_child, ds_type_list) || ds_list_size(t_child) != xf_prop_size) {
            return xf_log(0, xf_write_buffer, 1, "argument0 contains an invalid data structure.");
        }

        // Get node type
        t_type = ds_list_find_value(t_child, xf_prop_type);
        
        // Validate type
        if (t_type < 1 || t_type > 6) {
            return xf_log(0, xf_write_buffer, 1, "argument0 contains an invalid data structure.");
        }
        
        // Increase child counter by 1
        t_child_num++;
        
        if (t_type == xf_type_element || t_type == xf_type_fragment) {
            // Handle these types recursively
            t_count += xf_write_buffer(t_child, t_buffer);
        }
        else {
            t_count++;
            
            // Write type
            buffer_write(t_buffer, buffer_u8, t_type);
            
            // Write value
            t_value = string(ds_list_find_value(t_child, xf_prop_value));
            buffer_write(t_buffer, buffer_string, t_value);
            
            // Write attributes
            t_attr_keys = ds_list_find_value(t_child, xf_prop_attrk);
            
            if (ds_exists(t_attr_keys, ds_type_list)) {
                t_attr_count = ds_list_size(t_attr_keys);
                
                // Write attribute count
                buffer_write(t_buffer, buffer_u32, t_attr_count);
                
                t_attr_vals = ds_list_find_value(t_child, xf_prop_attrv);
                t_attr_i    = 0;
                t_attr_k    = "";
                t_attr_v    = "";
                
                while (t_attr_i < t_attr_count)
                {
                    t_attr_k = string(ds_list_find_value(t_attr_keys, t_attr_i));
                    t_attr_v = ds_list_find_value(t_attr_vals, t_attr_i);
                    
                    // Write attribute key
                    buffer_write(t_buffer, buffer_string, t_attr_k);
                    
                    // Write attribute value
                    if (is_real(t_attr_v)) {
                        // Write attribute value data type (real)
                        buffer_write(t_buffer, buffer_u8, 0);
                        
                        // Write attribute value data
                        buffer_write(t_buffer, buffer_f64, t_attr_v);
                    }
                    else {
                        // Write attribute value data type (string)
                        buffer_write(t_buffer, buffer_u8, 1);
                        
                        // Write attribute value data
                        buffer_write(t_buffer, buffer_string, t_attr_v);
                    }
                    
                    t_attr_i++;
                }
            }
            else {
                // Write attribute count
                buffer_write(t_buffer, buffer_u32, 0);
            }
            
            // No children
            buffer_write(t_buffer, buffer_u32, 0);
        }
        
        t_child_i++;
    }

    // Update child count
    buffer_poke(t_buffer, t_pos_children, buffer_u32, t_child_num);
}
else {
    // Write child count
    buffer_write(t_buffer, buffer_u32, 0);
}

return t_count;
