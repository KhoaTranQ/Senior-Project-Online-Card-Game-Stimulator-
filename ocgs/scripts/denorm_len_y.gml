///denorm_len_y(len, [view])
/*
**  Description
**      Converts a y distance on the screen to a y distance in a view
**
**  Arguments
**      len     real        the distance to convert
**      [view]  real        The view we're measuring relative to
**
**  Returns
**      real    The the distance you'd have to travel through the view to travel the given distance on the screen.
**
*/


if(argument_count == 1)
{
    return scr_denorm_y(scr_norm_y(view_yview[0]) + argument[0]) - view_yview[0];
}
else
{
    return scr_denorm_y(scr_norm_y(view_yview[argument[1]]) + argument[0]) - view_yview[argument[1]];
}
