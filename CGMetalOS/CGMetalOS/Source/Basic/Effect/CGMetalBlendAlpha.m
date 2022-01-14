//
//  CGMetalBlendAlpha.m
//  CGMetal
//
//  Created by 王腾飞 on 2021/11/19.
//

#import "CGMetalBlendAlpha.h"

#define kCGMetalAlphaFragmentShader @"kCGMetalAlphaFragmentShader"

@implementation CGMetalBlendAlpha

- (instancetype)init {
    self = [super initWithFragmentShader:kCGMetalAlphaFragmentShader];
    if (self) {

    }
    
    return self;
}

@end
