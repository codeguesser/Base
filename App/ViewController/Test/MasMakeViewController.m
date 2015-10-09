//
//  MasMakeViewController.m
//  base
//
//  Created by wsg on 15/8/19.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "MasMakeViewController.h"
#import <IFTTTJazzHands.h>

@interface MasMakeViewController (){
    IFTTTAnimator *animator;//只是针对 帧动画
    int cc;
}

@end

@implementation MasMakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    animator = [IFTTTAnimator new];
    
    
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets = UIEdgeInsetsMake(30, 30, 30, 30);
        
        
        
//        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(100);
//        make.centerX.equalTo(self.view).offset = 0;
//        make.centerY.equalTo(self.view).offset = 0;
        
        
        
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.center.mas_offset(CGPointMake(0, 0));
        
        
        
    }];
    
    IFTTTAlphaAnimation *alphaAnimation = [IFTTTAlphaAnimation animationWithView: view];
    [animator addAnimation: alphaAnimation];
    [alphaAnimation addKeyframeForTime:0 alpha:0.f];
    [alphaAnimation addKeyframeForTime:30 alpha:1.f];
    [alphaAnimation addKeyframeForTime:60 alpha:0.f];
    
    [NSTimer scheduledTimerWithTimeInterval:1/2.0 target:self selector:@selector(changeCount) userInfo:nil repeats:YES];
    
    
    UIButton *view2 = [[UIButton alloc]init];
    view2.backgroundColor = [UIColor redColor];
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.offset = 0;
        make.centerX.lessThanOrEqualTo(view).offset = 20;
    }];
    [view2 addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)changeCount{
    cc ++;
    [animator animate:cc];
}
-(void)clicked:(UIButton *)sender{
    [UIView animateWithDuration:.3f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [sender mas_updateConstraints:^(MASConstraintMaker *make) {
            if (sender.isSelected) {
                make.size.mas_equalTo(CGSizeMake(150, 150));
                sender.selected = NO;
            }else{
                make.size.mas_equalTo(CGSizeMake(50, 50));
                sender.selected = YES;
            }
        }];
        [sender layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

@end
