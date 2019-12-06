///sync_card_pos(card);
/*
**  Description
**      update the specified chard's position
**
**  Arguments
**      card    obj_card    The card to synchronize
**
**  Returns
**      <nothing>
**
*/
if global.multiplayer {
    var card = argument0;
    with global.net_object {
    
        //var buffer = buffer_create(1, buffer_grow, 1);
        buffer_seek(buffer, buffer_seek_start, 0);
        
        //  Signal the partner we are updating a card's position.
        buffer_write(buffer, buffer_u8, sig.cardPos);
        
        //  Tell parter the network ID so it knows which of its cards to update.
        buffer_write(buffer, buffer_string, card.net_id);
        
        buffer_write(buffer, buffer_f32, card.x);
        buffer_write(buffer, buffer_f32, card.y);
        
        if( network_send_packet(socket, buffer, buffer_tell(buffer)) ) {
            //debug("Card position update sent.");
        } else
            debug("ERROR: Could not send card position update.");
        //buffer_delete(buffer);
    }
}
