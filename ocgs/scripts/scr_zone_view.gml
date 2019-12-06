///scr_zone_view(card)
/*
**  Description
**      Checks if the specified card is in the view zone.
**
**  Arguments
**      card    obj_card    the card to check for.
**
**  Returns
**      bool    True if the card is in the view. False if it is not.
**
*/

with(obj_view)
{
    if(ds_list_find_index(list, argument0) >= 0)
        return true;
}

return false;
