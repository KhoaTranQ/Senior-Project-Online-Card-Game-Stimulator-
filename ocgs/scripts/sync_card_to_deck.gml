///sync_card_to_deck(card_net_id, deck)
/*
**  Description
**      Converting a card to a deck involves both deleting an object (the card),
**      and creating a new one (the deck).
**      But for synchronization, we need both the card's network ID AND the deck's.
**      The card itself will be gone by the time the code gets here,
**      So you need to save the ID before it gets here.
**      And we can assign the new deck a new ID, and send that.
**  
**  Arguments
**      card_net_id     string      The network ID of the card, before it was destroyed.
**      deck            obj_deck    The newly created deck.
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var card_net_id = argument0;
    var deck = argument1;
    
    with(global.net_object)
    {
        deck.net_id = net_hash();
        
        ds_map_delete(syncMap, card_net_id);
        ds_map_add(syncMap, deck.net_id, deck);
        
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.cardToDeck);
        buffer_write(buffer, buffer_string, card_net_id);
        buffer_write(buffer, buffer_string, deck.net_id);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending 'card to deck' command.");
        }
        
    }
}
