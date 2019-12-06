/// net_sync_new_card(net_ID, xPos, yPos, cardmap)

/*
**
*/

var net_ID = argument0;
var xPos = argument1;
var yPos = argument2;
var mapString = ds_map_write(argument3);

with(global.net_object) {
    buffer_seek(buffer, buffer_seek_start, 0);
    buffer_write(buffer, buffer_u8, sig.addCard);
    buffer_write(buffer, buffer_string, net_ID);
    buffer_write(buffer, buffer_f32, xPos);
    buffer_write(buffer, buffer_f32, yPos);
    buffer_write(buffer, buffer_string, mapString);
    
    var err = network_send_packet(socket, buffer, buffer_tell(buffer) );
    
    if( err >= 0 ) {
        show_debug_message("packet sent");
    } else {
        show_debug_message("packet error");
    }
}
