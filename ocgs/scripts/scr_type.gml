///scr_type(object)
/*
**  Description
**      Finds the type of a specified object
**
**  Arguments
**      object  mixed   The object to check the type of
**
**  Returns
**      object_index    The index of the object, or noone if there was no object
**
*/

var type = noone;
if(argument0 != noone)
{
    type = argument0.object_index;
}

return type;
