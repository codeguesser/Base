//
//  Animator.m
//  base
//
//  Created by wsg on 15/8/25.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "CGAnimator.h"
@interface CGAnimator()<UIViewControllerAnimatedTransitioning>
@end
@implementation CGAnimator
#pragma mark -  动画的主要方法 主要是给当前类的使用
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    @weakify(fromViewController)
    @weakify(toViewController)
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        @strongify(fromViewController)
        @strongify(toViewController)
        strong_fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        strong_toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        @strongify(fromViewController)
        strong_fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}
#pragma mark - 切换动画的委托方法，主要是给 transitioningDelegate 使用
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self;
}
#pragma mark - navigationController的委托方法，主要是给self.navigationController.delegate使用
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    return self;
}
@end
