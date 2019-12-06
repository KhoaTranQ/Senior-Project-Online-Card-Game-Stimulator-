///scr_rotate(inst, amount)

/*
**  Description
**      Rotates a specified card or deck by a specified amount.
**
**  Arguments
**      inst    mixed       The card or deck to rotate.
**      amount  real        The amound to rotate the card or deck
**
**  Returns
**      <nothing>
**
*/

var inst = argument0;
var amount = argument1;

with( inst )
{
    image_angle += amount;
    if(image_angle >= 360 || image_angle < 0)
    {
        image_angle = image_angle mod 360;
    }
}
