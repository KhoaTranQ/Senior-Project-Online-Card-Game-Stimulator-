///scr_move(movable)
/*
**  Description
**      Move the specified card or deck.
**      Based on the difference between the mouse's current and previous locations
**
**  Arguments
**      movable     mixed       The obj_card or obj_deck who's position we want to update.
**
**  Return
**      <nothing>
**
*/

with(argument0)
{
//image_blend = c_aqua;//blender
    x += mouse_x - other.old_x;
    y += mouse_y - other.old_y;
}






