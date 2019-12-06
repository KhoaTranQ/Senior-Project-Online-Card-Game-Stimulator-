///sync_view_request(deck)

var deck = argument0;

with(global.net_object)
{

    other.deck = deck;

    buffer_seek(buffer, buffer_seek_start, 0);
    
    buffer_write(buffer, buffer_u8, sig.viewRequest);
    
    buffer_write(buffer, buffer_string, deck.net_id);
    
    if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
    {
        debug("ERROR sending viewReuquest command");
    }
}
