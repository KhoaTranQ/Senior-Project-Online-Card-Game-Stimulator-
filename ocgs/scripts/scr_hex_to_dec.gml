///scr_convert_to_color(hex)
/*
**  Description
**      Converts a hexadecimal string into a decimal real.
**      non-hex characters are treated as 0.
**
**  Arguments
**      hex     string      The hexadecimal string to convert to decimal.
**
**  Returns
**      The decimal representation of the hexadecimal string.
**      
*/

var hex = argument0;
var dec = 0;
var char = "";
var len = string_length(hex)

for(var i = 0; i < len; i++) {
    char = string_char_at(hex, len-i);
    
    if( char == "a" || char == "A") {
        dec += 10 * power(16, i);        
    } else if( char == "b" || char == "B" ) {
        dec += 11 * power(16, i);        
    } else if( char == "c" || char == "C" ) {
        dec += 12 * power(16, i);        
    } else if( char == "d" || char == "D" ) {
        dec += 13 * power(16, i);        
    } else if( char == "e" || char == "E" ) {
        dec += 14 * power(16, i);        
    } else if( char == "f" || char == "F") {
        dec += 15 * power(16, i);        
    } else {
        dec += real(char) * power(16, i);            
    }
}

return dec;

