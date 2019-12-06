/// position_meeting_rectangular_nonprecise_rotatable(x, y, rect_inst);

var rect = argument2;

// if it's rotated by exactly 90* (or isn't rotated at all)
// then the normal position_meeting function is good enough.
// don't bother with complex calculations!
if( rect.image_angle mod 90 == 0) {
//    show_debug_message("Unrotated or trivialy rotated.");
    return position_meeting(argument0, argument1, rect)
}
//    show_debug_message("Nontrivial rotation");

with( rect ) {
// Rortatet the rectangle that is defined by the instances properties.
    var rad = degtorad(-image_angle);
    
    var sint = sin(rad);
    var cost = cos(rad);
    
    var rtlx, rblx, rtrx, rbrx, rtly, rtry, rbly, rbry;
    rtlx = (-sprite_xoffset) * cost - (-sprite_yoffset) * sint + x;
    rtly = (-sprite_xoffset) * sint + (-sprite_yoffset) * cost + y;
    
    // Determine if the position given is inside the rectangle.
    var AMX, AMY, ABX, ABY, ADX, ADY, AMAB, ABAB, AMAD, ADAD
    
    AMX = (argument0 - rtlx);
    AMY = (argument1 - rtly);
    
    ABX = (((-sprite_xoffset + sprite_width) * cost - (-sprite_yoffset) * sint + x) - rtlx);
    ABY = (((-sprite_xoffset + sprite_width) * sint + (-sprite_yoffset) * cost + y) - rtly);
    
    ADX = (((-sprite_xoffset) * cost - (-sprite_yoffset+sprite_height) * sint + x) - rtlx);
    ADY = (((-sprite_xoffset) * sint + (-sprite_yoffset+sprite_height) * cost + y) - rtly);
}

AMAB = dot_product(AMX, AMY, ABX, ABY);
ABAB = dot_product(ABX, ABY, ABX, ABY);
AMAD = dot_product(AMX, AMY, ADX, ADY);
ADAD = dot_product(ADX, ADY, ADX, ADY);


if( (0 < AMAB && AMAB < ABAB) && 
(0 < AMAD && AMAD < ADAD) )
    return true;
else
    return false;













