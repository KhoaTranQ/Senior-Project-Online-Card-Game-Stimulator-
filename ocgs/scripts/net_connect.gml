/// net_connect(socket, url, port)
/*
**  Description
**      Connects to a server
**
**  Arguments
**      socket  real    The socket to use for the connection
**      url     string  The URL or IP address to connect to.
**      port    real    The port to try to connec to.
**  
*/

var url = argument1;
var port = argument2;

// Run this as the network controller.
with( global.net_object ) {
    socket = argument0;
    connection = network_connect(socket, url, port);
    
    if connection < 0 {
        return false;
    } else {
        multiplayer = true;
        return true;
    }    
}
