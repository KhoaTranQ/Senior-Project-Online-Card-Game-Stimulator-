///csv_to_array(csv[, make_real])
/*
**  Description
**      Converts Comma Seperated Values (CSV) into an array.
**
**  Arguments
**      csv         string      The string of comma seperated values to conver into an array.
**      make_real   boolean     Whether to make all of the values in the array reals.
**
**  Returns
**      An array containing the comma seperated values, in order.
*/

var csv = argument[0];

// If an additional argument was supplied, set it to that, otherwise, make it false.
if( argument_count > 1)
    var make_real = argument[1];
else
    var make_real = false;

var curr = 0;
var val = "";

// Ensure the csv is in the format we expect.
if(string_char_at(csv, string_length(csv)) == ",")
{
    csv = string_delete(csv, string_length(csv),1);
}

if(string_char_at(csv, 1) == ",")
{
    csv = string_delete(csv, 1, 1);
}

var num = string_count(",", csv) + 1;


var arr;
arr[num - 1] = "";

// Parse the CSV and populate the array.
var i  = 0;
while( string_lettersdigits(csv) != "")
{
    curr = string_pos(",", csv);
    if( curr == 0)
    {
        val = csv;
        csv = "";
    }
    else
    {
        val = string_copy(csv, 1, curr-1); 
        csv = string_delete(csv, 1, curr);   
    }
    
    // Try to make each value a real if the user asked us to.
    if( make_real )
    {
        val = real(val);
    }
    
    arr[i] = val;
    ++i;
}

return arr;
