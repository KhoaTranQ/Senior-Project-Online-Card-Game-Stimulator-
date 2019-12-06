///net_place(data)
/*
**  Description
**      Runs special code depending on where the card used to be.
**
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);
var last_zone = buffer_read(data, buffer_u8);

// Run special code if the card was in the hand.
if( last_zone == zone.hand )
{
    var xCoord = buffer_read(data, buffer_f32);
    var yCoord = buffer_read(data, buffer_f32);
    var map_str = buffer_read(data, buffer_string);
    
    hand_size--;
    var map = ds_map_create();
    ds_map_read(map, map_str);
    
    map[? "sprite"] = syncMap[? map[? "sprite_net_id"]];
    
    var card = scr_card_from_map(map);
    
    ds_map_destroy(map);
    
    card.x = room_width - xCoord;
    card.y = room_height - yCoord;
    card.image_angle += 180
    
    syncMap[? net_id] = card;
}
else if( last_zone == zone.view)
{ // Card was in their zone. We need to create it now.

    var xCoord = buffer_read(data, buffer_f32);
    var yCoord = buffer_read(data, buffer_f32);
    var map_str = buffer_read(data, buffer_string);
    
    var map = ds_map_create();
    ds_map_read(map, map_str);    
    map[? "sprite"] = syncMap[? map[? "sprite_net_id"]];
    var card = scr_card_from_map(map);
    ds_map_destroy(map);
    
    card.x = room_width - xCoord;
    card.y = room_height - yCoord;
    card.image_angle += 180;
    
    syncMap[? net_id] = card;
    
}





