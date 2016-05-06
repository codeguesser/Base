//
//  Config.h
//  base
//
//  Created by wsg on 15/6/5.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#ifndef base_Config_h
#define base_Config_h
#import "Micro.h"
#import "ShareHandle.h"
#pragma mark - notification const
UIKIT_EXTERN NSString *const kCGNotificationUserStatusChanged;
UIKIT_EXTERN NSString *const CGTestNotification;
/*!
 @brief  支付宝的支付成功消息
 */
UIKIT_EXTERN NSString *const CGAlipaySuccessNotification;
/*!
 @brief  支付宝的支付失败消息
 */
UIKIT_EXTERN NSString *const CGAlipayFalseNotification;

#pragma mark - webservice const
/*!
 @brief  代码字段，服务常量
 */
UIKIT_EXTERN NSString *const CGApiCodeKey;
/*!
 @brief  状态字段，服务常量
 */
UIKIT_EXTERN NSString *const CGApiStatusKey;
/*!
 @brief  内容字段，服务常量
 */
UIKIT_EXTERN NSString *const CGApiContentKey;
/*!
 @brief  消息字段，服务常量
 */
UIKIT_EXTERN NSString *const CGApiMessageKey;
/*!
 @brief  其他信息字段，也可以包括所有内容，服务常量
 */
UIKIT_EXTERN NSString *const CGApiOtherKey;
/*!
 @brief  标识正确的字符串
 */
UIKIT_EXTERN NSString *const kCGTrueTag;
/*!
 @brief  标识错误的字符串
 */
UIKIT_EXTERN NSString *const kCGFalseTag;

#pragma mark -
#if DEBUG == 1
#define U_CHANNEL_TAG @"DEVELOP"
//#define U_NETWORK_TRACERT YES
#else
#define U_CHANNEL_TAG @"RELEASE"
#endif
//#define U_BAIDU_KEY @"ImZ1b3Kyc0c9QsuGold6RED6"
#ifdef U_BAIDU_KEY
UIKIT_EXTERN NSString *const CGBaiduGetLocationAttributeNotification;
#endif
#define BuglyAppId @"900005994"//Bugly App ID 上传crash信息用的，注释掉即是不上传
#define AppStoreAppId @"1231231231"//AppStore里的应用程序ID，提醒用户评分使用，注释即是不提示
#define XingeAppId 2200165541//信鸽推送需要的id，下面的key不写都不行，注释任意一行就表示不支持信鸽
#define XingeAppKey @"I52MN8IKH83X"//信鸽推送需要的key，上面的id不写都不行，注释任意一行就表示不支持信鸽
#define WeixinAppId @"wxb4ba3c02aa476ea1"//微信的appid，没有微信的appid，代表不支持微信支付
#define AlipayPartner @"2088611280436463"//支付宝的partner，没有它代表不支持支付宝支付
#define AlipaySeller @"hnrsaif6688@126.com"//支付宝的seller，和上面的功能相同
#define AlipayPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAN76db7hTONTY6Abl3PIPO+a6mTPHJvwhW4LwUYZnk0qds8Ru2cfygxjQd9EnkPeDXZ8DNk51AhLbxZkz4bzeD8CLBmyVZIgdwXhBJ7TgKc7twH0FHIjyOKntJk+fYP9hlFQ0R2TfLD+BAkHBJieDJ5VQFL9v5uNgdf9sH3SpT2rAgMBAAECgYAgKKdKvFvGfYRk1xXk0QBY3lLn7ycFJo9X68IYRiGap4EzJC+PE/qkBry9YrwgtanjaMjBm6GFALwo0qlLoVm6F788uN8Zr4Q0GpMSeefm/jDpWpZakvhMAB46TBx5HV58cEgiAQvDHSJTzS39e7g41W/asgdkx5PIulMiwWP1gQJBAO/6rhkMMkzs4dQC3TP3eWP2+lSHdqze9zreCQoBV9Kns9odNjT8lGs37ov6NWHHvcJkFWTndVKdqLQ48yzL6zsCQQDt3TrYIHZKHgfqk/uOkiWNbwGR6H7XXTfKmPZpYwFTEsjU8LopJp78mnW2r4d7Yhz7D84s/hl5Yu46TbG+QnBRAkEAwxNJ1r6dXP7qjEdPvWCcYvBviascg2Y0HrxDKMjytSDyCInaeLQhig7LcSoRnsyZqp1k7sNgEaprayUoN/AD5QJAPmIbILvCykV+BgOxof6qYqGOY9n6CjmkfDoJxjH1EviGO3K3IDvEzrMj1DnM6osc1quagypRPAi6OghOaXu7QQJAIeiF8QJ8ehqnTY2M3kkX0gOrd4rlmdokJWZgzyqp8IrbU0CvukkKzzMJSrfIFeDek7k2myB68fjtJjQRHH6I4Q=="//支付宝的私有key
#endif
