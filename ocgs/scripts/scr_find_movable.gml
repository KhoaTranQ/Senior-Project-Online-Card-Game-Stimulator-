/// scr_find_movable(x, y) Finds closest movable at positoin (x, y);
// argument0: x coord
// argument1: y coord

var mouseX = argument0;
var mouseY = argument1;

var closest = noone;
with(par_movable) {
    if ( position_meeting(mouseX, mouseY, id) && closest == noone)
        closest = id;
    else if ( position_meeting(mouseX, mouseY, id) && closest.depth > id.depth )
        closest = id;
}

return closest;

/*
var found = ds_list_create();
var count = 0;
with(obj_movable) {
    if( sprite_exists(self.sprite_index)) {
        var width = sprite_width;
        var height = sprite_height;
        
//        show_debug_message("Using sprite_get_width(): " + sprite_get_width(self.sprite_index));
        
    } else exit;
    
    var xx1 = x - (width / 2);
    var yy1 = y - (height / 2);
    var xx2 = x + (width / 2);
    var yy2 = y + (height / 2);
    
    if( (xx1 <= argument0 && xx2 >= argument0) && (yy1 <= argument1 && yy2 >= argument1) ) {
        ds_list_add(found, id);
        var item = found[| count];
        count++;
    }
}

var i = 0;
var size = ds_list_size(found);
var closest = noone;

if(size > 0) {
    closest = found[| 0];
    
    for(i = 0; i < size; i++) {
        if (found[| i].depth < closest.depth) {
            closest = found[| i];
        }
  //      show_debug_message(sprite_get_name(found[| i].sprite_index) + "is at depth" + string(found[| i].depth));
    }
//    show_debug_message(sprite_get_name(closest.sprite_index) + "was clossest!");
    return closest;
}

return noone;

ds_list_destroy(found);
