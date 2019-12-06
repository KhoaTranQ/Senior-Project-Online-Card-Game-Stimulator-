/// net_start_server(port);
/*
**  Description
**      Starts a new server using the specified port.
**
**  Arguments
**      port    real    The port to use
**
**  Returns
**      true if the server started successfully.
**      false if the server failed to start.
**
*/


var type = network_socket_tcp;
var max_client = 1;
var port = argument0;

// Run this as the network controller.
with ( global.net_object ) {    
    server = network_create_server(type, port, max_client);

    if server  < 0 {
        show_message("Creation error!");
        network_destroy(server);
        return false;
    } else {
        global.multiplayer = true;
        isServer = true;
        return true;
    }
}
