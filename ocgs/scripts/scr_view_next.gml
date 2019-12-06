///scr_view_next(view);
/*
**  Description
**      Turns the specified view to the next page
**
**  Agruments
**      view    obj_view    The view to turn the page of
**
**  Returns
**      <nothing>
**
*/

//  If there are no cards, num_pages would be zero
//  and "num_pages - 1" would be -1, an invalid page.
//  Make sure it can't go below zero.
curr_page = min(curr_page + 1, max(0, num_pages - 1));
scr_view_update(id);
