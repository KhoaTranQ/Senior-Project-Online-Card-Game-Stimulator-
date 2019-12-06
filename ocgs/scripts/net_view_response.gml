///new_view_response(data)
/*
**  Unline most net_* functions, this one is NOT controlled by con_net
**  It's controlled by async_view_request
*/


var data = argument0;

var is_yes = buffer_read(data, buffer_bool);

if(is_yes)
{
    //new(obj_view, async_object, ds_list_size(async_object));
    new(obj_view, deck, size);
}
else
{
    show_message_async("The other player denied your request.");
}


