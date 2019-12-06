///construct_object23(first, second, third, fourth)

var args = ds_map_create();

args[? "first"] = argument0;;
args[? "second"] = argument1;
args[? "third"] = argument2;
args[? "fourth"] = argument3;

var inst = instance_create(args, 0, object23);

ds_map_destroy(args);


return inst;
