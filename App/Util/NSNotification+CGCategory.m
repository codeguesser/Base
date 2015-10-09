//
//  NSNotification+CGCategory.m
//  base
//
//  Created by wsg on 15/7/1.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "NSNotification+CGCategory.h"
#import <libkern/OSAtomic.h>
#import <objc/runtime.h>
#import <objc/message.h>
NSString *const CGApiCodeKey = @"CGApiCodeKey";
NSString *const CGApiStatusKey = @"CGApiStatusKey";
NSString *const CGApiContentKey = @"CGApiContentKey";
NSString *const CGApiMessageKey = @"CGApiMessageKey";
NSString *const CGApiOtherKey = @"CGApiOtherKey";
NSString *const kCGTrueTag = @"YES";
NSString *const kCGFalseTag = @"NO";

NSString *const kCGNotificationUserStatusChanged = @"kCGNotificationUserStatusChanged";
NSString *const CGTestNotification = @"CGTestNotification";
@implementation NSNotificationCenter(CGCategory)

@end
