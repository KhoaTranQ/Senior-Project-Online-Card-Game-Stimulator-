///scr_xml_importer(path)
/*
**  Description
**      Load cards from a .deck's XML file
**
**  Arguments
**      path    string      Path to the .deck file to import
**
**  Returns
**      obj_deck            The resulting deck
*/

// Get the player's .deck file.
//If they don't select anything, abandon the import.
var filepath = argument0;
if(filepath == "") return -1;

var tmp_subdir = "decks\tmp\";
var info_subpath = tmp_subdir + "info.xml";

// Unzip/"move" the data to the working dir. If there's an error, don't do the rest of this event.
var num = zip_unzip(filepath, tmp_subdir );
if( num <= 0) {
    show_message_async("Couldn't extract the deck!");
    scr_cleanup_dir(tmp_subdir); // In case SOMETHING was extracted
    return -1;
}

// Check to make sure info.xml exists.
if( !file_exists(working_directory + info_subpath)) {
    show_message_async("Couldn't find info.xml!");
    scr_cleanup_dir(tmp_subdir); // clean out directory
    return -1;
}

var xml = scr_get_xml(info_subpath);

//type: xf_node
var root = xf_read_xml(xml);    // Parse the xml data.

if( root < 0 )
{
    show_message_async("ERROR: could not pasrse xml!");
    return -1;
}


var type;                       // e.g. "<global>, <card>"
var attrib;                     // e.g. "<img>, <height>, <back>"
var value;                      // e.g. "88, image.jpg" but it's still a node (not string) until xf_write_xml is used.

// type: string
var sharedFront = "";
var sharedBack = "";

// type: real
var sharedWidth = 0;
var sharedHeight = 0;

var path = "";

// used for error checking
var fileError = false;
var dim = 0;

// Find all the GLOBALs to set up shared values.
// GLOBALS are considered "more important" and so if there's an error in one, abandon the entire import.
// Otherwise the user might be spammed with "missing back" errors for EVERY card that depends on a global.
// or something similar
for(i = 0; i < xf_size(root); i++ ) {
    type = xf_get_child(root, i);
    if( xf_get_value(type) == "GLOBAL") {        
        for(j = 0; j < xf_size(type); j++ ) {
            attrib = xf_get_child(type, j);
            value = xf_get_child(attrib, 0);
            
            // Found img attribute
            if( ( xf_get_value(attrib) == "img") && (xf_get_type(value) == xf_type_text) ) {
                path = working_directory + tmp_subdir + xf_write_xml(value);
                
                // check to make sure the file exists.
                if( !file_exists( path ) ) {
                    show_message_async('ERROR#File "' + path + '" not found.');
                    scr_cleanup_dir(tmp_subdir);
                    return -1;
                }
                else {
                    sharedFront = path;
                }
            }
            
            // Found back attribute
            if( ( xf_get_value(attrib) == "back") && (xf_get_type(value) == xf_type_text) ) {
                path = working_directory + tmp_subdir + xf_write_xml(value);
                
                // check to make sure the file exists.
                if( !file_exists( path ) ) {
                    show_message_async('ERROR#File "' + path + '" not found.');
                    scr_cleanup_dir(tmp_subdir);
                    return -1;
                }
                else {
                    sharedBack = path;
                }
            }
            
            // Found height attribute
            if( (xf_get_value(attrib) == "height") && (xf_get_type(value) == xf_type_text) ) {
                dim = real(xf_write_xml(value));
                if(dim == 0) { // Something is wrong the the dim is recognized as 0.
                    show_message_async("ERROR: GLOBAL height receognized as 0! Are you sure it's a number?");
                    scr_cleanup_dir(tmp_subdir);
                    return -1;
                }
                else { // No errors.
                    sharedHeight = dim;
                }
            }
            
            // Found width attribute  
            if( ( xf_get_value(attrib) == "width") && (xf_get_type(value) == xf_type_text) ) {
                dim = real(xf_write_xml(value));
                if(dim == 0) { // Something is wrong the the dim is recognized as 0.
                    show_message_async("ERROR: GLOBAL width receognized as 0! Are you sure it's a number?");
                    scr_cleanup_dir(tmp_subdir);
                    return -1;
                }
                else { // No errors.
                    sharedWidth = dim;
                }
            }
        }        
    }
}

// Create a deck, create a ds_map to represent each card, and add the map to the deck.
var deck = instance_create(mouse_x, mouse_y, obj_deck);
var copies = 0;

var front = "";
var back = "";
var height = noone;
var width = noone;

var sprite = noone;
var tmp = noone;

for(i = 0; i < xf_size(root); i++) {
    path = "";
    fileError = false;
    type = xf_get_child(root, i);
    if( xf_get_value(type) == "card")
    {
        copies = xf_get_attr(type, "copies");       // Get the number of copies of the card
        if(copies == noone )                           // If copies isn't listed, it only wants one.
            copies = 1;  
        
        // Set to the shared values first, so if they are never overwriten the shared value will be used.                
        front = sharedFront;
        back = sharedBack;
        width = sharedWidth;
        height = sharedHeight;
        
        for(k = 0; k < xf_size(type); k++ ) {
            attrib = xf_get_child(type, k);
            value = xf_get_child(attrib, 0);
            
            // Check if current node is front image. If it is, error check it and import it.
            if( ( xf_get_value(attrib) == "img") && (xf_get_type(value) == xf_type_text) ) {
                path = working_directory + tmp_subdir + xf_write_xml(value);
                
                // check to make sure the file exists.
                if( !file_exists( path ) ) {
                    show_message_async('ERROR#File "' + path + '" not found.');
                    fileError = true;
                    break;
                }
                else {
                    front = path;
                }
            }

            // Check if current node is back image. If it is, error check it and import it.
            if( ( xf_get_value(attrib) == "back") && (xf_get_type(value) == xf_type_text) ) {
                path = working_directory + tmp_subdir + xf_write_xml(value);
                
                // check to make sure the file exists.
                if( !file_exists( path ) ) {
                    show_message_async('ERROR#File "' + path + '" not found.');
                    fileError = true;
                    break;
                }
                else {
                    back = path;
                }
            }
            
            // Check if current node is height. If it is, error check it an prepare it.
            if( (xf_get_value(attrib) == "height") && (xf_get_type(value) == xf_type_text) ) {
                dim = real(xf_write_xml(value));
                if(dim == 0) {
                    show_message_async("ERROR: height receognized as 0! Are you sure it's a number?");
                }
                else {
                    height = dim;
                    fileError = true;
                    break;
                }
            }
            
            // Check if current node is width. If it is, error check it an prepare it.
            if( ( xf_get_value(attrib) == "width") && (xf_get_type(value) == xf_type_text) ) {
                dim = real(xf_write_xml(value));
                if(dim == 0) {
                    show_message_async("ERROR: width receognized as 0! Are you sure it's a number?");
                }
                else {
                    width = dim;
                    fileError = true;
                    break;            
                }
            }
        }
        
        // Was there an error finding a file? If so, don't add any cards based on it.
        if( !fileError )
        {
        
            sprite = sprite_add(front, 0,0,0,0,0);
            tmp = sprite_add(back, 0,0,0,0,0);
            
            // Check to make sure we were able to import the sprites successfully.
            if( !sprite_exists(sprite) )
            {
                show_message_async("ERROR: Image with name#" + front + "#could not be imported!");
            }
            else if( !sprite_exists(tmp) )
            {
                show_message_async("ERROR: Image with name#" + back + "#could not be imported!");
            }
            else
            {   // no image corruption errors
                sprite_merge(sprite, tmp);
                sprite_delete(tmp);
                sprite_net_id = sync_sprite(sprite, filename_name(front), filename_name(back) );
                sprite_set_offset(sprite, sprite_get_width(sprite)/2, sprite_get_height(sprite)/2);
            
                for(j = 0; j < copies; j++)
                { 
                
                    var map = ds_map_create();
                    
                    map[? "net_id"] = net_hash();
                    
                    map[? "sprite"] = sprite;
                    map[? "sprite_net_id"] = sprite_net_id;
                    map[? "height"] = height;
                    map[? "width"] = width;
                    
                    map[? "offset_x"] = sprite_get_width(sprite) / 2;
                    map[? "offset_y"] = sprite_get_height(sprite) / 2;
                    
                    map[? "scale_x"] = width / sprite_get_width(sprite);
                    map[? "scale_y"] = height / sprite_get_height(sprite);
                    
                    map[? "flipped"] = false;
                    map[? "scale"] = 2; // default value. Can be changed.
                                        
                    ds_list_add(deck.list, map);
                }
            }
        }
    }
}

deck.depth = 0;


// Once everything has been loaded, get rid of the files from the temporary directory.
scr_cleanup_dir(tmp_subdir);
return deck;

