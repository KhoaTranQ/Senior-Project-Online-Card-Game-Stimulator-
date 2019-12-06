///sync_draw_deck(deck)
/*
**  Description
**      Synchronises the list of the specified deck.
**
**  Arguments
**      deck    obj_deck    The deck who's list to synchronize.
**
**  Returns
**      <nothing>
**
*/

if( global.multiplayer)
{    
    var deck = argument0;
    
    var string_list = net_listmap_write(deck.list);
    
    with( global.net_object )
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.deckDraw);
        buffer_write(buffer, buffer_string, deck.net_id);
        debug("Drawing from deck with ID: " + deck.net_id);
        
        var err = network_send_packet(socket, buffer, buffer_tell(buffer));
        
        if(err)
        {
            debug("Error sending deckState packet");
        }
        else
        {
            //debug("deckState packet sent successfully.");
        }
        
        
    }
}
