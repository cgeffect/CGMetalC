//
//  BasicFilter.cpp
//  CGMetalC
//
//  Created by Jason on 2022/5/16.
//

#include "BasicFilter.hpp"
#include <iostream>
#include <Foundation/Foundation.hpp>
#include <Metal/Metal.hpp>
#include <QuartzCore/QuartzCore.hpp>

BasicFilter::BasicFilter() {
    MTL::Device* _pDevice;
    _pDevice = MTL::CreateSystemDefaultDevice();
    std::cout << "hello" << std::endl;
}
