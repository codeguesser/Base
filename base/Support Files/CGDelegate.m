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
#import <XGPush.h>
#import <XGSetting.h>
#import "ShareHandle.h"
//#import "UserProtectViewController.h"
//#import "UserLoginViewController.h"

#ifdef BuglyAppId
NSString *const kBuglyAppId = BuglyAppId;
#endif
#ifdef AppStoreAppId
NSString *const kAppStoreAppId = AppStoreAppId;
#endif

#ifdef XingeAppId
#ifdef XingeAppKey
NSString *const kXingeAppKey = XingeAppKey;
long long const kXingeAppId = XingeAppId;
#endif
#endif
#ifdef WeixinAppId
#import "WXApiManager.h"
NSString *const kWeixinAppId = WeixinAppId;
#endif

#ifdef AlipayPartner
#ifdef AlipaySeller
#ifdef AlipayPrivateKey
#import <AlipaySDK/AlipaySDK.h>
#endif
#endif
#endif
@implementation CGDelegate
#pragma mark - System Hook
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self setupSpecialSdksWithOptions:(NSDictionary *)launchOptions];
    [self setViewControllerSettings];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kCGNotificationUserStatusChanged object:nil queue:nil usingBlock:^(NSNotification *note) {
        DDLogInfo(@"UserStatusChanged:%@",note);
//        if (![[ShareHandle shareHandle]me]) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                UserLoginViewController *userLoginController = [[UserLoginViewController alloc] init];
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:userLoginController];
//                [[[application keyWindow] rootViewController] presentViewController:nav animated:NO completion:nil];
//            });
//        }
    }];
    
    return YES;
}

#pragma mark - ViewController的设定
/*!
 @brief  控制器通用功能
 */
-(void)setViewControllerSettings{
    /*
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
//        UIViewController *vc = aspectInfo.instance;
    } error:nil];
     */
}
#pragma mark - 设置特别的sdk，包括crash日志工具和提醒评价工具
-(void)setupSpecialSdksWithOptions:(NSDictionary *)launchOptions{
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
#ifdef XingeAppId
#ifdef XingeAppKey
    [self setupXingeSdkWithOptions:launchOptions];
#endif
#endif
#ifdef WeixinAppId
    [WXApi registerApp:kWeixinAppId withDescription:@"demo 2.0"];
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
#pragma mark - 设置信鸽功能
#ifdef XingeAppId
#ifdef XingeAppKey
-(void)setupXingeSdkWithOptions:(NSDictionary *)launchOptions{
    [XGPush startApp:kXingeAppId appKey:kXingeAppKey];
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
            }
            else{
                //Types
                UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
                //Actions
                UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
                acceptAction.identifier = @"ACCEPT_IDENTIFIER";
                acceptAction.title = @"Accept";
                acceptAction.activationMode = UIUserNotificationActivationModeForeground;
                acceptAction.destructive = NO;
                acceptAction.authenticationRequired = NO;
                //Categories
                UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
                inviteCategory.identifier = @"INVITE_CATEGORY";
                [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
                [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
                
                NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
                UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
                [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    void (^errorBlock)(void) = ^(void){
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
}
#endif
#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [XGPush setAccount:@"testAccount"];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush Demo]register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush Demo]register errorBlock");
    };
    
    //注册设备
    XGSetting *setting = (XGSetting *)[XGSetting getInstance];
    [setting setChannel:@"appstore"];
    [setting setGameServer:@"巨神峰"];
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    DDLogInfo(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
}

#ifdef WeixinAppId
-(BOOL)weixinPayCallBackWithUrl:(NSURL *)url{
    if([url.host isEqualToString:@"pay"]){
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return NO;
}
#endif
#ifdef AlipayPartner
#ifdef AlipaySeller
#ifdef AlipayPrivateKey
-(BOOL)alipayCallBackWithUrl:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      NSLog(@"result = %@",resultDic);
                                                      NSString *resultStr = resultDic[@"result"];
                                                      NSLog(@"reslut = %@",resultStr);
                                                      if (resultDic&&[resultDic isKindOfClass:[NSDictionary class]]&&resultDic[@"resultStatus"]&&[resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                                                          [[NSNotificationCenter defaultCenter]postNotificationName:CGAlipaySuccessNotification object:nil];
                                                      }else{
                                                          
                                                          [[NSNotificationCenter defaultCenter]postNotificationName:CGAlipayFalseNotification object:nil];
                                                      }
                                                  }];
        return YES;
    }else if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultStr = resultDic[@"result"];
            NSLog(@"reslut = %@",resultStr);
            if (resultDic&&[resultDic isKindOfClass:[NSDictionary class]]&&resultDic[@"resultStatus"]&&[resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:CGAlipaySuccessNotification object:nil];
            }else{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:CGAlipayFalseNotification object:nil];
            }
        }];
        return YES;
    }
    return NO;
}
#endif
#endif
#endif

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
#ifdef WeixinAppId
    if ([self weixinPayCallBackWithUrl:url]) {
        return [self weixinPayCallBackWithUrl:url];
    };
#endif
    
#ifdef AlipayPartner
#ifdef AlipaySeller
#ifdef AlipayPrivateKey
    if([self alipayCallBackWithUrl:url]){
        return [self alipayCallBackWithUrl:url];
    }
#endif
#endif
#endif
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
#ifdef WeixinAppId
    if ([self weixinPayCallBackWithUrl:url]) {
        return [self weixinPayCallBackWithUrl:url];
    };
#endif
    
#ifdef AlipayPartner
#ifdef AlipaySeller
#ifdef AlipayPrivateKey
    if([self alipayCallBackWithUrl:url]){
        return [self alipayCallBackWithUrl:url];
    }
#endif
#endif
#endif
    return YES;
}
@end
