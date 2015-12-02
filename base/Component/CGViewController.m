//
//  CGViewController.m
//  base
//
//  Created by wsg on 15/8/16.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "CGViewController.h"
#import "UserProtectViewController.h"
#import "UserLoginViewController.h"
#import "CGAnimator.h"
#define ROTATION_ANGLE 10
#define PERSPECTIVE 0.1
@interface CGViewController (){
    MKNetworkHost *_networkEngine;
    NSMutableArray *_networkOperationArray;
    UIView *userNotLoginView;
    CGAnimator *animator;
}

@end

@implementation CGViewController
@synthesize cachedFromController,cachedTargetController,cachedLastTaskIndex,cachedMehod;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    userNotLoginView = [[UIView alloc]init];
    userNotLoginView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:userNotLoginView];
    @weakify_self
    [userNotLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify_self
        make.centerY.equalTo(self.view).offset = -(self.view.bounds.size.height)/2.0f-100;
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(self.view).offset = 0;
    }];
    animator = [CGAnimator new];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak CGViewController *weak_self = self;
    [ShareHandle shareHandle].currentController = weak_self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)allTask{
    return _networkOperationArray;
}
-(void)cancelAllTask{
    for (MKNetworkRequest *op in _networkOperationArray) {
        [op cancel];
        [_networkOperationArray removeObject:op];
    }
}
-(MKNetworkRequest *)addTaskWithUrl:(NSString *)url para:(NSDictionary *)para method:(NSString *)method{
    MKNetworkRequest *op = [[MKNetworkRequest alloc]initWithURLString:url params:para bodyData:nil httpMethod:method];
    __weak MKNetworkRequest *weakOp = op;
    [_networkOperationArray addObject:weakOp];
    [weakOp addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        [_networkOperationArray removeObject:completedRequest];
    }];
    [_networkEngine startRequest:op];
    return op;
}
-(void)transformViewControllerWithMethod:(ITransformMethod)method fromController:(UIViewController *)fromController targetController:(UIViewController *)targetController{
    if ([targetController isKindOfClass:[UserProtectViewController class]]&&![[ShareHandle shareHandle] me]) {
        DDLogInfo(@"页面受保护，跳转切换为登陆视图...");
        self.cachedTargetController = targetController;
        self.cachedFromController = fromController;
        self.cachedMehod = method;
        @weakify_self
        @weakify(userNotLoginView);
        [UIView animateWithDuration:.3f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            @strongify(userNotLoginView);
            [strong_userNotLoginView mas_updateConstraints:^(MASConstraintMaker *make) {
                @strongify_self
                make.centerY.equalTo(self.view).offset = 0;
            }];
            [strong_userNotLoginView layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        /*
        //无提示界面，直接跳转登陆框的解决方案
         
        UserLoginViewController *userLoginController = [[UserLoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:userLoginController];
        [nav aspect_hookSelector:@selector(dismissViewControllerAnimated:completion:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
            CGLog(@"登陆结束，判断一下要不要进行跳转");
            if ([[ShareHandle shareHandle] me]) {
                if (method == ITransformMethodPush) {
                    [(UINavigationController *)fromController pushViewController:targetController animated:YES];
                }else if (method == ITransformMethodPresent) {
                    [fromController presentViewController:targetController animated:YES completion:nil];
                }else if (method == ITransformMethodTab) {
                    [(UITabBarController *)fromController setSelectedViewController:targetController];
                }
            }else{
                CGLog(@"登陆失败，不进行任何处理");
            }
        }error:nil];
        [fromController presentViewController:nav animated:NO completion:nil];
         */
    }else{
        animator.fromViewController = self;
        if (method == ITransformMethodPush) {
            self.navigationController.delegate = animator;
            [(UINavigationController *)fromController pushViewController:targetController animated:YES];
        }else if (method == ITransformMethodPresent) {
            targetController.transitioningDelegate = animator;
            [fromController presentViewController:targetController animated:YES completion:nil];
        }else if (method == ITransformMethodTab) {
            [(UITabBarController *)fromController setSelectedViewController:targetController];
        }
    }
}


//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
//    return animator;
//}
//
//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
//    return animator;
//}
@end
