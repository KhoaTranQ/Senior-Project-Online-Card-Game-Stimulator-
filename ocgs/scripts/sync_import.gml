///sync_import(path)
/*
**  Description
**      Sends the path to a .deck file for partner to use for deck creations.
**
**  Arguments
**      path    string      The path to the .deck file in the working_directory
**
**  Returns
**      <nothing>
**
*/


if(global.multiplayer)
{
    var path = argument0;
    var name = filename_name(path);
    
    with( global.net_object)
    {
        buffer_resize(buffer, 1);        
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.import);
        buffer_write(buffer, buffer_string, name);
        
        var tmp_buff = buffer_load(path);
        
        buffer_copy(tmp_buff, 0, buffer_get_size(tmp_buff), buffer, buffer_tell(buffer));
        
        buffer_delete(tmp_buff);
        
        var err = network_send_packet(socket, buffer, buffer_get_size(buffer) )
        
        if( err < 0 )
        {
            debug("ERORR sending .deck.");
        }
        
        buffer_resize(buffer, 1);
        
    }
    
}
