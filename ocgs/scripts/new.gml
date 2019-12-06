///new(Object, arg1, arg2, ...)
/*
**  Description
**      var inst = new(Object, arg1, arg2, ...)
**      is roughly equivilent to the Java statement
**      Object inst = new Object(arg1, arg2, ...)
**
**  Argumensts
**      Object          Object      The object to construct.
**      arg1...arg15    mixed       The arguments to use to construct the object.
**
**  Returns
**      The constructed instance.
**
*/


// There are few enough arguments to use only the x and y constructors.
if(argument_count < 4)
{
    if(argument_count == 1)
    {
        var instance = instance_create(0, 0, argument[0]);
    }
    if(argument_count == 2)
    {
        var instance = instance_create(argument[1], 0, argument[0]);
    }
    else if( argument_count == 3)
    {
        var instance = instance_create(argument[1], argument[2], argument[0]);
    }
}
else    // There are too many arguments for the default constructors. Create a list to hold them.
{
    var args = ds_list_create();
    
    for(var i = 1; i < argument_count; i++)
    {
        ds_list_add(args, argument[i]);        
    }
    
    var instance = instance_create(args, 0, argument[0]);
    
    ds_list_destroy(args);
}

return instance;


