//
//  CGContactService.h
//  base
//
//  用来获取本地通讯录
//
//  Created by wsg on 15/11/19.
//  Copyright © 2015年 wsg. All rights reserved.
//
//  如何使用    How to use it...
//  tip:本类的数据都是动态获取的，所以如果想使用它，最好先初始化，等待数据处理完毕在调用，提前初始化
//
//  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sthComming:) name:@"kNotificationContactUpdated" object:nil];
//  service = [CGContactService service];
//  arr = [service contactsForExport];
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
 */
@property(nonatomic,strong)NSArray *contacts;
#pragma mark - unReused , just for service
/*!
 @brief  需要导出时数组，组装好的内容
 
 @return 默认返回空数组
 */
-(NSArray *)contactsForExport;
/*!
 @brief 写入数据到本地通讯录
 
 @return 返回值，成功即是yes
 */
-(BOOL)saveWithContacts:(NSArray *)contacts;
/*!
 @brief 获取数据
 */
-(void)requestData;
@end
