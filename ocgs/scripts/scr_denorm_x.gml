///scr_denorm_x(xCoord, [view])

var xCoord = argument[0];

if(argument_count == 1)
{
    return (xCoord - view_xport[0])/view_wport[0]*view_wview[0]+view_xview[0];
}
else
{
    return (xCoord - view_xport[argument[1]])/view_wport[argument[1]]*view_wview[argument[1]]+view_xview[argument[1]];
}
