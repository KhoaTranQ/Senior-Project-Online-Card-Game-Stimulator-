///sync_deck_insert(deck, card, pos)
/*
**  Description
**      Synchronizes the insertion of a specified card into 
**      a specified deck at a specified position
**
**  Arguments
**      deck    obj_deck    the deck being inserted into
**      card    obj_card    the card being inserted
**      pos     real        the position in the dex to insert the card
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var deck = argument0;
    var card = argument1;
    var pos = argument2;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.deckInsert);
        buffer_write(buffer, buffer_string, deck.net_id);
        buffer_write(buffer, buffer_string, card.net_id);
        buffer_write(buffer, buffer_f32, pos);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending deck insert command.");
        }
    }
}
