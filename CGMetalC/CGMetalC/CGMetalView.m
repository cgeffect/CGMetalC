//
//  CGMetalView.m
//  CGMetalC
//
//  Created by Jason on 2022/5/18.
//

#import "CGMetalView.h"

@implementation CGMetalView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    [self setWantsLayer:YES];
    self.layer.backgroundColor = NSColor.yellowColor.CGColor;
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
