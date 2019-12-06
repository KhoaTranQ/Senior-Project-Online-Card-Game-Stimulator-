/// xf_ev_bind(event,script)
// Binds a script to an event.
// See: www.xmlfir.com/xf-ev-bind


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Get arguments
    var t_ev  = argument0;
    var t_scr = argument1;
    
    // Validate event
    if (!is_real(t_ev)) {
        return xf_log(xf_ev_bind, 1, "argument0 is not a valid event.");
    }
    else if (t_ev != all && (t_ev < 1 || t_ev > 9)) {
        return xf_log(xf_ev_bind, 1, "argument0 is not a valid event.");
    }
    
    // Validate script
    if (!is_real(t_scr)) {
        return xf_log(xf_ev_bind, 1, "argument1 is not a valid script.");
    }
    else if (t_scr != noone) {
        if (!script_exists(t_scr)) {
            return xf_log(xf_ev_bind, 1, "argument1 is not a valid script.");
        }
    }
    
    // Reset error
    p_error = "";
    
    if (t_ev == all) {
        p_call_ev_create   = t_scr;
        p_call_ev_destroy  = t_scr;
        p_call_ev_copy     = t_scr;
        p_call_ev_relocate = t_scr;
        p_call_ev_delete   = t_scr;
        p_call_ev_set      = t_scr;
        p_call_ev_value    = t_scr;
        p_call_ev_write    = t_scr;
        
        return true;
    }
    
    switch (t_ev)
    {
        case xf_ev_create:
            p_call_ev_create = t_scr;
            break;
            
        case xf_ev_destroy:
            p_call_ev_destroy = t_scr;
            break;
            
        case xf_ev_copy:
            p_call_ev_copy = t_scr;
            break;
            
        case xf_ev_relocate:
            p_call_ev_relocate = t_scr;
            break;
            
        case xf_ev_delete_att:
            p_call_ev_delete = t_scr;
            break;
            
        case xf_ev_set_att:
            p_call_ev_set = t_scr;
            break;
            
        case xf_ev_set_value:
            p_call_ev_value = t_scr;
            break;
            
        case xf_ev_write:
            p_call_ev_write = t_scr;
            break;
            
        default:
            return xf_log(xf_ev_bind, 1, "argument0 is not a valid event.");
            break;
    }
    
    return true;
}
