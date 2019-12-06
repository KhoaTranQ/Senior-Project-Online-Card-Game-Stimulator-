///sync_rng(min, max, result)
/*
**  Description
**      Informs the other players about a roll this player just made.
**
**  Arguments
**      min     real    The minimum possible value they could have rolled.
**      max     real    The maximum possible value they could have rolled.
**      result  real    The value they actually rolled.
**
**  Returns
**      <nothing>
**
*/

if(global.multiplayer)
{
    var min_ = argument0;
    var max_ = argument1;
    var result = argument2;
    
    with(global.net_object)
    {
        buffer_seek(buffer, buffer_seek_start, 0);
        
        buffer_write(buffer, buffer_u8, sig.rng);
        
        buffer_write(buffer, buffer_f32, min_);
        buffer_write(buffer, buffer_f32, max_);
        buffer_write(buffer, buffer_f32, result);
        
        if( !network_send_packet(socket, buffer, buffer_tell(buffer) ) )
        {
            debug("ERROR sending RNG result.");
        }
    }
}


