///scr_not_in_hand(card)
/*
**  Description
**      Checks if the specified card is in the hand or not.
**
**  Arguments
**      card    obj_card    The card to check for
**
**  Returns
**      bool    true if the card was found in the hand; false if it was not.
**
*/

return (ds_list_find_index(global.handCards, argument0) < 0)
