//
//  TestAnimateViewController.m
//  base
//
//  Created by wsg on 15/11/4.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "TestAnimateViewController.h"

@interface TestAnimateViewController (){
    NSString *text;
//    long long time;
    __weak IBOutlet UITextField *_textField;
//    CADisplayLink *link;
}

@end

@implementation TestAnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    link = [CADisplayLink displayLinkWithTarget:self
//                                       selector:@selector(changetime)];
//    link.frameInterval = 1/60.0;
//    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    UIView *mycube = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    mycube.backgroundColor = [UIColor greenColor];
    mycube.center = CGPointMake(160,250);
    [self.view addSubview:mycube];
    
//    [UIView animateKeyframesWithDuration:.3 delay:1 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
//        mycube.transform = CGAffineTransformMakeTranslation(0, 100);
//    } completion:^(BOOL finished) {
//        
//    }];
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.keyPath = @"position";
    animation1.path = bezierPath.CGPath;
    animation1.rotationMode = kCAAnimationLinear;
    //create the color animation
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"backgroundColor";
    animation2.toValue = (__bridge id)[UIColor redColor].CGColor;
    
    
    
    
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1, animation2];
    groupAnimation.duration = 10.0;
    
    [mycube.layer addAnimation:groupAnimation forKey:@"group"];
    
    
//    [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        mycube.transform = CGAffineTransformScale(CGAffineTransformRotate(transform, M_PI), 4, 4);
//        mycube.backgroundColor = [UIColor redColor];
//    } completion:nil];
}

- (IBAction)clicked:(id)sender {
    text = [_textField text];
    _textField.secureTextEntry = !_textField.isSecureTextEntry;
    if(!_textField.isSecureTextEntry)[_textField resignFirstResponder];
}


@end
