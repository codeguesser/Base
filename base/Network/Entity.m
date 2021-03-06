//
//  Entity.m
//  base
//
//  Created by wsg on 15/7/22.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "Entity.h"
@interface Entity(){
    
    NSNumberFormatter *formatter;
}
@end
@implementation Entity
+(id)getObjectFromDic:(NSDictionary *)dic{
    NSAssert(YES, @"请在子类里重写该方法！");
    return [Entity new];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        formatter = [[NSNumberFormatter alloc]init];
        formatter.numberStyle = NSNumberFormatterNoStyle;
        formatter.maximumFractionDigits = 20;
    }
    return self;
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
        var = target?[formatter stringFromNumber:target]:@"";
//        if ([[NSString stringWithFormat:@"%s",[(NSNumber *)target objCType]] isEqualToString:@"q"]) {
//            var = target?[NSString stringWithFormat:@"%@",target]:@"";
//        }else if ([[NSString stringWithFormat:@"%s",[(NSNumber *)target objCType]] isEqualToString:@"d"]) {
//            var = target?[NSString stringWithFormat:@"%g",[target doubleValue]]:@"";
//        }else{
//            var = target?[NSString stringWithFormat:@"%@",target]:@"";
//        }
        
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
-(BOOL)isEqual:(id)object{
    if (self == object) {
        return YES;
    }
    BOOL isequal = YES;
    if ([self.class propertyKeys].count>0) {
        for (NSString *s in [self.class propertyKeys]) {
            if(![[self valueForKey:s]isEqual:[object valueForKey:s]]){
                isequal = NO;
                break;
            }
        }
    }
    return isequal;
}
@end
