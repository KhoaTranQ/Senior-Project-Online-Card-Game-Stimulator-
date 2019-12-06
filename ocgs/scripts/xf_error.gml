/// xf_error()
// Returns the most recently logged error message.
// See: www.xmlfir.com/xf-error


// Get instance of the xml controller
var t__xml = instance_find(xf_asset_object_controller, 0);
    
if (t__xml == noone) {
    t__xml = instance_create(0, 0, xf_asset_object_controller);
}

// Get error string
return t__xml.p_error;
