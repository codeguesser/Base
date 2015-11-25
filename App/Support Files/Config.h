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
#else
#define U_CHANNEL_TAG @"RELEASE"
#endif

//#define BuglyAppId @"900005994"//Bugly App ID 上传crash信息用的，注释掉即是不上传
//#define AppStoreAppId @"1231231231"//AppStore里的应用程序ID，提醒用户评分使用，注释即是不提示
#define XingeAppId 2200165541//信鸽推送需要的id，下面的key不写都不行，注释任意一行就表示不支持信鸽
#define XingeAppKey @"I52MN8IKH83X"//信鸽推送需要的key，上面的id不写都不行，注释任意一行就表示不支持信鸽
#define WeixinAppId @"wxb4ba3c02aa476ea1"//微信的appid，没有微信的appid，代表不支持微信支付
#define AlipayPartner @"2088611280436463"//支付宝的partner，没有它代表不支持支付宝支付
#define AlipaySeller @"hnrsaif6688@126.com"//支付宝的seller，和上面的功能相同
#define AlipayPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAL67LG+ca+qD/IlRpgv/den/2GyzEede86Wj22PvUxxF+PeEKGK1Dz4HDbIu2Q20PL4H/ufgrSnu0oa/MZvtWBjTrqdYy7b7WLBxiS4mAuK8Q4eFZqjrDZrYD/x9Flqw34tg1w1tH7PtEljWyYD78gxRzmWoL526cLfiHHyNDSDHAgMBAAECgYBoXlgEgx3yaGMKaWlpa1MExwGRCbQkXasJ2s40s0NRV2DTYLgQu28pzAZMmKIhg50xh4KPNDzNk2gUYA8vegMYMLmOo2Xi5MxkmPrKU01s5vNCdOabkNbuLAoFj3DZs0tPjZ13q/ElZzSlglw0AhOwOkXYiuJYKlN6I5vuiqvBEQJBAOcko3lLA5kvi81jzr6eynpNbDgQF/4A5Zmb5NNdMicZdnNrQFwbUfZXKcmAxKI9kqzoUwyWR6f8OYyVUijuyqMCQQDTPf6yrwNYACiHbNVx7d2pkWphiE2+Gn4HL59/avDqBZC3XHyptAljF8dsL2CTgA/zv/KJXGiy35iJ8Cvmb7eNAkA4sCKrl7stMZz+5XCKDZWpAx38be4EbKHi13n6YIvxTOxhCDfDnyut19i2w671/1XetCfSGXU/fLt8gA6jXVUzAkEAlQEh68Bvx181N3GZjeePd9DPDUUsMXBWfZMmGqbAkRKj5fMjLEGGbZOUY8d3hBPNLM60shew8put6X60OLOM8QJAG3hIbDTtJ3pUHy4gBZ1pMRu0vjh7fqune/N1kat9qjEhx5DN563+sBttuz06EPWR/MQBddpOJYfwk/YEIoepsw=="//支付宝的私有key
#endif
