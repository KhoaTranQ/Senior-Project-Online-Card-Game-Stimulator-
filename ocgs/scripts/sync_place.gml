///sync_place(card)
/*
**  Description
**      Triggers special code that should only run when a card is placed.
**      For example, reactivating a card that had been in the hand.
**
**  Arguments
**      card    obj_card    The card being placed
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var card = argument0;
    var cardmap = scr_map_from_card(card);
    
    with(global.net_object)
    {
        if(card.last_zone == zone.hand || card.last_zone == zone.view)
        {
            buffer_seek(buffer, buffer_seek_start, 0);
            
            buffer_write(buffer, buffer_u8, sig.place);
            
            buffer_write(buffer, buffer_string, card.net_id);
            buffer_write(buffer, buffer_u8, card.last_zone);
            buffer_write(buffer, buffer_f32, card.x);
            buffer_write(buffer, buffer_f32, card.y);
            buffer_write(buffer, buffer_string, ds_map_write(cardmap) );
            
            ds_map_destroy(cardmap);
            
            if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
            {
                debug("ERROR sending place command");
            }
        }
    }
}
