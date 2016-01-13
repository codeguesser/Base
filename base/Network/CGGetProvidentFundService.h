//
//  CGGetProvidentFundService.h
//  base
//
//  Created by wsg on 16/1/11.
//  Copyright © 2016年 wsg. All rights reserved.
//
//  *****获取公积金的内容*****
//
//  如何使用 How to use it!!!!!!
//
//  CGGetProvidentFundService *service = [CGGetProvidentFundService service];
//    [service3 requestResultWithYear:@"2015" completion:^(NSArray *historyList, NSArray *keys) {
//        for (NSDictionary *dic in historyList) {
//            for (int i=0; i<dic.count; i++) {
//                NSLog(@"%@:%@",keys[i],dic[[NSString stringWithFormat:@"%d",i]]);
//            }
//        }
//    }];
//
//
#import <Foundation/Foundation.h>

@interface CGGetProvidentFundService : NSObject

/*!
 @brief  初始化服务
 
 @return 服务的对象，仅用此做服务
 */
+ (id)service;
/*!
 @brief 根据年份获取数据列表
 
 @param year       年份
 @param completion 数据的详情，数据集和key的列表
 */
-(void)requestResultWithYear:(NSString *)year completion:(void(^)(NSArray *historyList,NSArray *keys))completion;
@end
