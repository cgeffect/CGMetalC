//
//  CGMetalPlayerInputMac.h
//  CGMetal
//
//  Created by 王腾飞 on 2021/12/7.
//

#import "CGMetalOutput.h"
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#else

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGMetalPlayerInputMac : CGMetalOutput<CGMetalPlayInputProtocol>

@property(nonatomic, assign)BOOL isLoopPlay;

@end

NS_ASSUME_NONNULL_END
#endif
