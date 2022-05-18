//
//  MetalCplus.m
//  CGMetalC
//
//  Created by Jason on 2022/5/16.
//

#import "MetalCplus.h"
#include "MetalMain.hpp"

@implementation MetalCplus
- (instancetype)init
{
    self = [super init];
    if (self) {
        MetalMain main;
    }
    return self;
}
@end
