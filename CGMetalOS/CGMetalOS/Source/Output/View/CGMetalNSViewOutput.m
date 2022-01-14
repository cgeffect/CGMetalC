//
//  CGMetalNSViewOutput.m
//  CGMetalMac
//
//  Created by 王腾飞 on 2021/12/4.
//


#import "CGMetalNSViewOutput.h"
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#else
#import "CGMetalOutput.h"
#import "CGMetalRender.h"
#import "CGMetalDevice.h"
@import Metal;

#define VertexShader @"CGRenderVertexShader"
#define FragmentShader @"CGRenderFragmentShader"

@interface CGMetalNSViewOutput ()
{
    id<MTLCommandQueue> _commandQueue;
    id<MTLBuffer> _indexBuffer;
    CAMetalLayer *_metalLayer;
    CGMetalRender *_mtlRender;
}
@end

@implementation CGMetalNSViewOutput

@synthesize inTexture = _inTexture;
@synthesize contentMode = _contentMode;
@synthesize alphaChannelMode = _alphaChannelMode;
@synthesize isWaitUntilCompleted = _isWaitUntilCompleted;
@synthesize isWaitUntilScheduled = _isWaitUntilScheduled;

//或者使用self.layer = [CAMetalLayer layer];
- (CALayer *)makeBackingLayer {
    return [CAMetalLayer layer];
}
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.wantsLayer = YES;
        CAMetalLayer *metalLayer = (CAMetalLayer *) self.layer;
        [metalLayer setDevice:[CGMetalDevice sharedDevice].device];
        _alphaChannelMode = CGMetalAlphaModeRGBA;
        _commandQueue = [CGMetalDevice sharedDevice].commandQueue;
        metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
        metalLayer.framebufferOnly = true;
        CGFloat scale = NSScreen.mainScreen.backingScaleFactor;
        metalLayer.contentsScale = scale;
        //像素值
        metalLayer.drawableSize = CGSizeApplyAffineTransform(self.bounds.size, CGAffineTransformMakeScale(scale, scale));
        _metalLayer = metalLayer;
        
        _mtlRender = [[CGMetalRender alloc] initWithVertexShader:VertexShader
                                                  fragmentShader:FragmentShader
                                                     pixelFormat:MTLPixelFormatBGRA8Unorm
                                                           index:0];
        //fbo的颜色
        _mtlRender.renderTargetDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1);
        //clear fbo, 防止残留数据
        _mtlRender.renderTargetDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        _mtlRender.renderTargetDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;

        //MTLBuffer是一个存储器, 可以存储任意数据
        _indexBuffer = [[CGMetalDevice sharedDevice].device newBufferWithBytes: _indices
                                            length: sizeof(_indices)
                                           options: MTLResourceStorageModeShared];
        
        //最大帧率
//        if (@available(macOS 12.0, *)) {
//            NSInteger maximumFramesPerSecond = NSScreen.mainScreen.maximumFramesPerSecond;
//            NSLog(@"设备支持最大帧率: %ld fps", (long)maximumFramesPerSecond);
//        } else {
//            // Fallback on earlier versions
//        }
    }
    return self;
}
- (void)setCanvasColor:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    _mtlRender.renderTargetDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(red, green, blue, alpha);
}
#pragma mark - CGMetalInput
- (void)newTextureAvailable:(CGMetalTexture *)inTexture {
    _inTexture = inTexture;
    NSUInteger width = 0;
    if (_alphaChannelMode == CGMetalAlphaModeRGBA) {
        width = inTexture.texture.width;
    } else if (_alphaChannelMode == CGMetalAlphaModeAloneAlpha) {
        width = inTexture.texture.width / 2.0;
    } else if (_alphaChannelMode == CGMetalAlphaModeScaleAlpha) {
        width = inTexture.texture.width / 3.0 * 2.0;
    }

    NSUInteger height = inTexture.texture.height;
    //render
    id<CAMetalDrawable> currentDrawable = [_metalLayer nextDrawable];
    [_mtlRender setOutTexture:currentDrawable.texture index:0];
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"CGMetalView Command Buffer";
    
    id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor: _mtlRender.renderTargetDescriptor];
    encoder.label = @"CGMetalView Command Encoder";
    
    CGRect viewPort = [self glPrepareViewport:width height:height];
    int x = (int) viewPort.origin.x;
    int y = (int) viewPort.origin.y;
    int w = (int) viewPort.size.width;
    int h = (int) viewPort.size.height;

    [encoder setViewport: (MTLViewport) {
        .originX = x,
        .originY = y,
        .width = w,
        .height = h,
        .znear = 0,
        .zfar = 1
    }];
    [encoder setRenderPipelineState: _mtlRender.renderPipelineState];
    
    //setVertexBytes:length:atIndex:方法是将非常少量（小于 4 KB）的动态缓冲区数据绑定到顶点函数的最佳选择，此方法避免了创建中间MTLBuffer对象的开销。Metal 为您管理一个临时缓冲区。
    //如果您的数据大小大于4KB，创建一个MTLBuffer对象并根据需要更新其内容。调用setVertexBuffer:offset:atIndex:方法将缓冲区绑定到一个顶点函数；
    //如果您的缓冲区包含在多个绘制调用中使用的数据，则setVertexBufferOffset:atIndex:随后调用该方法以更新缓冲区偏移量，使其指向相应的绘制调用数据的位置，如果您只是更新其偏移量，则无需重新绑定当前绑定的缓冲区。
    [encoder setVertexBytes: _vertices
                     length: sizeof(_vertices)
                    atIndex: 0];
    [encoder setVertexBytes: _texCoord
                     length: sizeof(_texCoord)
                    atIndex: 1];
    [encoder setFragmentTexture: inTexture.texture
                        atIndex: 0];
    
    /*
     MTLPrimitiveTypePoint = 0, 点
     MTLPrimitiveTypeLine = 1, 线段
     MTLPrimitiveTypeLineStrip = 2, 线环
     MTLPrimitiveTypeTriangle = 3,  三角形
     MTLPrimitiveTypeTriangleStrip = 4, 三角型扇
     */
    [encoder drawIndexedPrimitives: MTLPrimitiveTypeTriangle
                        indexCount: 6
                         indexType: MTLIndexTypeUInt32
                       indexBuffer: _indexBuffer
                 indexBufferOffset: 0];
    [encoder endEncoding];
    
    //addCompletedHandler must be register before commit, otherwise crash
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> _Nonnull buffer) {
//        NSLog(@"command buffer has completed execution");
    }];
    [commandBuffer addScheduledHandler:^(id<MTLCommandBuffer> _Nonnull buffer) {
//        NSLog(@"command buffer has been scheduled for execution");
    }];
    [commandBuffer presentDrawable: currentDrawable];
    [commandBuffer commit];
}

#pragma mark private
- (CGRect)glPrepareViewport:(NSUInteger)texWidth height:(NSUInteger)texHeight {
    if (texWidth == 0 || texHeight == 0) {
        return CGRectZero;
    }
    int x, y, w, h;
    int layerW = (int) self->_metalLayer.drawableSize.width;
    int layerH = (int) self->_metalLayer.drawableSize.height;
    float ratio_tex = (float) texHeight / texWidth;
    float ratio_layer = (float)layerH / (float)layerW;
    if (ratio_tex > ratio_layer) {
        h = (int) layerH;
        w = (int) (layerH / ratio_tex);
    } else {
        w = (int) layerW;
        h = (int) (layerW * ratio_tex);
    }
    x = ((int) layerW - w) / 2;
    y = ((int) layerH - h) / 2;
    return CGRectMake(x, y, w, h);
}

- (void)dealloc {
    
}

@end
#endif
