//
//  AppDelegate.m
//  base
//
//  Created by wsg on 15/6/5.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "CGDelegate.h"
#import <Bugly/CrashReporter.h>
#import <Appirater.h>
#import "ShareHandle.h"
#import "UserProtectViewController.h"
#import "UserLoginViewController.h"

#ifdef BuglyAppId
NSString *const kBuglyAppId = BuglyAppId;
#endif
#ifdef AppStoreAppId
NSString *const kAppStoreAppId = AppStoreAppId;
#endif

@implementation CGDelegate
#pragma mark - System Hook
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self setupSpecialSdks];
    [self setViewControllerSettings];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationLaunchOptionsSourceApplicationKey object:nil queue:nil usingBlock:^(NSNotification *note) {
        DDLogInfo(@"ApplicationLaunchSourceApplication:%@",note);
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationLaunchOptionsRemoteNotificationKey object:nil queue:nil usingBlock:^(NSNotification *note) {
        DDLogInfo(@"ApplicationRemoteNotification:%@",note);
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kCGNotificationUserStatusChanged object:nil queue:nil usingBlock:^(NSNotification *note) {
        DDLogInfo(@"UserStatusChanged:%@",note);
        if (![[ShareHandle shareHandle]me]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UserLoginViewController *userLoginController = [[UserLoginViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:userLoginController];
                [[[application keyWindow] rootViewController] presentViewController:nav animated:NO completion:nil];
            });
        }
    }];
    
    return YES;
}

#pragma mark - ViewController的设定
/*!
 @brief  控制器通用功能
 */
-(void)setViewControllerSettings{
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
//        UIViewController *vc = aspectInfo.instance;
    } error:nil];
}
#pragma mark - 设置特别的sdk，包括crash日志工具和提醒评价工具
-(void)setupSpecialSdks{
    [ShareHandle shareHandle].appStartDate = [NSDate date];
#ifdef BuglyAppId
    [[CrashReporter sharedInstance] setUserId:@"100"];
    [[CrashReporter sharedInstance] installWithAppId:kBuglyAppId];
#endif
#ifdef AppStoreAppId
    [Appirater setAppId:kAppStoreAppId];
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
#endif
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        DDLogInfo(@"ApplicationDidFinishLaunching:%@",note);
    }];
    [self setupDataBase];
}
#pragma mark - 设置本地数据库
-(void)setupDataBase{
    NSString *sqliteFileName = [NSString stringWithFormat:@"%@%@.sqlite",PROJECT_NAME,PROJECT_VERSION];
    if (![[NSFileManager defaultManager] isReadableFileAtPath:[NSPersistentStore MR_urlForStoreName:sqliteFileName].path]) {
        //
    }
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:sqliteFileName];
}
@end
