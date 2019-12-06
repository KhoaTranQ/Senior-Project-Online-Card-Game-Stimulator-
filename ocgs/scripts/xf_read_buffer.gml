/// xf_read_buffer(buffer)
// Reads the given buffer and returns the root node.
// See: www.xmlfir.com/xf-read-buffer


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
        if (argument_count < 1) {
            // Log error: Insufficient arguments
            return xf_log(-1, xf_read_buffer, 1, "Missing argument count: 1.");
        }
        
        var t_buffer = argument[0];
        
        if (!is_real(t_buffer)) {
            return xf_log(-1, xf_read_buffer, 1, "argument0 is not a buffer.");
        }
        
        buffer_seek(t_buffer, buffer_seek_start, 0);
        
        // Check buffer size
        if (buffer_get_size(t_buffer) == 0) {
            return xf_log(-1, xf_read_buffer, 1, "argument0 is empty.");
            return -1;
        }
        
        // Read header
        var t_sig = buffer_read(t_buffer, buffer_string);
        
        if (t_sig != "XMLFIR") {
            return xf_log(-1, xf_read_buffer, 1, "Unknown buffer signature.");
        }
        
        // Read version
        var t_ver = buffer_read(t_buffer, buffer_u16);
        
        // Read element count
        var t_count = buffer_read(t_buffer, buffer_u32);
        
        // Reset error
        p_error = "";
        
        // Read the rest of the data
        var t_result = xf_read_buffer(t_buffer, t_ver, noone);
        
        // Check for error
        if (string_length(p_error)) {
            if (ds_exists(t_result, ds_type_list)) {
                ds_list_destroy(t_result);
            }
            
            t_result = -1;
        }
        
        // Callback
        if (ds_exists(t_result, ds_type_list)) {
            if (p_call_ev_create != noone) {
                script_execute(p_call_ev_create, xf_ev_create, t_result);
            }
        }
        
        return t_result;
    }
}


/**
* Internal call
* =============
*/
var t_buffer  = argument[0];
var t_version = argument[1];
var t_parent  = argument[2];

var t_string = "";
var t_real   = 0;

// Validate type
t_real = buffer_read(t_buffer, buffer_u8);

if (t_real < 1 || t_real > 6) {
    return xf_log(-1, xf_read_buffer, 1, "argument0 is corrupted.");
}

t_string = buffer_read(t_buffer, buffer_string);

// Create node
var t_node = ds_list_create();
ds_list_add(
    t_node, 
    t_real, 
    t_string, 
    t_parent, 
    -1, 
    -1, 
    -1,
    noone
);

// Read attribute count
var t_attr_count = buffer_read(t_buffer, buffer_u32);

// Read attributes
if (t_attr_count) {
    var t_attr_k_list = ds_list_create();
    var t_attr_v_list = ds_list_create();
    
    while (t_attr_count)
    {
        t_string = buffer_read(t_buffer, buffer_string);
        ds_list_add(t_attr_k_list, t_string);
        
        t_real = buffer_read(t_buffer, buffer_u8);
        
        if (t_real) {
            t_string = buffer_read(t_buffer, buffer_string);
            ds_list_add(t_attr_v_list, t_string);
        }
        else {
            t_real = buffer_read(t_buffer, buffer_f64);
            ds_list_add(t_attr_v_list, t_real);
        }
        
        t_attr_count--;
    }
    
    ds_list_replace(t_node, xf_prop_attrk, t_attr_k_list);
    ds_list_replace(t_node, xf_prop_attrv, t_attr_v_list);
    
    ds_list_mark_as_list(t_node, xf_prop_attrk);
    ds_list_mark_as_list(t_node, xf_prop_attrv);
}

// Read children
var t_children_count = buffer_read(t_buffer, buffer_u32);

if (t_children_count) {
    var t_children = ds_list_create();
    
    // Update node
    ds_list_replace(t_node, xf_prop_children, t_children);
    ds_list_mark_as_list(t_node, xf_prop_children);
    
    // Add children
    var t_child = noone;
    var t_num   = 0;
    
    while (t_children_count)
    {
        t_child = xf_read_buffer(t_buffer, t_version, t_node);
            
        if (t_child > -1) {
            ds_list_add(t_children, t_child);
            ds_list_mark_as_list(t_children, t_num);
            t_num++;
        }
        
        t_children_count--;
    }
}

return t_node;
