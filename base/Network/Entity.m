//
//  Entity.m
//  base
//
//  Created by wsg on 15/7/22.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "Entity.h"

@implementation Entity
+(id)getObjectFromDic:(NSDictionary *)dic{
    NSAssert(YES, @"请在子类里重写该方法！");
    return [Entity new];
}
-(NSDictionary *)toDictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *s in [self.class propertyKeys]) {
        dic[s] = [self valueForKey:s]?[self valueForKey:s]:@"";
    }
    return dic;
}
+(NSArray *)propertyKeys{
    NSAssert(YES, @"请在子类重写该函数！");
    return @[];
}
-(NSString *)description{
    return [self toDictionary].description;
}
+(NSArray *)getObjectsFromDic:(id)dic{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if([dic isKindOfClass:[NSArray class]]){
        for (NSDictionary *d in dic) {
            [arr addObject:[self getObjectFromDic:d]];
        }
    }else if([dic isKindOfClass:[NSDictionary class]]){
        [arr addObject:[self getObjectFromDic:dic]];
    }
    return arr;
}
-(id)dataFromValue:(id)target{
    NSString *var;
    if([target isKindOfClass:[NSString class]])var = target?target:@"";
    else if([target isKindOfClass:[NSNumber class]]){
        if ([[NSString stringWithFormat:@"%s",[(NSNumber *)target objCType]] isEqualToString:@"q"]) {
            var = target?[NSString stringWithFormat:@"%@",target]:@"";
        }else if ([[NSString stringWithFormat:@"%s",[(NSNumber *)target objCType]] isEqualToString:@"d"]) {
            var = target?[NSString stringWithFormat:@"%g",[target doubleValue]]:@"";
        }else{
            var = target?[NSString stringWithFormat:@"%@",target]:@"";
        }
        
    }
    else if (!target) {
        var = @"";
    }
    else if ([target isKindOfClass:[NSNull class]]) {
        var = @"";
    }else{
        var = target;
    }
    return var;
}
@end
