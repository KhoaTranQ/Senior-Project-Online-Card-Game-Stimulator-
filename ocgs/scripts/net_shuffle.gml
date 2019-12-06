///net_shuffle(data)
/*
**  Description
**      Shuffles a deck based on information from partner
**
**  Arguments
**      data    buffer      The buffer containing the data recieved from partner
**
**  Returns
**      <nothing>
**
*/

var data = argument0;

var net_id = buffer_read(data, buffer_string);
var csv = buffer_read(data, buffer_string);

var code = csv_to_array(csv, true);

var local_deck = syncMap[? net_id];

net_log_add("Other player shuffled a deck");
with(local_deck)
{
    color = 0;
}
scr_rep_shuffle(local_deck.list, code);
