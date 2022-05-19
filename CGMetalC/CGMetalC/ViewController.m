//
//  ViewController.m
//  CGMetalC
//
//  Created by Jason on 2022/5/16.
//

#import "ViewController.h"
#include "MetalCplus.h"
#include "CGMetalView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGMetalView *mView = [[CGMetalView alloc] initWithFrame:NSMakeRect(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:mView];
    MetalCplus *c = [[MetalCplus alloc] init];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
