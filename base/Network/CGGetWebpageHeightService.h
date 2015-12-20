//
//  CGWebViewHeightService.h
//  base
//
//  此代码用于获取网页在某个size的高度
//  Created by wsg on 15/12/19.
//  Copyright © 2015年 wsg. All rights reserved.
//
//  ****** how to use it ********
//  CGGetWebpageHeightService *whs = [[CGGetWebpageHeightService alloc]init];
//  whs.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
//  whs.htmls = @[ @"<html></html>" ];
//  whs.finishLoading = ^(NSArray<NSDictionary<NSString *,NSNumber *> *> *arr) {
//      NSLog(@"%@",arr);
//  };
//  *****************************
//


#import <Foundation/Foundation.h>

@interface CGGetWebpageHeightService : NSObject
/*!
 @brief  网页的html代码
 */
@property(nonatomic,strong)NSArray<NSString*> *htmls;
/*!
 @brief  加工完毕的返回数据
 @return 返回按顺序来加工好的高度数据
 */
@property(nonatomic,strong)void(^finishLoading)(NSArray<NSDictionary<NSString *,NSNumber *> *> *);
/*!
 @brief  网页的webpage的原始大小
 */
@property(nonatomic,assign)CGSize size;
@end