///sync_delete(instance)
/*
**  Description
**      Synchronize the deletion of the specified card or deck.
**
**  Arguments
**      instance    mixed   The card or deck to delete.
**
**  Returns
**      <nothing>
**
*/

if( global.multiplayer)
{
    var instance = argument0;
    var in_hand = scr_zone_hand(instance);
    
    with( global.net_object )
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.delete);        
        buffer_write(buffer, buffer_string, instance.net_id);
        buffer_write(buffer, buffer_bool, in_hand);
        
        ds_map_delete(syncMap, instance.net_id);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending deletion signature");
        }
    }
}

