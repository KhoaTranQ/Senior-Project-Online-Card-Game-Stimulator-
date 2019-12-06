///// scr_search_insert(card)

var card = argument0;

// search from left to right until we find a card who's position is less than ours.
// and put our card after it.
var counter = 0;

while( counter < ds_list_size(global.searchCards) && card.x > global.searchCards[| counter].x )
    counter++;
    
ds_list_insert(global.searchCards, counter, card);
