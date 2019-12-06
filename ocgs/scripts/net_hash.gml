/// net_hash()
/*
**  Description
**      Generates a random eight-character has windows can use as a filename.
**
**  Arguments
**      <none>
**
**  Returns
**      The eight-character hash string.
**
*/

var str = "";
var rand = " ";
var exclude = '<>?*/\":| '

// Allow everything from  33--126 except those listed.
repeat(8) {
    // If rand is found in exclude, we can't use it. Try again.
    
    do {
        rand = chr(irandom_range(33,126));
    } until( string_pos(rand, exclude) == 0 )
    
    str = str + rand;
}

/*
There is currently no verification that the hash generated is unique.
But the odds of two hashes being the same should be astronomically low.
*/
return str;
