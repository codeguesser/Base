//
//  LoadingViewController.m
//  base
//
//  Created by wsg on 15/8/11.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "LoadingViewController.h"
#import "WebViewController.h"
@implementation LoadingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(gotoAnotherController)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentController:)];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelText = @"正在加载中。。。";
    [self.view addSubview:hud];
    
    UIButton *delButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    delButton.transform = CGAffineTransformMakeRotation(M_PI_4);
    delButton.hidden = YES;
    [hud addSubview:delButton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        delButton.hidden = NO;
        CGSize size = hud.size;
        delButton.center = CGPointMake((self.view.frame.size.width-size.width)/2.0f, (self.view.frame.size.height-size.height)/2.0f);
        [delButton addTarget:hud action:@selector(cleanUp) forControlEvents:UIControlEventTouchUpInside];
    });
    
//    NSOperationQueue *oq = [[NSOperationQueue alloc]init];
//    [oq addOperationWithBlock:^{
//        sleep(10);
//    }];
//    
    
    
//    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
//    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"dlsw.baidu.com"
//                                                     customHeaderFields:headerFields];
//    
//    
//    
//    MKNetworkOperation *op = [engine operationWithPath:@"sw-search-sp/soft/3a/12350/QQ_V7.5.15456.0_setup.1438225942.exe"
//                                                params:nil
//                                            httpMethod:@"GET"];
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        
//        NSLog(@"%@",completedOperation.responseData);
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    [engine enqueueOperation:op];
}
-(void)gotoAnotherController{
    [self transformViewControllerWithMethod:ITransformMethodPush fromController:self.navigationController targetController:[WebViewController new]];
}
- (IBAction)presentController:(id)sender {
    CGViewController *vc = [CGViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    [self transformViewControllerWithMethod:ITransformMethodPresent fromController:self targetController:nav];
}
-(void)dismiss{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
