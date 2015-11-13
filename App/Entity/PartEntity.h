//
//  PartEntity.h
//  base
//
//  Created by wsg on 15/9/8.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "Entity.h"
/*!
 @author wangshuguan, 15-07-22 14:07:32
 
 @brief  章节：实体类基类
 */
@interface PartEntity : Entity
@property (nonatomic, strong) NSNumber * pid;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSMutableString * content;
@end
