//
//  CGNetwork.h
//  base
//
//  Created by wsg on 15/11/9.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kCGNetworkConnectNotification @"kCGNetworkConnectNotification"
/*!
 @brief  监听整个app的网络连接情况
 */
@interface CGNetworkConnect :NSURLProtocol
/*!
 @brief  检测网络监听类是否起作用
 
 @return 如果registed就返回YES，否则返回NO
 */
+(BOOL)isClassRegisted;
@end
@interface CGNetwork : NSObject

@end
