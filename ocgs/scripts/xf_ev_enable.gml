/// xf_ev_enable(event,state)
// Sets the state of an event to enabled or disabled.
// See: www.xmlfir.com/xf-ev-enable


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Get arguments
    var t_ev    = argument0;
    var t_state = argument1;
    
    // Validate event
    if (!is_real(t_ev)) {
        return xf_log(xf_ev_enable, 1, "argument0 is not a valid event.");
    }
    else if (t_ev != all && (t_ev < 1 || t_ev > 9)) {
        return xf_log(xf_ev_enable, 1, "argument0 is not a valid event.");
    }
    
    // Validate state
    if (!is_real(t_state)) {
        return xf_log(xf_ev_enable, 1, "argument1 is not a valid state. Must be 1 or 0.");
    }
    else if (t_state > 1 || t_state < 0) {
        return xf_log(xf_ev_enable, 1, "argument1 is not a valid state. Must be 1 or 0.");
    }
    
    // Reset error
    p_error = "";
    
    if (t_ev == all) {
        p_ev_create_on   = t_state;
        p_ev_destroy_on  = t_state;
        p_ev_copy_on     = t_state;
        p_ev_relocate_on = t_state;
        p_ev_delete_on   = t_state;
        p_ev_set_on      = t_state;
        p_ev_value_on    = t_state;
        p_ev_write_on    = t_state;
        
        return true;
    }
    
    switch (t_ev)
    {
        case xf_ev_create:
            p_ev_create_on = t_state;
            break;
            
        case xf_ev_destroy:
            p_ev_destroy_on = t_state;
            break;
            
        case xf_ev_copy:
            p_ev_copy_on = t_state;
            break;
            
        case xf_ev_relocate:
            p_ev_relocate_on = t_state;
            break;
            
        case xf_ev_delete_att:
            p_ev_delete_on = t_state;
            break;
            
        case xf_ev_set_att:
            p_ev_set_on = t_state;
            break;
            
        case xf_ev_set_value:
            p_ev_value_on = t_state;
            break;
            
        case xf_ev_write:
            p_ev_write_on = t_state;
            break;
            
        default:
            return xf_log(xf_ev_enable, 1, "argument0 is not a valid event.");
            break;
    }
    
    return true;
}
