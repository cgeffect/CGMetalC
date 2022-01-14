//
//  add.metal
//  CGMetal
//
//  Created by 王腾飞 on 2021/12/11.
//

#include <metal_stdlib>
using namespace metal;

/// This is a Metal Shading Language (MSL) function equivalent to the add_arrays() C function, used to perform the calculation on a GPU.
kernel void add_arrays(device const float* inA,
                       device const float* inB,
                       device float* result,
                       uint index [[thread_position_in_grid]])
{
    // the for-loop is replaced with a collection of threads, each of which calls this function.
    result[index] = inA[index] + inB[index];
}

