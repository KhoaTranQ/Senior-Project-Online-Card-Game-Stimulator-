///scr_flip_deck(deck)
/*
**  Description
**      Reverses the deck's list, and flips every card in it.
**
**  Arguments
**      deck    obj_deck    The deck to flip.
**
**  Returns
**      <nothing>
**
*/

var deckList = argument0.list;
var size = ds_list_size(deckList);
var temp;

//  Reverse the card order
for( i = 0; i < floor(size/2); i++) {
    temp = deckList[| i];
    deckList[| i] = deckList[| size - 1 - i ];
    deckList[| size - 1 - i ] = temp;
}

// Flip every card in the list
for( i = 0; i < size; i++ ) {
    temp = deckList[| i];
    temp[? "flipped"] = !temp[? "flipped"];
}
