
#include "CtlLookupTable.h"
#include "CtlSimdInterpreter.h"

#include <iostream>
#include <chrono>
#include <cstring>
#include <cmath>
#include <cfloat>

static const int LUT_SIZE = 10;
static const float LUT[] = {0.f, 1.f, 2.f, 3.f, 4.f, 5.f, 6.f, 7.f, 8.f, 9.f};
static const float P_MIN = 0.f;
static const float P_MAX = 9.f;

static const size_t DATA_SIZE = 10000000u;

static const size_t TEST_NUMBER = 10u;

void callCtl(Ctl::SimdInterpreter interpreter,
             Ctl::FunctionCallPtr call,
             size_t n,
             float lutMin,
             float lutMax,
             float dataIn[],
             float dataOut[]);


int main()
{
    /* Generate data */

    float* data = new float[DATA_SIZE];

    for (size_t i = 0u; i < DATA_SIZE; ++i)
    {
        data[i] = static_cast<float>(i % 10);
    }

    /* CPU test */

    float* result_cpu = new float[DATA_SIZE];

    double avg_time = 0.;

    std::cout << "-----------------------" << std::endl;
    std::cout << "Performing test for CPU" << std::endl;

    for (size_t test = 0; test < TEST_NUMBER; ++test)
    {
        std::cout << "test #" << test << " from " << TEST_NUMBER <<'\r' << std::flush;

        std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();
        for (size_t i = 0u; i < DATA_SIZE; ++i)
        {
            result_cpu[i] = Ctl::lookup1D(LUT, LUT_SIZE, P_MIN, P_MAX, data[i]);
        }
        std::chrono::steady_clock::time_point end= std::chrono::steady_clock::now();

        avg_time += (std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count()) /
                    1000000.0 / TEST_NUMBER;
    }

    std::cout << "Test for CPU finished. Elapsed time (sec) = " << avg_time << std::endl;

    /* SIMD test */

    std::cout << "------------------------" << std::endl;
    std::cout << "Performing test for SIMD" << std::endl;

    avg_time = 0.;

    float* result_simd = new float[DATA_SIZE];

    Ctl::SimdInterpreter interpreter;
    Ctl::FunctionCallPtr call = nullptr;

    try
    {
        interpreter.loadModule("applyLookup");
        call = interpreter.newFunctionCall("applyLookup");
    }
    catch (const std::exception& /*e*/)
    {
        std::cout << "Test for SIMD failed" << std::endl;
    }

    std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();
    callCtl(interpreter, call, DATA_SIZE, P_MIN, P_MAX, data, result_simd);
    std::chrono::steady_clock::time_point end= std::chrono::steady_clock::now();

    avg_time += (std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count()) / 1000000.0;

    std::cout << "Test for SIMD finished. Elapsed time (sec) = " << avg_time << std::endl;

    /* Compare results */

    bool test_passed = true;

    for (size_t i = 0u; i < DATA_SIZE; ++i)
    {
        if (std::abs(result_simd[i] - result_cpu[i]) > FLT_EPSILON)
        {
            test_passed = false;
            break;
        }
    }

    std::cout << "-----------------------" << std::endl;
    test_passed ? (std::cout << "CPU and SIMD results are equal" << std::endl) :
                  (std::cout << "CPU and SIMD results are not equal" << std::endl);

    delete[] result_simd;
    delete[] result_cpu;
    delete[] data;

    return 0;
}

void applyLUTChunk(Ctl::FunctionCallPtr call,
                   size_t n,
                   float lutMin,
                   float lutMax,
                   float dataIn[],
                   float dataOut[])
{
    Ctl::FunctionArgPtr lutMin_arg = call->findInputArg("lutMin");
    std::memcpy (lutMin_arg->data(), &lutMin, sizeof (float));

    Ctl::FunctionArgPtr lutMax_arg = call->findInputArg("lutMax");
    std::memcpy (lutMax_arg->data(), &lutMax, sizeof (float));

    Ctl::FunctionArgPtr dataIn_arg = call->findInputArg ("dataIn");
    memcpy (dataIn_arg->data(), dataIn, n * sizeof (float));

    call->callFunction(n);

    Ctl::FunctionArgPtr dataOut_arg = call->findOutputArg ("dataOut");
    memcpy (dataOut, dataOut_arg->data(), n * sizeof (float));
}

void callCtl(Ctl::SimdInterpreter interpreter,
             Ctl::FunctionCallPtr call,
             size_t n,
             float lutMin,
             float lutMax,
             float dataIn[],
             float dataOut[])
{
    while (n > 0u)
    {
        const size_t m = std::min(n, interpreter.maxSamples());

        applyLUTChunk(call, m, lutMin, lutMax, dataIn, dataOut);

        n -= m;
        dataIn += m;
        dataOut += m;
    }
}
