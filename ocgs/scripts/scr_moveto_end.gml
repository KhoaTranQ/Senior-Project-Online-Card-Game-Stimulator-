///scr_moveto_end(list, value)
/*
**  Description
**      Moves a value from a ds_list to the end of that list.
**
**  Arguments
**      list    ds_list     The list to effect
**      value   mixed       The value to check for and move to the end if found
**
**  Returns
**      true if successful, false if failure, probably meaning the card was not found.
**
*/

var list = argument0;
var value = argument1;

var idx = ds_list_find_index(list, value);

if( idx != -1) {
    ds_list_delete(list, idx);
    ds_list_add(list, value);
    return true;
}
 else {
    return false;
}
