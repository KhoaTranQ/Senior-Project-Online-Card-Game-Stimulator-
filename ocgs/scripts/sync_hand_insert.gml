///sync_hand_insert(card)
/*
**  Description
**      Tells partner we are inserting a specified card into our hand.
**
**  Arguments
**      card    obj_card    The card we are inserting
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var card = argument0
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.handInsert)
        
        buffer_write(buffer, buffer_string, card.net_id);
        buffer_write(buffer, buffer_u8, card.last_zone);
        
        //buffer_write(buffer, buffer_f32, ds_list_size(global.handCards) );
        
        var err = network_send_packet(socket, buffer, buffer_tell(buffer) )
        if( err < 0 )
        {
            debug("ERROR sending hand insert command");
        }
    }
}


