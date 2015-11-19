//
//  CGContactService.h
//  base
//  用来获取本地通讯录
//
//  Created by wsg on 15/11/19.
//  Copyright © 2015年 wsg. All rights reserved.
//
//  如何使用    How to use it...
//
//
#import <Foundation/Foundation.h>
@import AddressBook;
@interface CGContactService : NSObject
/*!
 @brief  初始化数据
 
 @return 
 */
+ (id)service;
/*!
 @brief  全部的分组
 */
@property(nonatomic,strong)NSArray *groups;
/*!
 @brief  全部的联系人
 
 @return 全部的联系人，默认是空的
 */
- (NSArray *)allContacts;
@end
