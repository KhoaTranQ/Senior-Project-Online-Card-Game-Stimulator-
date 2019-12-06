///sync_deck_pos(deck)
/*
**  Description
**      Synchronize deck's new position
**
**  Arguments
**      Deck    obj_deck    The deck to synchronize
**
**  Returns
**      <nothing>
**
*/

if global.multiplayer{
    var deck = argument0;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        // Signal partner we are updating a card's position.
        buffer_write(buffer, buffer_u8, sig.deckPos);
        
        // Tell partner the network ID so it knows which of its cards to update.
        buffer_write(buffer, buffer_string, deck.net_id);
        
        // Finally, send the deck's position.
        buffer_write(buffer, buffer_f32, deck.x);
        buffer_write(buffer, buffer_f32, deck.y);
        
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
