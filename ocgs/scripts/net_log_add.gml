///net_log_add(message)

var message = argument0;

var datetime = date_current_datetime();

var hour_str = string(date_get_hour(datetime) mod 12);

var min_str = string(date_get_minute(datetime));
while(string_length(min_str) < 2)
{
    min_str = string_insert("0", min_str, 1);
}

var formatted = "(" + hour_str + ":" + min_str + ") " + message;

with(global.log_object)
{
    var size = ds_list_size(log);
    
    if(size > 10)
    {
        ds_list_delete(log, 0);
    }
    
    ds_list_add(log, formatted);
}
