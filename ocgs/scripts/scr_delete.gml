///scr_delete(object)
/*
**  Description
**      Deletes the selected object, and does cleanup.
**
**  Arguments
**      object  mixed   The object to delete, obj_card or obj_deck
**
**  Returns
**      <nothing>
**
*/

var object = argument0;

switch(object.object_index)
{
    case obj_gizmo:
        object = object.deck;
        
    case obj_card:
    case obj_deck:    
        scr_deselect_multi();
    
        sync_delete(object);
        with(object)
        {
            instance_destroy();
        }
        break;
}
