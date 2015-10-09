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
UIKIT_EXTERN NSString *const CGTestNotification;

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
#else
#define U_CHANNEL_TAG @"RELEASE"
#endif

//#define BuglyAppId @"900005994"//Bugly App ID 上传crash信息用的，注释掉即是不上传
//#define AppStoreAppId @"1231231231"//AppStore里的应用程序ID，提醒用户评分使用，注释即是不提示
#endif
