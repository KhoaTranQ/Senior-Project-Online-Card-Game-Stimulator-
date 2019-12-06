//sync_deck_drop(deck, card)
/*
**  Description
**      Syncnize dropping a specified card onto a specified deck.
**
**  Arguments
**      deck    obj_deck    The deck the card is being dropped on.
**      card    obj_card    The card being dropped on the deck.
**
**  Returns
**      <nothing>
*/

if(global.multiplayer)
{
    with( global.net_object)
    {
        var deck = argument0;
        var card = argument1;
        
        // Because deck_drop is destructive (it destroys the card)
        // Update our syncronization map to remove it.
        ds_map_delete(syncMap, card.net_id);
        
        buffer_seek(buffer, buffer_seek_start, 0)
        
        buffer_write(buffer, buffer_u8, sig.deckDrop);
        
        buffer_write(buffer, buffer_string, deck.net_id);
        buffer_write(buffer, buffer_string, card.net_id);
        
        if( network_send_packet(socket, buffer, buffer_tell(buffer)) )
        {
            //debug("Deck drop update sent successfully.");
        }
        else
        {
            debug("ERROR sending deck drop data.");
        }
    }
}


