///sync_hand_remove(card)
/*
**  Special Notes
**      I don't think this is used anymore.
**      Now *_place runs code related to removing cards from the hand.
**
**  Description
**      Tell partner we've removed a card from our hand
**
**  Arguments
**      card    obj_card    The card we removed
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var card = argument0;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.handRemove);
        
        buffer_write(buffer, buffer_string, card.net_id);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending hand removal command.");
        }
    }
}


