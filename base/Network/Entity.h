//
//  Entity.h
//  base
//
//  Created by wsg on 15/7/22.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IEntity
/*!
 @author wangshuguan, 15-07-22 11:07:45
 
 @brief  从模型转换为字典
 
 @return 模型生成的字典
 */
-(NSDictionary *)toDictionary;
#pragma mark - must to be rewrited
/*!
 @author wangshuguan, 15-07-22 11:07:21
 
 @brief  实体类属性列表
 
 @return 获取的属性列表
 */
+(NSArray *)propertyKeys;
/*!
 @author wangshuguan, 15-07-22 11:07:11
 
 @brief  从字典转换成模型
 
 @param dic 字典
 
 @return 转换成功的模型
 */
+getObjectFromDic:(NSDictionary *)dic;
/*!
 @brief  从数据集合转换成拥有模型的数组
 
 @param dic 数据集合，可以是字典也可以是数组
 
 @return 处理之后的数据，默认为@[]
 */
+ (NSArray *)getObjectsFromDic:(id)dic;
@end
/*!
 @author wangshuguan, 15-07-22 14:07:32
 
 @brief  实体类基类
 */
@interface Entity : NSObject<IEntity>
/*!
 @author wangshuguan, 15-07-22 14:07:42
 
 @brief  非空值转换
 
 @param data 数据源
 
 @return 格式化之后的数据
 */
-(id)dataFromValue:(id)data;
@end
