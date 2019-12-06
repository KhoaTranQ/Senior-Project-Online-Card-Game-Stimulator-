///scr_zone_free(card)
/*
**  Description
**      Checks if the specified card is free (in the main area)
**
**  Arguments
**      card    obj_card    the card to check for.
**
**  Returns
**      bool    True if the card is free. False if it is not.
**
*/

return ds_list_find_index(global.freeCards, argument0) >= 0
