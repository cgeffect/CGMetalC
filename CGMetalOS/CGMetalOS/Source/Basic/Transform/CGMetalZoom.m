//
//  CGMetalZoom.m
//  CGMetalOS
//
//  Created by 王腾飞 on 2021/12/30.
//

#import "CGMetalZoom.h"
#define zoomVertex @"zoomVertex"

@implementation CGMetalZoom
{
    id<MTLBuffer> _buffer;
}

float matrix[16] = {
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
};

float* scalingMatrix(float matrix[16], float scale) {
    matrix[0] = scale;
    matrix[5] = scale;
    matrix[10] = scale;
    matrix[15] = 1.0;
    return matrix;
}

- (instancetype)init {
    self = [super initWithVertexShader:zoomVertex];
    if (self) {
        _buffer = [[CGMetalDevice sharedDevice].device newBufferWithBytes: matrix
                                            length: sizeof(matrix)
                                           options: MTLResourceStorageModeShared];
        _vec_float1.x = 1;
    }
    
    return self;
}

- (void)setInValue1:(vec_float1)inValue {
    _vec_float1.x = inValue.x * 2;
}

- (void)mslEncodeCompleted {
    float *mat = scalingMatrix(matrix, _vec_float1.x);
    [self.commandEncoder setVertexBytes: mat length: sizeof(matrix) atIndex: 2];
}

@end
