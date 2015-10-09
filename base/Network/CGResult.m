//
//  CGResult.m
//  base
//
//  Created by wsg on 15/8/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "CGResult.h"
#import "Entity.h"
@implementation CGResult
+getResultFromDic:(NSDictionary *)dic className:(NSString *)classname{
    CGResult *result = [CGResult new];
    if (dic&&([[dic objectForKey:CGApiStatusKey] isKindOfClass:[NSString class]]||[[dic objectForKey:CGApiStatusKey] isKindOfClass:[NSNumber class]])) {
        result.message = [dic objectForKey:CGApiMessageKey];
        result.status = [[[NSString stringWithFormat:@"%@",[dic objectForKey:CGApiStatusKey]] lowercaseString]isEqualToString:kCGTrueTag]?@(YES):@(NO);
        result.code = dic[CGApiCodeKey];
        
        id datalist = [NSClassFromString(classname) getObjectsFromDic:[self getDictionaryFromDic:dic]];
        if (datalist) {
            result.dataList = datalist;
        }
    }
    return result;
}
+getDictionaryFromDic:(NSDictionary *)dic{
#ifdef API_CONTENTS
    NSDictionary *newDic = @{};
    if(dic&&([dic isKindOfClass:[NSDictionary class]]|[dic isKindOfClass:[NSArray class]])){
        for (NSString *s in API_CONTENTS) {
            for (NSString *s1 in dic.allKeys) {
                if ([s isEqualToString:s1]) {
                    newDic = dic[s1];
                }
            }
        }
    }
    
    return newDic;
#else
    return dic&&([dic isKindOfClass:[NSDictionary class]]|[dic isKindOfClass:[NSArray class]])?[dic objectForKey:CGApiContentKey]:@{};
#endif
}
+getResultFromDic:(NSDictionary *)dic{
    CGResult *result = [CGResult new];
    if (dic&&([[dic objectForKey:CGApiStatusKey] isKindOfClass:[NSString class]]||[[dic objectForKey:CGApiStatusKey] isKindOfClass:[NSNumber class]])) {
        result.message = [dic objectForKey:CGApiMessageKey];
        result.code = dic[CGApiCodeKey];
        result.status = [[[NSString stringWithFormat:@"%@",[dic objectForKey:CGApiStatusKey]] lowercaseString]isEqualToString:kCGTrueTag]?@(YES):@(NO);
        id datalist = [self getDictionaryFromDic:dic];
        if (datalist) {
            result.dataList = datalist;
        }
    }
    return result;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"message:%@\ncode:%@\nstatus:%@\ndatalist:%@",self.message,self.code,self.status,self.dataList];
}
@end
