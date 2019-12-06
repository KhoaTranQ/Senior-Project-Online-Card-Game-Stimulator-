///sync(instance)
/*
** Description
**      Stars the synchronization of the specified instance.
**
**  Arguments
**      instance    mixed   The instance to synchronize
**
**  Returns
**      <nothing>
**
*/


if global.multiplayer
{
    var object = argument0;
    
    var type = noone;
    if( object != noone)
        type = object.object_index;
    
    with(global.net_object)
    {
        switch( type ) {
            case obj_card:
                net_sync_card(object);
                break;
            case obj_deck:
                net_sync_deck(object);
                break;
            default:
                show_debug_message("sync() doesn't know what to do this this instance.");
                break;
        }
    }    
}


