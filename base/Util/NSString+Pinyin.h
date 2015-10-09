//
//  NSString+Pinyin.h
//  base
//
//  Created by wangshuguan on 15/6/13.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>
OBJC_EXPORT NSString* doubleNumberCovertToString(double number);
@interface NSString(Pinyin)
/*!
 @brief  从字典源获取拼音 useage： NSLog(@"%@",[@"王书倌" pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]]);
 
 @param sourceDictionary 源数据，一般是[[ShareHandle shareHandle] pinyinSourceDic]
 
 @return 得到的拼音
 */
- (NSString *)pinyinFromSource:(NSDictionary *)sourceDictionary;
/**
 *  拼音字符串
 *
 *  @return 拼音
 */
-(NSString *)pinyin __deprecated_msg("该方法是系统方法的的拼音拓展，效率较慢，采用 pinyinFromSource:");
/**
 *  拼音的第一个字符，相当于“我们”wm
 *
 *  @return
 */
-(NSString *)pinyinFirstLettersWithSource:(NSDictionary *)sourceDictionary;
/**
 *  字符串中的第几个字符
 *
 *  @param index 字符的序列
 *
 *  @return 字符串
 */
-(NSString *)stringAtIndex:(NSUInteger)index;
/**
 *  unicode转换成utf8格式的字符串
 *
 *  @return
 */
-(NSString *)stringFromUnicode;
/**
 *  第一个字符大写的方法
 *
 *  @return 返回第一个字符大写，注意里面不能写中文
 */
-(NSString *)capitalizedFirstCharacterString;
@end
