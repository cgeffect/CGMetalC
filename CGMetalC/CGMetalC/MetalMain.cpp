//
//  MetalMain.cpp
//  CGMetalC
//
//  Created by Jason on 2022/5/16.
//

#include "MetalMain.hpp"
#include <iostream>

#define NS_PRIVATE_IMPLEMENTATION
#define CA_PRIVATE_IMPLEMENTATION
#define MTL_PRIVATE_IMPLEMENTATION
#include <Foundation/Foundation.hpp>
#include <Metal/Metal.hpp>
#include <QuartzCore/QuartzCore.hpp>

#include "BasicFilter.hpp"

MetalMain::MetalMain() {
    MTL::Device* _pDevice;
    _pDevice = MTL::CreateSystemDefaultDevice();
    std::cout << "hello" << std::endl;
    BasicFilter f;
}
