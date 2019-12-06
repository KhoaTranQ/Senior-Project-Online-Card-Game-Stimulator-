///execute(instance, "method", arg1, arg2, ...);
/*
**  Description
**      execute(instance, "method", arg1, arg2, ...);
**      is rougly equivilent to the Java statement
**      instance.method(arg1, arg2, ...);
**
**  Arguments
**      instance        instance    The instance who's method is being called.
**      method          string      The name of the instance's method.
**      arg2...arg15    mixed       The arguments to use for the call.
**
**  Returns
**      Passes the return value from the executed script.
**
*/

var instance = argument[0];

var name = object_get_name(instance.object_index);

var script = asset_get_index(name + "_" + argument[1]);

if(argument_count <= 2)
    return script_execute(script, instance);
else if(argument_count > 2)
    return script_execute(script, instance, argument[2]);
else if(argument_count > 3)
    return script_execute(script, instance, argument[2], argument[3]);
else if(argument_count > 4)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4]);
else if(argument_count > 5)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5]);
else if(argument_count > 6)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6]);
else if(argument_count > 7)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6], argument[7]);
else if(argument_count > 8)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6], argument[7], 
            argument[8]);
else if(argument_count > 9)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6], argument[7], 
            argument[8], argument[9]);
else if(argument_count > 10)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6], argument[7], 
            argument[8], argument[9], argument[10]);
else if(argument_count > 11)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6], argument[7], 
            argument[8], argument[9], argument[10], argument[11]);
else if(argument_count > 12)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6], argument[7], 
            argument[8], argument[9], argument[10], argument[11], 
            argument[12]);
else if(argument_count > 13)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6], argument[7], 
            argument[8], argument[9], argument[10], argument[11], 
            argument[12], argument[13]);
else if(argument_count > 14)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6], argument[7], 
            argument[8], argument[9], argument[10], argument[11], 
            argument[12], argument[13], argument[14]);
if(argument_count > 15)
    return script_execute(script, instance, argument[2], argument[3], 
            argument[4], argument[5], argument[6], argument[7], 
            argument[8], argument[9], argument[10], argument[11], 
            argument[12], argument[13], argument[14], argument[15]);
