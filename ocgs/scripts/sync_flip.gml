///sync_flip(instance)
/*
**  Description
**      Synchronizes the flipping of a specified card or deck.
**
**  Arguments
**      instance    mixed    The card or deck being flipped.
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var instance = argument0;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.flip);
        buffer_write(buffer, buffer_string, instance.net_id);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending flip update.");
        }
    }
}
