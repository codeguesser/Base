//
//  CGAreaService.h
//  base
//
//  Created by wsg on 15/11/18.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
/*!
 @brief  行政区
 */
@interface CGAreaData:Entity
/*!
 @brief  行政区的名字
 */
@property(nonatomic,strong)NSString *name;
/*!
 @brief  行政区的下辖
 */
@property(nonatomic,strong)NSArray *data;
@end
/*!
 @brief  中国的行政区服务
 */
@interface CGAreaService : NSObject
/*!
 @brief  全部的省份
 */
@property(nonatomic,strong)NSArray *allProvinces;
/*!
 @brief  通过名字获取省级行政区
 
 @param province 行政区的名字
 
 @return 行政区
 */
- (CGAreaData *)provinceWithName:(NSString *)province;
/*!
 @brief  初始化服务
 
 @return 服务的对象，仅用此做服务
 */
+ (id)service;
@end
