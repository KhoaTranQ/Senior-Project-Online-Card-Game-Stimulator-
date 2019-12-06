// This script searches all files under the specified directory.
// File names are saved in a ds_list which is supplied by the user.
//  argument0 = the name of the directory to start searching.
//  argument1 = the extension part of the files to be found (including the period, and must be in lower case.)
//  argument2 = ds_list which the file names are saved in.
// Example:
//  file_list = ds_list_create();
//  scr_find_files("C:\Windows", ".exe", file_list);

var file_name, dir_name, full_path;var subdir_queue;

// Put the starting position into the queue.subdir_queue = ds_queue_create();

ds_queue_enqueue(subdir_queue, argument0);while (!ds_queue_empty(subdir_queue)) {  
  
// Pop one directory out of the queue.    

dir_name = ds_queue_dequeue(subdir_queue);    

// Search all files and subdirectories under the directory.   
 
file_name = file_find_first(dir_name + '\*', fa_directory);    
while (file_name != '') 
{        
    full_path = dir_name + '\' + file_name;        
    if (file_attributes(full_path, fa_directory)) 
    { 
// a directory            
// Put subdirectories into the queue.            
        if (file_name != '.' && file_name != '..') 
        {                
            ds_queue_enqueue(subdir_queue, full_path);            
        }        
    }        
    else 
    { 
// a normal file            
// Add the file to the list if it has the specified extension.            
        if (string_lower(filename_ext(file_name)) == argument1) 
        {               
            ds_list_add(argument2, full_path);            
        }        
    }        
    ile_name = file_find_next();    
}    
file_find_close();}ds_queue_destroy(subdir_queue);
