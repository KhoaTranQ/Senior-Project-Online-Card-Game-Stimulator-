///scr_view_select(view)
/*
**  Description
**      Tells the view panel to do its own collision checking.
**
**  Arguemnts
**      view    obj_view    The view to check for
**
**  Returns
**      <nothing>
**
*/

with(argument0)
{
    if(point_in_rectangle(mouse_x, mouse_y, x1, y, x, y2) )
    { // Previous
        curr_page = max(0, curr_page - 1);        
        scr_view_update(id);
    }
    else if(point_in_rectangle(mouse_x, mouse_y, x+width, y, x2, y2) )
    { // Next
        scr_view_next();
    }
    else if(point_in_rectangle(mouse_x, mouse_y, x2-nav, y1, x2, y) )
    { // Close
        instance_destroy();
    }
    else if(point_in_rectangle(mouse_x, mouse_y, x1, y1, x2, y) )
    { // Drag/Title bar
        scr_select(id);
    }
    else if(point_in_rectangle(mouse_x, mouse_y, x, y+height, x+width, y2) )
    { // Flip all
        flip_all = !flip_all
        scr_view_update(id);
    }
}
