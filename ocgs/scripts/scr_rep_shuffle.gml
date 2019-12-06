///scr_rep_shuffle(list, [order])
/*
**  Description
**      A reproducible shuffle.
**      Can either shuffle randomly and give an array to re-do it later,
**      Or can re-do a shuffle based on an array.
**
**  Arguments
**      list    ds_list     The list to shuffle.
**      order   array       OPTIONAL: The array to use to reproduce a previous shuffle. 
**
**  Returns
**      An array containing a sequence that can be fed back into
**      this script to reproduce the shuffle that just happened.
**
*/

var list = argument[0];
var arr;

var size = ds_list_size(list);

if( argument_count > 1 )
{
    arr = argument[1];
    if(array_length_1d(arr) != size - 2)
    {
        debug("order incompatible with list!");
        return false;
    }
}
else
{       
    for( var i = size - 1; i > 1; --i)
    {
        arr[i-2] = irandom_range(0, i);
    }
}

var temp;
for(var i = size - 1; i > 1; --i)
{
    tmp = list[| i];
    list[| i] = list[| arr[i-2]];
    list[| arr[i-2]] = tmp;
}

return arr;
