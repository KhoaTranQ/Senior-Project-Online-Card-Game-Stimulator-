/// scr_hand_insert(card, [end])
/*
**  Description
**      Inserts the specified card into the correct position in the hand.
**
**  Arguments
**      card    obj_card    The card to insert.
**      end     bool        [OPTIONAL] When true, will always put the card at the end.
**
**  Returns
**      <nothing>
**
*/

var card = argument[0];
var end_;

if( argument_count > 1 )
    end_ = argument[1];
else
    end_ = false;
    
card.flipped = false;
card.image_index = 0;
card.image_angle = 0;


if( end_ )
{
    // Just put it at the end.
    ds_list_add(global.handCards, card);
}
else
{
    // search from left to right until we find a card who's position is less than ours.
    // and put our card after it.
    var tracker = 0;
    while( tracker < ds_list_size(global.handCards) && card.x > global.handCards[| tracker].x )
        tracker++;
    ds_list_insert(global.handCards, tracker, card);
}
    
ds_list_delete(global.freeCards, ds_list_find_index(global.freeCards, card));
scr_update_depths();
