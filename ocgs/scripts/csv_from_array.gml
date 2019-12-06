///csv_from_array(array)
/*
**  Description
**      Converts an array of values into a CSV string
**
**  Arguments
**      array   array   The array to convert into a csv
**
**  Returns
**      string      The resulting csv string
*/

var arr = argument0;
var sz = array_length_1d(arr);

var csv = ""

for(var i = 0; i < sz; ++i)
{
    csv += string(arr[i]) + ",";
}

csv = string_delete(csv, string_length(csv), 1);

return csv;
