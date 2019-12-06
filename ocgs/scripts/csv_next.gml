///csv_next(csv_ptr)
/*
**  Description
**      Gets the value at the front of the csv, and removes it.
**
**  Arguments
**      csv_prt     array(1)    A single-element array containing the csv string.
**                              Doing it this way means I can modify the csv directly.
**
**  Returns
**      The value of the first csv
**
*/

var csv_ptr = argument0;


pos = string_pos(",", csv_ptr[@ 0]);
var val = "";

if(pos == 0)
{
    val = csv_ptr[@ 0];
    csv_ptr[@ 0] = "";
}
else
{
    val = string_copy(csv_ptr[@ 0], 0, pos-1);
    csv_ptr[@ 0] = string_delete(csv_ptr[@ 0], 1, pos);
}

return val;
