///sync_send_to_back(card, command)
/*
**  Description
**      Modifies a card's depth based on a command
**
**  Arguments
**      card        obj_card    the card who's depth to change
**      command     real        the command to use
**                              0: Bring to front
**                              1: Send to back
**                              (Below not implemented)
**                              2: Bring up one
**                              3: Send back one
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var card = argument0;
    var command = argument1;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.depthCmd);
        buffer_write(buffer, buffer_string, card.net_id);
        buffer_write(buffer, buffer_u8, command);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending sendBack command!");
        }
    }
}

