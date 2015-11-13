//
//  Util.h
//  base
//
//  Created by wsg on 15/6/5.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#ifndef base_Util_h
#define base_Util_h
#import "Util+Classes.h"
#import "NSString+Pinyin.h"
#import "NSDate+Category.h"
#import "NSDateFormatter+Category.h"
#import "NSDictionary+CGCategory.h"
#import "NSNotification+CGCategory.h"
#import "CocoaUI+CGCategory.h"
#define PROJECT_NAME [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleName"]
#define PROJECT_VERSION [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#define PROJECT_URL [[NSBundle mainBundle] infoDictionary][@"CFBundleURLTypes"][0][@"CFBundleURLSchemes"][0]
#define PROJECT_DISPLAY_NAME [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"]
#define PROJECT_CANNEL [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleIdentifier"]
#define DOCUMENT_DIR [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES) objectAtIndex:0]
//#define CGLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
/**
 * 强弱引用转换，用于解决代码块（block）与强引用self之间的循环引用问题
 * 调用方式: `@weakify_self`实现弱引用转换，`@strongify_self`实现强引用转换
 *
 * 示例：
 * @weakify_self
 * [obj block:^{
 * @strongify_self
 * self.property = something;
 * }];
 */
#ifndef    weakify_self
#if __has_feature(objc_arc)
#define weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
#else
#define weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
#endif
#endif
#ifndef    strongify_self
#if __has_feature(objc_arc)
#define strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
#else
#define strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
#endif
#endif
/**
 * 强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 * 调用方式: `@weakify(object)`实现弱引用转换，`@strongify(object)`实现强引用转换
 *
 * 示例：
 * @weakify(object)
 * [obj block:^{
 * @strongify(object)
 * strong_object = something;
 * }];
 */
#ifndef    weakify
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#endif
#ifndef    strongify
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) strong##_##object = block##_##object;
#endif
#endif
#endif
