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

    
    if (self.fromViewController==fromViewController) {
        //push
        [[transitionContext containerView] addSubview:toViewController.view];
        toViewController.view.frame = CGRectMake(fromViewController.view.bounds.size.width, fromViewController.view.frame.origin.y, fromViewController.view.bounds.size.width, fromViewController.view.bounds.size.height);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = CGRectMake(0, fromViewController.view.frame.origin.y, fromViewController.view.bounds.size.width, fromViewController.view.bounds.size.height);
            fromViewController.view.frame = CGRectMake(-fromViewController.view.bounds.size.width, fromViewController.view.frame.origin.y, fromViewController.view.bounds.size.width, fromViewController.view.bounds.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
        }];
    }else{
        //pop
        [[transitionContext containerView] addSubview:toViewController.view];
        [[transitionContext containerView] sendSubviewToBack:toViewController.view];
        toViewController.view.frame = CGRectMake(-fromViewController.view.bounds.size.width, fromViewController.view.frame.origin.y, fromViewController.view.bounds.size.width, fromViewController.view.bounds.size.height);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = CGRectMake(fromViewController.view.bounds.size.width, fromViewController.view.frame.origin.y, fromViewController.view.bounds.size.width, fromViewController.view.bounds.size.height);
            toViewController.view.frame = CGRectMake(0, fromViewController.view.frame.origin.y, fromViewController.view.bounds.size.width, fromViewController.view.bounds.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
        }];
    }
    
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
