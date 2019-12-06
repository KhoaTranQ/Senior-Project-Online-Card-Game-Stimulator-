/// xf_controller()
// Returns an instance of the xml controller object, creating it if it doesn't exist
// See: www.xmlfir.com/xf-controller


// Return instance
if (instance_exists(xf_asset_object_controller)) {
    return instance_find(xf_asset_object_controller, 0);
}

return instance_create(0, 0, xf_asset_object_controller);
