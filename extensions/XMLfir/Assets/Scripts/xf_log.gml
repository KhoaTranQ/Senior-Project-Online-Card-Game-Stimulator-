/// xf_log(ret,scr,sev,msg)
// Logs a message.
// See: www.xmlfir.com/xf-log


// Get an instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);

if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}


with (t__xml)
{
    // Get arguments
    if (argument_count == 4) {
        var t_ret = argument[0];
        var t_scr = argument[1];
        var t_sev = argument[2];
        var t_msg = argument[3];
    }
    else {
        var t_ret = false;
        var t_scr = argument[0];
        var t_sev = argument[1];
        var t_msg = argument[2];
    }
    
    // Log disabled?
    if (!cfg_log || t_sev > cfg_log_level) {
        if (t_sev == 1) {
            p_error = "Error in script " + script_get_name(t_scr) + "(): " + t_msg;
        }
        
        return t_ret;
    }

    switch (t_sev)
    {
        // Error
        case 1:
            t_msg   = "Error in script " + script_get_name(t_scr) + "(): " + t_msg;
            p_error = t_msg;
            
            if (cfg_log_con_error) show_debug_message(t_msg);
            if (cfg_log_pop_error) show_message(t_msg);
            break;
        
        // Notice
        case 2:
            t_msg = "Notice in script " + script_get_name(t_scr) + "(): " + t_msg;
            
            if (cfg_log_con_notice) show_debug_message(t_msg);
            if (cfg_log_pop_notice) show_message(t_msg);
            break;
           
        // Debug Info 
        case 3:
            t_msg = "Info in script " + script_get_name(t_scr) + "(): " + t_msg;
            
            if (cfg_log_con_debug) show_debug_message(t_msg);
            if (cfg_log_pop_debug) show_message(t_msg);
            break;
    }

    return t_ret;
}
