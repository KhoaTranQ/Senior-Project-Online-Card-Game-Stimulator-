///net_listmap_read( string_listmap, deck )

/*Incomplete! Do not use!*/
/*Incomplete! Do not use!*/
/*Incomplete! Do not use!*/
/*Incomplete! Do not use!*/
/*Incomplete! Do not use!*/
/*Incomplete! Do not use!*/
/*Incomplete! Do not use!*/

var string_listmap = argument0;
var deck = argument1;

var tmp_list = ds_list_create();
ds_list_read(tmp_list, string_listmap);
var size = ds_list_size(tmp_list);

var sprite_local_id;
for(var i = 0; i < size; i++)
{
    //debug("networking addDeck tmp_list population");
    var map = ds_map_create();
    ds_map_read(map, tmp_list[| i]);
    
    // Replace the old "sprite" field with the sprite_id associated with sprite_net_id
    var sprite_net_id = map[? "sprite_net_id"];
    var sprite_local_id = syncMap[? sprite_net_id];
    map[? "sprite"] = sprite_local_id;
    
    ds_list_add(deck.list, map);
}

ds_list_destroy(tmp_list);
