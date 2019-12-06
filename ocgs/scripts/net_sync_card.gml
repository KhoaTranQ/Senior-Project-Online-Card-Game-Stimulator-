/// net_sync_card( card )
/*
**  Description
**      Start synchronization of the specifed card.
**
**  Arguments
**      card    obj_card    The card to start synchronizing.
**
**  Returns
**      <nothing>
**
*/

var card = argument0;

var net_id = net_hash();
card.net_id = net_id

// Instead of sending all of the card's complex properties one at a time,
// create a map from them and send that.
var map = scr_map_from_card(card);

show_debug_message("The network ID is: " + net_id);

//  Convert the map into a string for easier sending.
var mapString = ds_map_write(map);

//  We don't need the map any more.
ds_map_destroy(map);

with(global.net_object) {
    ds_map_add(syncMap, card.net_id, card);
    buffer_seek(buffer, buffer_seek_start, 0);
    
    //Compile the information about the card
    buffer_write(buffer, buffer_u8, sig.addCard);
    buffer_write(buffer, buffer_string, net_id);
    buffer_write(buffer, buffer_f32, card.x);
    buffer_write(buffer, buffer_f32, card.y);
    buffer_write(buffer, buffer_string, mapString);
    
    var err = network_send_packet(socket, buffer, buffer_tell(buffer) );
    
    if( err < 0 ) {
        debug("ERROR sending addCard command");
    }
}

