///scr_get_xml(path)

info_subpath = argument0;

// Open info.xml as a file, and convert the file's contents to a string.
var file = file_text_open_read(working_directory + info_subpath);
var xml  = "";
while (!file_text_eof(file))
{
    xml += file_text_readln(file);
}
file_text_close(file);

return xml;
