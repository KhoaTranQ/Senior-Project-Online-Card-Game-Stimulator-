///scr_norm_coord(x, y)
/*
**  Description
**    Converts view[0] coordinates into screen coordinates.
**
**  Arguments
**      x       real    the x coordinate to convert
**      y       real    the y coordinate to convert
**
**  Returns
**      array[real]     A two-element array containing the new x and y coordinates
**
*/

var xCoord = argument0;
var yCoord = argument1;

coord[0] = (xCoord - view_xview[0])/view_wview[0]*view_wport[0]+view_xport[0];
coord[1] = (yCoord - view_yview[0])/view_hview[0]*view_hport[0]+view_yport[0];

return coord;


