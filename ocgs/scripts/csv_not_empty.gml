///csv_not_empty(csv_ptr)
/*
**  Description
**      Checks if a csv has more values or not.
**
**  Arguments
**      csv_ptr     array(1)    a single-element array containing the csv string
**
**  Returns
**      true if not empty
**      false if it is
*/

var csv = argument0[0];

if( string_lettersdigits(csv) == "")
    return false;
else
    return true;
