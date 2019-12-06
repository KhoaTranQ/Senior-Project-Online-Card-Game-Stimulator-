///scr_view_find(card)
/*
**  Description
**      Finds a view with the specified card
**
**  Arguments
**      card    obj_card    the card to check for
*/

var card = argument0

with(obj_view)
{
    for(i = 0; i < ds_list_size(list); i++)
    {
        if(card == list[| i])
            return id;
    }
}
return noone;
