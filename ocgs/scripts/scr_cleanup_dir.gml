///scr_cleanup_dir(subdir)
/*
**  Description
**      Deletes the files in the \tmp\ subdirectory.
**
**  Arguments
**      subdir  string      The directory to clean
**
**  Returns
**      <none>
**
*/

var subdir = argument0;

/*
var delFileName = file_find_first(working_directory + subdir + "*.*", 0);
var delPath = working_directory + subdir + delFileName;
while(delFileName != "") {
    file_delete(delPath);
    delFileName = file_find_next();
    delPath = working_directory + subdir + delFileName;
}
*/
if (directory_exists(subdir))
{
    directory_destroy(subdir);
}
else
{
    debug("Couldn't find directory!");
}
