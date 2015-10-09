//
//  TestAnimatViewController.m
//  base
//
//  Created by wsg on 15/9/10.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "TestAnimatViewController.h"
#import <IFTTTJazzHands.h>
@interface TestAnimatViewController ()
@property (nonatomic ,strong) UIImageView *backgroundView;
@property (nonatomic ,strong) UIImageView *phone1View;
@property (nonatomic ,strong) UIImageView *phone2View;
@property (nonatomic ,strong) UIImageView *phone3View;


@property (nonatomic ,strong) UIImageView *phone1icon1View;
@property (nonatomic ,strong) UIImageView *phone1icon2View;
@property (nonatomic ,strong) UIImageView *phone1icon3View;

@property (nonatomic ,strong) UIImageView *phone2icon1View;
@property (nonatomic ,strong) UIImageView *phone2icon2View;
@property (nonatomic ,strong) UIImageView *phone2icon3View;

@property (nonatomic ,strong) UIImageView *phone3icon1View;
@property (nonatomic ,strong) UIImageView *phone3icon2View;
@property (nonatomic ,strong) UIImageView *phone3icon3View;
@end

@implementation TestAnimatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    [self.contentView addSubview:self.backgroundView];
    
    [self setupPhone1View];
    [self setupPhone2View];
    [self setupPhone3View];
    [self setupPhone1IconsView];
    
    
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    [self keepView:self.phone1View onPages:@[@(0),@(1)] atTimes:@[@(0),@(1)]];
    [self keepView:self.phone2View onPages:@[@(3)] atTimes:@[@(3)]];
    [self keepView:self.phone3View onPages:@[@(4)] atTimes:@[@(4)]];
    
    [self keepView:self.backgroundView onPages:@[@(0),@(1),@(2),@(3),@(4)] atTimes:@[@(0),@(1),@(2),@(3),@(4)]];
    
    [self keepView:self.phone1icon1View onPages:@[@(-0.25),@(0.75),@(1.75)] atTimes:@[@(0),@(1),@(2)]];
    [self keepView:self.phone1icon2View onPages:@[@(0.25),@(1.25),@(2.25)] atTimes:@[@(0),@(1),@(2)]];
    
    
    IFTTTAlphaAnimation *phone1icon1Animate = [IFTTTAlphaAnimation animationWithView:self.phone1icon1View];
    [phone1icon1Animate addKeyframeForTime:0 alpha:0];
    [phone1icon1Animate addKeyframeForTime:1 alpha:1];
    [self.animator addAnimation:phone1icon1Animate];
    
    IFTTTScaleAnimation *phone1icon1Animate1 = [IFTTTScaleAnimation animationWithView:self.phone1icon1View];
    [phone1icon1Animate1 addKeyframeForTime:0 scale:0.1];
//    [phone1icon1Animate1 addKeyframeForTime:0.3 scale:1];
    [phone1icon1Animate1 addKeyframeForTime:0.5 scale:2];
    [phone1icon1Animate1 addKeyframeForTime:1 scale:1];
    [self.animator addAnimation:phone1icon1Animate1];
    
    IFTTTAlphaAnimation *phone1icon2Animate = [IFTTTAlphaAnimation animationWithView:self.phone1icon2View];
    [phone1icon2Animate addKeyframeForTime:0 alpha:0];
    [phone1icon2Animate addKeyframeForTime:1 alpha:1];
    [self.animator addAnimation:phone1icon2Animate];
    
    //居然不起作用，fuckkkkkkkkk you
    [self.scrollView setContentOffset:CGPointMake(1, 0)];
    [self.scrollView layoutIfNeeded];
    [self.scrollView setNeedsDisplay];
    [self.scrollView setNeedsLayout];
    
    
    [UIView animateWithDuration:5.0f delay:1 usingSpringWithDamping:.9f initialSpringVelocity:.9f options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*5, 0)];
    } completion:nil];
    
//    [UIView animateWithDuration:1.0f delay:1 usingSpringWithDamping:.9f initialSpringVelocity:.9f options:UIViewAnimationOptionLayoutSubviews animations:^{
//        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)animated:YES];
//    } completion:nil];
//    
//    [UIView animateWithDuration:0.5f delay:2 usingSpringWithDamping:.9f initialSpringVelocity:.9f options:UIViewAnimationOptionLayoutSubviews animations:^{
//        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0)animated:YES];
//    } completion:nil];
//    [UIView animateWithDuration:1.5f delay:2.5 usingSpringWithDamping:.9f initialSpringVelocity:.9f options:UIViewAnimationOptionLayoutSubviews animations:^{
//        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*3, 0)animated:YES];
//    } completion:nil];
//    
//    [UIView animateWithDuration:1.5f delay:4 usingSpringWithDamping:.9f initialSpringVelocity:.9f options:UIViewAnimationOptionLayoutSubviews animations:^{
//        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*4, 0) animated:YES];
//    } completion:nil];
//    
//    [UIView animateWithDuration:1.5f delay:5.5 usingSpringWithDamping:.9f initialSpringVelocity:.9f options:UIViewAnimationOptionLayoutSubviews animations:^{
//        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*5, 0)animated:YES];
//    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfPages
{
    // Tell the scroll view how many pages it should have
    return 8;
}
- (void)configureScrollViewAnimations
{
    // change the scrollView's background color from dark gray to blue just after page 1
    IFTTTBackgroundColorAnimation *backgroundColorAnimation = [IFTTTBackgroundColorAnimation animationWithView:self.scrollView];
    [backgroundColorAnimation addKeyframeForTime:1 color:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.f]];
    [backgroundColorAnimation addKeyframeForTime:1.1 color:[UIColor colorWithRed:0.14f green:0.8f blue:1.f alpha:1.f]];
    [self.animator addAnimation:backgroundColorAnimation];
}
-(void)setupPhone1View{
    
    self.phone1View = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone1"]];
    [self.contentView addSubview:self.phone1View];
    [self.phone1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
    }];
}
-(void)setupPhone2View{
    self.phone2View = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone2"]];
    [self.contentView addSubview:self.phone2View];
    [self.phone2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
    }];
}
-(void)setupPhone3View{
    self.phone3View = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone3"]];
    [self.contentView addSubview:self.phone3View];
    [self.phone3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
    }];
}
-(void)setupPhone1IconsView{
    
    self.phone1icon1View = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone1icon1"]];
    [self.contentView addSubview:self.phone1icon1View];
    [self.phone1icon1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@-100);
    }];
    self.phone1icon2View = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone2icon2"]];
    [self.contentView addSubview:self.phone1icon2View];
    [self.phone1icon2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(@0);
    }];
}
@end
