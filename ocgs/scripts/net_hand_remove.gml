///net_hand_remove(data)
/*
**  Special Notes
**      Now handled by net_place
**
**  Description
**      Register partner removing a card from their hand.
**
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);

var local_inst = syncMap[? net_id];

// Decrement our hand card counter
hand_size--;
