//
//  PunchedCardViewController.m
//  base
//
//  Created by wsg on 15/11/5.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "PunchedCardViewController.h"
#import "PunchedCardButton.h"
@interface PunchedCardViewController (){
    
    __weak IBOutlet PunchedCardButton *punchedButton;
}

@end

@implementation PunchedCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    //设置关键帧
    //与基础动画不同，关键帧动画必须指明动画初始值
    NSValue *value1 = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(1, 1)];
    NSValue *value2 = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    NSValue *value3 = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeScale(0.2, 0.2)];
    
    animation.duration = 2;
    animation.values = @[value1,value2,value3];
    animation.autoreverses = YES;
    
    [punchedButton.layer addAnimation:animation forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
