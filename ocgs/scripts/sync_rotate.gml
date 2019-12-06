///sync_card_rotate(card, amount)
/*
**  Description
**      Synchronizes the rotation of a specified card by a specified rotation amount.
**
**  Arguments
**      card    obj_card    The card being rotated
**      amount  real        The amount the card is being rotated
**
**  Returns
**      <nothing>
**      
*/

if(global.multiplayer)
{
    var inst = argument0;
    var amount = argument1;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.rotate);
        buffer_write(buffer, buffer_string, inst.net_id);
        buffer_write(buffer, buffer_f32, amount);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR: Could not send card rotation packet.");
        }
    }
}
