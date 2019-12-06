///scr_find_droppable(x, y)
/*
**  Description
**      Finds the highest droppable at the specified position.
**      Droppables are obj_hand, obj_deck, and obj_view
**    
**  Arguments
**      x   real    The x coordinate to check
**      y   real    The y coordinate to check
**
**  Returns
**      The ID of the found droppable, or noone if none was found.
**
*/

var xCoord = argument0;
var yCoord = argument1;

var closest = noone;

//Check every deck
with(obj_deck)
    if ( position_meeting_rect(xCoord, yCoord, id) && ( closest == noone || closest.depth > id.depth) ) {
        closest = id;
    }

//Code for the hand.
if( yCoord > view_yview[1])
{
    closest = global.hand_object;
}

//Code for view/search
with(obj_view)
{
    if(point_in_rectangle(xCoord, yCoord, x1, y1, x2, y2) )
    {
         if( closest == noone || closest.depth > id.depth)
         {
            closest = id;
         }
    }
}

return closest;






