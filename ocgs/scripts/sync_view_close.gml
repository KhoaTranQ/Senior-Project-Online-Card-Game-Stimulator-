///sync_view_close(deck)

if(global.multiplayer)
{
    var deck = argument0;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.viewClose);
        
        buffer_write(buffer, buffer_string, deck.net_id);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) ) 
        {
            debug("ERROR sending viewClose command");
        }
    }
}
