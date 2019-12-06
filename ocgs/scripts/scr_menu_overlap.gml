/// scr_menu_overlap([exclude])
/*
**  Description
**      Check to see if the cursor is in a menu.
**      Can explicily exclude a menu.
**
**  Arguments
**      exclude     par_menu    [Optional] The menu to be excluded from the check.
**
**  Returns
**      true if there was an overlap.
**      false if there was not.
**
*/

with(par_menu) {
    if( argument_count == 0 || id != argument[0]) {
        if (point_in_rectangle(scr_norm_x(mouse_x), scr_norm_y(mouse_y), x1, ty1, x2, ty2)) {
            return true;
        }
    }
}
