///scr_zone_hand(card)
/*
**  Description
**      Checks if the specified card is in the hand zone.
**
**  Arguments
**      card    obj_card    the card to check for.
**
**  Returns
**      bool    True if the card is in the hand. False if it is not.
**
*/

return (ds_list_find_index(global.handCards, argument0) >= 0);
