///sync_deck_draw(deck, card)
/*
**  Description
**      Tells partner we drew from a deck.
**
**  Arguments
**      deck    obj_deck    The deck we're drawing from.
**      card    obj_card    The local ID of the card we drew.
**                          Only needed for local syncMap.
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var deck = argument0;
    var card = argument1;    
    
    with(global.net_object)
    {
        ds_map_add(syncMap, card.net_id, card.id);
        
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.deckDraw);
        buffer_write(buffer, buffer_string, deck.net_id);
        
        if( network_send_packet(socket, buffer, buffer_tell(buffer)) )
        {
            //debug("success");
        }
        else
        {
            debug("ERROR sending deckDraw packet.");
        }
    }
}

