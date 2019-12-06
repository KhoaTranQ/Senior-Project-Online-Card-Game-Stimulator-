///sync_finish_import()
/*
**  Description
**      Tells partner we finished loading sprite data, and that it's safe for them to
**      delete their deck
**
**  Arguments
**      <none>
**
**  Returns
**      <nothing>
**
*/

with( global.net_object )
{
    buffer_seek(buffer, buffer_seek_start, 0);
    
    buffer_write(buffer, buffer_u8, sig.finishImport);
    
    //Make sure we send the packet. Try for a full second (1000ms)
    var err;
    var time = current_time;
    while( true )
    {
        err = network_send_packet(socket, buffer, buffer_tell(buffer) )
        
        if( err >= 0 )
        {
            break;
        }
        else if( current_time - time > 1000)
        {
            debug("ERROR: Could not send finish import command!");
            break;
        }
        
    }
}
