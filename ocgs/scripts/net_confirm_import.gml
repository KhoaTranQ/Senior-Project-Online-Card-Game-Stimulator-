///net_confirm_import(data)
/*
**  Description
**      Once the partner is done downloading our deck, we can start adding our sprites.
**
**  Arguments
**      data    buffer      The buffer containing the data recieved from partner
**
**  Returns
**      <nothing>
*/

var data = argument0;

var name = buffer_read(data, buffer_string);
var path = working_directory + "decks\" + name;
var deck = scr_xml_importer(path);
sync(deck);
sync_finish_import();

