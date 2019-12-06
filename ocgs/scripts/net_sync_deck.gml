///net_sync_deck(deck)
/*
**  Description
**      Start synchronization of the specifed deck.
**
**  Arguments
**      deck    obj_deck    The deck to start synchronizing.
**
**  Returns
**      <nothing>
**
*/

var deck = argument0;

var net_id = net_hash();
deck.net_id = net_id;

// Convert the deck's list of maps into a single massive string.

var string_list = net_listmap_write(deck.list);

with( global.net_object)
{
    ds_map_add(syncMap, net_id, deck);
    buffer_seek(buffer, buffer_seek_start, 0);
    
    //  Signal partner that we are adding a new, populated deck.
    buffer_write(buffer, buffer_u8, sig.addDeck);
    buffer_write(buffer, buffer_string, net_id);
    buffer_write(buffer, buffer_f32, deck.x);
    buffer_write(buffer, buffer_f32, deck.y);
    buffer_write(buffer, buffer_string, string_list);
    
    
    var err = network_send_packet(socket, buffer, buffer_tell(buffer) );
    
    if( err >= 0 ) {
        //debug("Deck sent successfully.");
    } else {
        debug("ERROR sending deck.");
    }
}
