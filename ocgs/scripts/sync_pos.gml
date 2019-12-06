///sync_pos(card|deck)
/*
**  Description
**      Tells parter to synchronize the position of a card or deck.
**
**  Arguments
**      card|deck   obj_card or obj_deck    The card or deck who's position is being updated.
**
**  Returns
**      <nothing>
*/

if global.multiplayer{
    var inst = argument0;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        // Signal partner we are updating a card's position.
        buffer_write(buffer, buffer_u8, sig.pos);
        
        // Tell partner the network ID so it knows which of its cards to update.
        buffer_write(buffer, buffer_string, inst.net_id);
        
        // Finally, send the deck's position.
        buffer_write(buffer, buffer_f32, inst.x);
        buffer_write(buffer, buffer_f32, inst.y);
        
        if( network_send_packet(socket, buffer, buffer_tell(buffer)) )
        {
            //debug("Deck position update sent.");
        }
        else
        {
            debug("ERROR: Could not send card position update.");
        }
    }    
}
