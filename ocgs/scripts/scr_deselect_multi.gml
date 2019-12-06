
with(global.input_object)
{
for(i = 0; i< ds_list_size(multi); i++)
{
multi[| i].image_blend = c_white;//blender
}
ds_list_clear(multi);
}
