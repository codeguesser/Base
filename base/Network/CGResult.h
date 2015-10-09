//
//  CGResult.h
//  base
//
//  Created by wsg on 15/8/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGResult : NSObject
/**
 *  服务器带来的消息，文本格式
 */
@property(strong,nonatomic)NSString *message;
/**
 *  服务器来的消息状态，BOOL的number类型
 */
@property(strong,nonatomic)NSNumber *status;
/**
 *  从服务器上来的真正的数据集合，任何类型，大部分是字典和数组，常见的是充满entity对象的数组
 */
@property(strong,nonatomic)id dataList;
/**
 *  新多一个code用来处理来自服务端的错误，其实有没有无所谓咯，但是要求有，就加上吧
 */
@property(strong,nonatomic)NSString* code;
/**
 *  将从服务器上拿来的字典转化成指定的实体类组成的数组
 *
 *  @param dic       服务器转化过来的字典
 *  @param classname 需要字典转成的实体类（Entity开头的对象）
 *
 *  @return 特殊格式CGDataResult的数据格式
 */
+getResultFromDic:(NSDictionary *)dic className:(NSString *)classname;
/**
 *  将从服务器上拿来的字典转化成特殊数据格式，无需转成固定实体类，只需要字典
 *
 *  @param dic 来自服务器的字典
 *
 *  @return 转换之后的实体
 */
+getResultFromDic:(NSDictionary *)dic;
@end
