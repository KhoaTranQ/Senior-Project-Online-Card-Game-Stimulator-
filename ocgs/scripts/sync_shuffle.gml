///sync_shuffle(deck, array)
/*
**  Description
**      
**
**  Arguments
**      deck    obj_deck    The deck to synchronize.
**      array    array      The code to shuffle with.
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var deck = argument0;
    var csv = csv_from_array(argument1);
        
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_u8, sig.shuffle);
        buffer_write(buffer, buffer_string, deck.net_id);
        buffer_write(buffer, buffer_string, csv);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending shuffle signal.");
        }
    }
}
