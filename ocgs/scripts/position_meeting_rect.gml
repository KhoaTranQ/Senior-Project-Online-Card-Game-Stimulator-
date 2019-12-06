/// position_meeting_rect(x, y, rect_inst);
/*
**  Description
**      Checks if the specified instance is at the specified position.
**      Works even if the instance is rotated. DOES NOT SELECT THE BOUNDING BOX.
**      Only works properly for rectangular instances.
**
**  Arguments
**      x           real    The x coordinate of the point to check
**      y           real    The y coordinate of the point to check
**      rect_inst   mixed   The instance to check for collision
**
**  Returns
**      true if the specified instance is at the specified point.
**      false if it is not.
**
*/


var rect = argument2;

// if it's unrotated or trivially rotated, then
// the normal position_meeting function is good enough.
if( rect.image_angle mod 90 == 0)
    return position_meeting(argument0, argument1, rect)

// position to check for collision
var xCoord = argument0;
var yCoord = argument1;

with( rect ) {
//Derive points from rectangle properties.
    var x1, y1, x2, y2, x3, y3;
    
    tlx = x - sprite_xoffset;
    tly = y - sprite_yoffset;
    
    trx = tlx + sprite_width;
    try = tly;
    
    blx = tlx;
    bly = tly + sprite_height;
    
    // Rotate the points of the rectangle.
    var rad = degtorad(-image_angle);
    
    var sint = sin(rad);
    var cost = cos(rad);
    
    var rtlx, rtly, rblx, rbly, rtrx, rtry;
    rtlx = (tlx - x) * cost - (tly - y) * sint + x;
    rtly = (tlx - x) * sint + (tly - y) * cost + y;
    
    rtrx = (trx - x) * cost - (try - y) * sint + x;
    rtry = (trx - x) * sint + (try - y) * cost + y;
    
    rblx = (blx - x) * cost - (bly - y) * sint + x;
    rbly = (blx - x) * sint + (bly - y) * cost + y;
}
    
// Determine if the position is inside the rectangle.
var AMX, AMY, ABX, ABY, ADX, ADY, AMAB, ABAB, AMAD, ADAD

AMX = (xCoord - rtlx);
AMY = (yCoord - rtly);

ABX = (rtrx - rtlx);
ABY = (rtry - rtly);

ADX = (rblx - rtlx);
ADY = (rbly - rtly);

AMAB = dot_product(AMX, AMY, ABX, ABY);
ABAB = dot_product(ABX, ABY, ABX, ABY);
AMAD = dot_product(AMX, AMY, ADX, ADY);
ADAD = dot_product(ADX, ADY, ADX, ADY);

if( (0 < AMAB && AMAB < ABAB) && 
(0 < AMAD && AMAD < ADAD) )
    return true;
else
    return false;













