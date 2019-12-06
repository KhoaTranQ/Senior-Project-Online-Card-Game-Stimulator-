///denorm_len_x(len, [view]);
/*
**  Description
**      Converts an x distance on the screen to an x distance in a view
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
    return scr_denorm_x(scr_norm_x(view_xview[0]) + argument[0]) - view_xview[0];
}
else
{
    return scr_denorm_x(scr_norm_x(view_xview[argument[1]]) + argument[0]) - view_xview[argument[1]];
}
