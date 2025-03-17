//
//  ViewController.m
//  CGMetalC
//
//  Created by Jason on 2022/5/16.
//

#import "ViewController.h"
#include "MetalMain.hpp"
#include "CGMetalView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGMetalView *mView = [[CGMetalView alloc] initWithFrame:NSMakeRect(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:mView];

    MetalMain main;

    // Do any additional setup after loading the view.
}

@end
