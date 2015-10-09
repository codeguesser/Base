//
//  NSDictionary+CGCategory.m
//  base
//
//  Created by wsg on 15/6/18.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "NSDictionary+CGCategory.h"

@implementation NSDictionary(CGCategory)
-(NSDictionary *)mapDictionaryWithDic:(NSDictionary *)mappedDic{
    NSMutableDictionary *dic = [self mutableCopy];
    for (NSString *targetKey in mappedDic.allKeys) {
        NSString * sourceKey = mappedDic[targetKey];
        if(self[sourceKey]){
            dic[targetKey] = self[sourceKey];
        }
    }
    return dic;
}
@end

