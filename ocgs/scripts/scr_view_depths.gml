///scr_view_depths
/*
**  Descrition
**      Updates the depths of all of the cards in the current view.
**
**  Arguments
**      <none>
**
**  Returns
**      <nothing>
**
*/

var size = ds_list_size(list);
for(i = 0; i < size; i++)
{
    list[| i].depth = ( (i/size*-1) - 3.5);
}
