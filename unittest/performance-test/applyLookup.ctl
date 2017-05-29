const float lut[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

void applyLookup(input float lutMin,
                 input float lutMax,
                 input varying float dataIn,
                 output varying float dataOut)
{
    dataOut = lookup1D(lut, lutMin, lutMax, dataIn);
}

