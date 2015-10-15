//
//  TestViewController.m
//  base
//
//  Created by wsg on 15/9/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "TestViewController.h"
#import "LoadingView.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LoadingView *view = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:view];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    view.center = self.view.center;
    
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//    layer.backgroundColor = [UIColor blueColor].CGColor;
//    layer.contentsScale = [UIScreen mainScreen].scale;
//    layer.delegate = self;
//    [view.layer addSublayer:layer];
//    [layer display];
    
    
}
//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//    CGContextSetLineWidth(ctx, 10.0f);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextStrokeEllipseInRect(ctx, layer.bounds);
//}
@end
