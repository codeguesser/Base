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
//
//
#import <Foundation/Foundation.h>

NS_ENUM(NSUInteger,IProvidentFundtype){
    IProvidentFundtypeIndex=0,
    IProvidentFundtypeAddTime=1,
    IProvidentFundtypeCategory=2,
    IProvidentFundtypeAddAmount=3,
    IProvidentFundtypeMinAmount=4,
    IProvidentFundtypeBalance=5,
    IProvidentFundtypeMonth=6,
};
const NSString* IProvidentFundtypeNames[7]  = {@"序号",@"交易日期",@"业务种类",@"增加金额",@"减少金额",@"账号余额",@"所属年月"};
@interface CGGetProvidentFundService : NSObject

/*!
 @brief  初始化服务
 
 @return 服务的对象，仅用此做服务
 */
+ (id)service;

@end
