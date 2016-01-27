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
#import "WebViewController.h"
#import "NSString+Pinyin.h"
//#import "TestContactManagerViewController.h"
#import "CGAreaService.h"
#import "CGLocationService.h"
#import "WebViewController.h"
#import "CGContactService.h"
#import "TestViewController.h"
#import "CGGetWebpageHeightService.h"
#import "TestImageMemoryViewController.h"
#import "CGNetwork.h"
#import "CGGetProvidentFundService.h"
@interface AppDelegate ()<UIAlertViewDelegate>{
    CGContactService *service;
    CGLocationService *service2;
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
    [self tableViewEmptyPageDemo];
    return YES;
}

-(void)tableViewEmptyPageDemo{
    TestViewController *vc = [[TestViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"电话本" image:[[UIButton buttonWithType:UIButtonTypeDetailDisclosure] currentImage] tag:0];
    UITabBarController *tbc = [[UITabBarController alloc]init];
    tbc.viewControllers = @[nav];
    
    self.window.rootViewController = tbc;
}
-(void)sthComming:(NSNotification *)no{
    NSLog(@"%@",[(CGContactService*)no.object contactsForExport]);
}
//测试获取定位服务
-(void)testGetLocation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        service2 = [[CGLocationService alloc]initWithoutGetLocation];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocation:) name:CGBaiduGetLocationAttributeNotification object:nil];
        //        service2.warrantAction =^(CGLocationError error){
        //
        //        };
        [service2 startLocation];
    });

}
//测试获取中国行政区
-(void)testGetChinaArea{
    [CGAreaService service];
}
//调用本地联系人
-(void)testContact{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sthComming:) name:@"kNotificationContactUpdated" object:nil];
    service = [CGContactService service];
}
//获取html的高度
-(void)testWebpageHeight{
    CGGetWebpageHeightService *whs = [[CGGetWebpageHeightService alloc]init];
    whs.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    whs.htmls = @[
                  [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil]
                  ];
    whs.finishLoading = ^(NSArray<WebHeightOperation *> *arr) {
        NSLog(@"%@",arr);
    };
}
//获取公积金内容
-(void)testProvidentFund{
    CGGetProvidentFundService *service3 = [CGGetProvidentFundService service];
    service3.name = @"王书倌";
    service3.cardId = @"410311199002021538";
    [service3 requestResultWithYear:@"2015" completion:^(NSArray *historyList, NSArray *keys,NSDictionary *otherInfo) {
        int j=0;
        for (NSDictionary *dic in historyList) {
            NSLog(@"%@:%d",keys[0],j);
            for (int i=1; i<dic.count; i++) {
                NSLog(@"%@:%@",keys[i],dic[[NSString stringWithFormat:@"%d",i]]);
            }
            j++;
        }
        NSLog(@"%@",otherInfo);
    }];
}

//测试数字number的转换
-(void)testNumber{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    formatter.maximumFractionDigits = 20;
    [formatter stringFromNumber:@(253412312312311123.94)];
}
//entity的测试，以及拼音的使用
-(void)testPinyin{
//    PartEntity *part = [PartEntity getObjectFromDic:@{@"pid":@(534.94)}];

    NSLog(@"%@",[@"--" pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]]);
}
//线程分析
-(void)testThread{
    NSLog(@"1%@",[[NSThread currentThread] isMainThread]?@"主线程":@"分线程");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@",[[NSThread currentThread] isMainThread]?@"主线程":@"分线程");
        });
    });
    NSLog(@"4%@",[[NSThread currentThread] isMainThread]?@"主线程":@"分线程");
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
    MKNetworkHost *engine = [[MKNetworkHost alloc] initWithHostName:@"www.codeguesser.cn"];
    MKNetworkRequest *op = [engine requestWithPath:@"/" params:nil httpMethod:@"GET" body:nil ssl:YES];
    op.clientCertificate = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ca.cer"];
    op.clientCertificatePassword = @"";
    [op addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        DDLogInfo(@"%@",completedRequest.responseAsJSON);
    }];
    [engine startRequest:op];
}
 

/*!
 @author wangshuguan, 15-08-05 17:08:51
 
 @brief  一个普通的网络连接的demo
 */
-(void)setupNetworkDemo{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    MKNetworkHost *engine = [[MKNetworkHost alloc] initWithHostName:@"dlsw.baidu.com"];
    
    
    
    MKNetworkRequest *op = [engine requestWithPath:@"sw-search-sp/soft/3a/12350/QQ_V7.5.15456.0_setup.1438225942.exe" params:nil httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        DDLogInfo(@"%@",completedRequest.responseAsJSON);
    }];
    [engine startRequest:op];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [op cancel];
    });
}
-(void)setupNetworkDemo2{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    MKNetworkHost *engine = [[MKNetworkHost alloc] initWithHostName:@"192.168.2.36:9100"];
    
    MKNetworkRequest *op = [engine requestWithPath:@"/dongbenservice.asmx/book_print_base_info" params:@{@"token":@"string",@"book_id":@"123"} httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        DDLogInfo(@"%@",completedRequest.responseAsJSON);
    }];
    [engine startRequest:op];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [op cancel];
    });
}
@end
