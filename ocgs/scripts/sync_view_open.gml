///sync_view_open(deck, num)

if(global.multiplayer)
{
    var deck = argument0;
    var num = argument1;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.viewOpen);
        buffer_write(buffer, buffer_string, deck.net_id);
        buffer_write(buffer, buffer_f32, num);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending viewOpen command");
        }
    }
}
