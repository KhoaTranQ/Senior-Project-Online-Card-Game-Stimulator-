/// xf_exists(node)
// Returns whether the given node argument exists or not.
// See: www.xmlfir.com/xf-exists


if (!is_real(argument0)) {
    return false;
}
else if (!ds_exists(argument0, ds_type_list)) {
    return false;
}
else if (ds_list_size(argument0) != xf_prop_size) {
    return false;
}
else if (!is_real(ds_list_find_value(argument0, xf_prop_type))) {
    return false;
}
else if (ds_list_find_value(argument0, xf_prop_type) < 1) {
    return false;
}
else if (ds_list_find_value(argument0, xf_prop_type) > 5) {
    return false;
}

return true;
