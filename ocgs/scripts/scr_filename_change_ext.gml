///scr_filename_change_ext(fname, newext)
/*
**  Normal filename_change_ext is bugged.
**  This script taken from http://bugs.yoyogames.com/view.php?id=19054
*/

var _file = string(argument0);
var _ext = filename_ext(_file);
var _new_ext = string(argument1);

if(string_length(_ext))
{
    return (string_replace_all(_file, _ext, _new_ext));
}

return(_file + _new_ext);
