///scr_log_select(log);
/*
**  Description
**      selects a log
**
**  Arguments
**      log     obj_log     The log to select
**
**  Returns
**      <nothing>
**
*/

with(argument0)
{
    mx = scr_norm_x(mouse_x);
    my = scr_norm_y(mouse_y);
    
    if( point_in_rectangle(mx, my, x2 - button, y + margin, x2, y+margin+string_height(hand_text) + margin) )
    {
        colapsed = !colapsed;
    }
    else if( point_in_rectangle(mx, my, x, y, x2, y2) )
    {
        selected = true;
    }
}
