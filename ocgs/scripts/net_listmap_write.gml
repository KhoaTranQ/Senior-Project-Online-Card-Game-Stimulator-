///net_listmap_write( listmap )
/*
**  Description
**      Converts a list of maps into a single large string for transfer over a network.
**
**  Arguments
**      listmap     list    The list of maps to convert.
**
**  Returns
**      A string that can be read to recreate the listmap.
**
*/

var listmap = argument0;

var size = ds_list_size(listmap);

var map_string_list = ds_list_create();

// Convert each map into a string, and put it in a new list.
for(var i = 0; i < size; i++)
{
    ds_list_add(map_string_list, ds_map_write(listmap[| i]));
}

//  Convert the new list into a single massive string.
var string_list = ds_list_write(map_string_list);

//  We don't need this any more.
ds_list_destroy(map_string_list);

return string_list;

