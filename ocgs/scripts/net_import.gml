///net_import(data)
/*
**  Description
**      "Downloads" partner's deck, and confirms that it has been received.
**
**  Arguments
**      data    buffer      The buffer containing the data recieved from partner
**
**  Returns
**      <nothing>
*/

var data = argument0;

var name = buffer_read(data, buffer_string);
debug("DECK NAME: " + name);

var tmp_buff = buffer_create(1, buffer_grow, 1);

var path = working_directory + "received\" + name;

buffer_copy(data, buffer_tell(data), buffer_get_size(data), tmp_buff, 0);

buffer_save(tmp_buff, path);

buffer_delete(tmp_buff);

zip_unzip(path, "received\tmp\");


buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_u8, sig.confirmImport);
buffer_write(buffer, buffer_string, name);
if( network_send_packet(socket, buffer, buffer_tell(buffer) ) )
{
    debug("Confirmation sent successfully. Name is: " + name);
}
else
{
    debug("ERROR sending confirmation.");
}
                
