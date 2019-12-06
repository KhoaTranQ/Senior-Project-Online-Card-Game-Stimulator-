/// scr_find_clickable(x, y)
/*
**  Description
**      Finds the highest clickable at the specified position.
**      clickables are obj_deck, obj_card, obj_gizmo, and obj_view
**
**  Arguments:
**      x   real    The x coordinate to check
**      y   real    The y coordinate to check
**
**  Returns:
**      The ID of the found clickable, or noone if none is found.
**
*/

var xCoord = argument0;
var yCoord = argument1;

// Check context menus
with(par_menu)
{
    if( point_in_rectangle(xCoord, yCoord, x1, ty1, x2, ty2) )
    {
        return id;
    }
}

with(obj_log)
{
    if( point_in_rectangle(scr_norm_x(xCoord), scr_norm_y(yCoord), x, y, x2, y2) )
    {
       return id;
    }
}
       
// "with(obj_<type>)" will go through every object of that type.
// position_meeting[_rect] checks for collision with the specified object (id) at the specified
// location (xCoord, yCoord).
// So this will check every object of that type too see if it is coliding with the
// specified position, and check if its depth and closer than the one before.
var closest = noone;

//  Check all decks
with(obj_deck)
    if( position_meeting_rect(xCoord, yCoord, id) 
    && visible == true
    && (closest == noone || closest.depth > id.depth) )
            closest = id;

//  Check all cards
with(obj_card)
    if( position_meeting_rect(xCoord, yCoord, id) 
    && (closest == noone || closest.depth > id.depth) )
            closest = id;

//  Check all gizmos
with(obj_gizmo)
{
    if( position_meeting(scr_norm_x(xCoord), scr_norm_y(yCoord), id) 
    && (closest == noone || closest.depth > id.depth) )
            closest = id;
}           

   

// Check the view panel, if it exists
with(obj_view)
{
    if( point_in_rectangle(xCoord, yCoord, x1, y1, x2, y2) )
    {
         if( closest == noone || closest.depth > id.depth)
         {
            closest = id;
         }
    }
}  
return closest;

