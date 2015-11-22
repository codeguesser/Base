//
//  AppDelegate.m
//  base
//
//  [NSDecimalNumber decimalNumberWithString:numberString]
//
//  Created by wsg on 15/6/5.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "AppDelegate.h"
//#import "TestAnimate1ViewController.h"
//#import "PartEntity.h"
//#import "TableViewController.h"
//#import "TestSocketViewController.h"
//#import "LoadingViewController.h"
//#import "MasMakeViewController.h"
//#import "TestLayoutViewController.h"
#import "TestViewController.h"
#import "NSString+Pinyin.h"
//#import "TestContactManagerViewController.h"
#import "CGAreaService.h"
//#import "TestPayViewController.h"
#import "CGContactService.h"
@interface AppDelegate ()<UIAlertViewDelegate>{
    CGContactService *service;
}
#warning 什么东西来的
@property NSString<UIDataSourceModelAssociation> *xx;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    window.backgroundColor = [UIColor grayColor];
    self.window = window;
    [window makeKeyAndVisible];
    [[UIButton appearance]setTintColor:[UIColor greenColor]];
    [[UIAlertView appearance]setTintColor:[UIColor greenColor]];
    [[UIBarButtonItem appearance]setTintColor:[UIColor greenColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor greenColor]];
//    PartEntity *part = [PartEntity getObjectFromDic:@{@"pid":@(534.94)}];
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
//    formatter.numberStyle = NSNumberFormatterNoStyle;
//    formatter.maximumFractionDigits = 20;
//    NSString *str = [formatter stringFromNumber:@(253412312312311123.94)];
//    NSLog(@"%@",[@"--" pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]]);
    [self tableViewEmptyPageDemo];
//    NSInteger
    //    CGAreaService *service = [CGAreaService service];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sthComming:) name:@"kNotificationContactUpdated" object:nil];
    service = [CGContactService service];
    return YES;
}
-(void)sthComming:(NSNotification *)no{
    NSLog(@"%@",[(CGContactService*)no.object contactsForExport]);
}

-(void)tableViewEmptyPageDemo{
    TestViewController *vc = [[TestViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"电话本" image:[[UIButton buttonWithType:UIButtonTypeDetailDisclosure] currentImage] tag:0];
    UITabBarController *tbc = [[UITabBarController alloc]init];
    tbc.viewControllers = @[nav];
    
    self.window.rootViewController = tbc;
}
/*
-(void)setupHTTPNetworkDemo{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://192.168.2.36:9100/dongbenservice.asmx/book_print_base_info" parameters:@{@"token":@"string",@"book_id":@"123"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)setupHTTPSNetworkDemo{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:NO];
    [securityPolicy setPinnedCertificates:@[certData]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = securityPolicy;
    [manager GET:@"https://codeguesser.cn" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
 */

/*!
 @author wangshuguan, 15-08-05 13:08:28
 
 @brief  证书生成说明
 http://www.codeguesser.cn/openssljian-li-shuang-xiang-ren-zheng-de-zheng-shu/
 */
-(void)setupHTTPSNetworkDemo{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"www.codeguesser.cn"
                                     customHeaderFields:headerFields];
    MKNetworkOperation *op = [engine operationWithPath:@"/"
                                              params:nil
                                          httpMethod:@"GET" ssl:YES];
    op.clientCertificate = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"client.p12"];
    op.clientCertificatePassword = @"1234";
    op.shouldContinueWithInvalidCertificate = YES;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        DDLogInfo(@"%@",completedOperation.responseJSON);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DDLogInfo(@"%@",error);
    }];
    [engine enqueueOperation:op];
}
 

/*!
 @author wangshuguan, 15-08-05 17:08:51
 
 @brief  一个普通的网络连接的demo
 */
-(void)setupNetworkDemo{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"dlsw.baidu.com"
                                                     customHeaderFields:headerFields];
    
    
    
    MKNetworkOperation *op = [engine operationWithPath:@"sw-search-sp/soft/3a/12350/QQ_V7.5.15456.0_setup.1438225942.exe"
                                                params:nil
                                            httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        DDLogInfo(@"%@",completedOperation.responseData);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DDLogInfo(@"%@",error);
    }];
    [engine enqueueOperation:op];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [op cancel];
    });
}
-(void)setupNetworkDemo2{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"192.168.2.36:9100"
                                                     customHeaderFields:headerFields];
    
    MKNetworkOperation *op = [engine operationWithPath:@"/dongbenservice.asmx/book_print_base_info"
                                                params:@{@"token":@"string",@"book_id":@"123"}
                                            httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        DDLogInfo(@"%@",completedOperation.responseJSON);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        DDLogInfo(@"%@",error);
    }];
    [engine enqueueOperation:op];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [op cancel];
    });
}
@end
