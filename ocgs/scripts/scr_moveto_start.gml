///scr_moveto_start(list, value)
/*
**  Description
**      Moves a value from a ds_list to the start of that list.
**
**  Arguments
**      list    ds_list     The list to effect
**      value   mixed       The value to check for and move to the start if found
**
**  Returns
**      true if successful, false if failure, probably meaning the card was not found.
**
*/

var list = argument0;
var value = argument1;

var idx = ds_list_find_index(list, value);

if( idx >= 0)
{
    ds_list_delete(list, idx);
    ds_list_insert(list, 0, value);
    return true;
}
else
{
    return false;
}
