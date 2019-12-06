///scr_view_remove(view, card)
/*
**  Description
**      Removes the specified card from the specified view and its associated deck.
**
**  Arguments
**      view    obj_view    The view being removed from
**      card    obj_card    The card being removed
**
**  Returns
**      <nothing>
**
*/

with(argument[0])
{
    var card = argument[1];
    
    var pos = ds_list_find_index(list, card);
    
    ds_list_delete(list, pos);
    ds_list_add(global.freeCards, card);
            
    var listpos = per_page * curr_page + pos
    
    if( listpos >= num)
    {
        var sz = ds_list_size(deck.list);
        listpos = sz - reverse + listpos - num;
        ds_list_delete(deck.list, listpos);
        reverse--;
    }
    else
    {
        ds_list_delete(deck.list, listpos);
        num--;
    }
    
    num_pages = ceil((num+reverse) / per_page);
    if(curr_page >= num_pages)
    {
        curr_page = max( num_pages - 1, 0);
        scr_view_update(id);
    }
    else
    {
        scr_view_update(id);
    }
    
    sync_deck_remove(deck, listpos);
}
