//
//  NSDictionary+CGCategory.h
//  base
//
//  Created by wsg on 15/6/18.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(CGCategory)
/*!
 @author wangshuguan, 15-07-03 18:07:45
 
 @brief  重新部署key，由一组新的key替换原来的老key
 
 @param mappedDic 重组的规则字典{targetKey,sourceKey}，目标可能有多个，但是源可能只有一个，所以不能写反
 
 @return 重组之后的字典
 */
-(NSDictionary *)mapDictionaryWithDic:(NSDictionary *)mappedDic;
@end
