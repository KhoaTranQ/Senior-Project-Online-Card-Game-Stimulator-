///sync_sprite(sprite_index, front_path, back_path)
/*
**  Description
**      Syncronizes a sprite with a connected partner.
**
**  Arguments
**      sprite_index    sprite    The index of the local sprite
**      front_path      string      The path to the front image
**      back_path       string      The path to the back image
**
**  Returns
**      The network ID of the synchronized sprite
**
*/

if global.multiplayer
{
    var sprite_index_ = argument0;
    var front_name = argument1;
    var back_name = argument2;
    
    with( global.net_object)
    {
    
        // Associated given sprite_index with a unique network ID
        var net_id = net_hash();
        ds_map_add(id.syncMap, net_id, sprite_index_);        
        
        buffer_resize(buffer, 1);
        buffer_seek(buffer, buffer_seek_start, 0);
        
        // Signal to partner that this is a new sprite.
        buffer_write(buffer, buffer_u8, sig.addSprite);
        
        // The ID we used to associate the sprite index.
        // Parnter will need it to do the same.
        buffer_write(buffer, buffer_string, net_id);        
        
        buffer_write(buffer, buffer_string, front_name);
        buffer_write(buffer, buffer_string, back_name);
        
        var err = network_send_packet(socket, buffer, buffer_tell(buffer));    
    
        // Error checking
        if( err <  0 ) {
            show_debug_message("Error: Could not send sprite data.");
        } else {
            show_debug_message("Sprite data sent successfully.");
        }
        
        return net_id;
    }
}

/* Legacy

var net = global.net_object;

var net_id = net_hash();

var local_ID = sprite_add(path, 0,0,0,0,0);

ds_map_add(net.syncMap, net_id, local_ID);

var sprite_buffer = buffer_load(path);
var buff = buffer_create(1, buffer_grow, 1);

buffer_seek(buff, buffer_seek_start, 0);
buffer_write(buff, buffer_u8, sig.addSprite);
buffer_write(buff, buffer_string, net_id);

buffer_copy(sprite_buffer, 0, buffer_get_size(sprite_buffer), buff, buffer_tell(buff));

var err = network_send_packet(net.socket, buff, buffer_get_size(buff));

if( err <  0 ) {
    show_debug_message("Error: Could not send sprite data.");
} else {
    show_debug_message("Sprite data successfully sent.");
}

buffer_delete(buff);
buffer_delete(sprite_buffer);

return net_id;

