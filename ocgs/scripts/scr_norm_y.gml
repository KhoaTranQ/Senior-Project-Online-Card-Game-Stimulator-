///scr_norm_y(yCoord, [view])

var yCoord = argument[0];

if(argument_count == 1)
{
    return (yCoord - view_yview[0])/view_hview[0]*view_hport[0]+view_yport[0];
}
else
{
    return (yCoord - view_yview[argument[1]])/view_hview[argument[1]]*view_hport[argument[1]]+view_yport[argument[1]];
}
