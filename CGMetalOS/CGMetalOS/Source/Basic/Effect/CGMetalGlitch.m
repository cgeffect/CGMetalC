//
//  CGMetalGlitch.m
//  CGMetalOS
//
//  Created by 王腾飞 on 2022/1/1.
//  Copyright © 2022 com.metal.Jason. All rights reserved.
//

#import "CGMetalGlitch.h"

#define kCGMetalGlitchFragmentShader @"kCGMetalGlitchFragmentShader"

@implementation CGMetalGlitch

- (instancetype)init {
    self = [super initWithFragmentShader:kCGMetalGlitchFragmentShader];
    if (self) {

    }
    return self;
}

- (void)mslEncodeCompleted {
    [self setFragmentValue1:_vec_float1 index:0];
}

@end
