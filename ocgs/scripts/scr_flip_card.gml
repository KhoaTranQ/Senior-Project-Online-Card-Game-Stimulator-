/// scr_flip_card(card)
/*
**  Description
**      Flips the specified card.
**
**  Arguments
**      card    obj_card    The card to flip.
**
**  Returns
**      <nothing>
**
*/

with(argument0) {

    // A bit of a "hack" since image_index is not a true boolean.
    flipped = !flipped
    image_index = !image_index;
    
    // This method might be more reliable.
    /*
    switch image_index
    {
        case 0:
            image_index = 1;
            break;
        case 1:
            image_index = 0;
            break;
        default:
            show_message_async("Error flipping card!");
            break;
    }
    */
}
