float limitedFloat(float value, float min, float max){
    if (value < min) value = min;
    else if (value > max) value = max;
    return value;
}

double limitedDouble(double value, double min, double max){
    if (value < min) value = min;
    else if (value > max) value = max;
    return value;
}

