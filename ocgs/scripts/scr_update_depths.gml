///scr_update_depths([main, hand, view])
/*
**  Description
**      Update the depths of cards in the zones.
**      With no arguments specified, all depths will be updated.
**      If any argument is specified, they must all be specified.
**      The arguments determine which views will be updated.
**
**  Arguments
**  [Optional:
**      main    bool    Whether to update the depths of cards in the main area
**      hand    bool    Whether to update the depths of cards in the hand
**      view    bool    Whether to update the depths of cards in a view/search panel
**  ]
**
**  Returns
**      <nothing>
**
*/

var main, hand, view;

if(argument_count > 0)
{
    main = argument[0];
    hand = argument[1];
    view = argument[2];
}
else
{
    main = true;
    hand = true;
    view = true;
}

var size = 0;

if(main)
{
    // Update every free card's depth to the inverse of its position.
    // and normalize so the closest card is at depth == 1
    size = ds_list_size(global.freeCards);
    for(i = 0; i < size; i++) {
        global.freeCards[| i].depth = (-1*i) + size;
    }
}

if(hand)
{
    // Update every hand card's depth based on its position
    // normalise so every card is between -1.5 and -2.5, with the farthest right
    // cards being higher.
    size = ds_list_size(global.handCards);
    for(i = 0; i < size; i++) {
        global.handCards[| i].depth = ((i/size*-1) - 1.5);// change this 1.5
    }
}
