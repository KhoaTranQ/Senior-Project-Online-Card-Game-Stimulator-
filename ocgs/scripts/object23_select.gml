///object23_select(instance, index)

var instance = argument0;
var index = argument1;
var result = "";

switch index
{
    case 0:
        result = instance.first;
        break;
    case 1:
        result = instance.second;
        break;
    case 2:
        result = instance.third;
        break;
    case 3:
        result = instance.fourth;
        break;
    default:
        result = "failure";
        break;
}

return result;


