//
//  EntityTest.m
//  base
//
//  Created by wsg on 15/7/22.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "EntityTest.h"

@implementation EntityTest
+(id)getObjectFromDic:(NSDictionary *)dic{
    EntityTest *t = [EntityTest new];
    t.tt1 = dic[@"tt1"];
    t.tt2 = dic[@"tt2"];
    t.tt3 = dic[@"tt3"];
    t.tt4 = dic[@"tt4"];
    t.tt5 = dic[@"tt5"];
    return t;
}
+ (NSArray *)propertyKeys{
    return @[@"tt1",@"tt2",@"tt3",@"tt4",@"tt5"];
}
-(void)setTt1:(NSString *)tt1{
    _tt1 = [self dataFromValue:tt1];
}

-(void)setTt2:(NSString *)tt2{
    _tt2 = [self dataFromValue:tt2];
}

-(void)setTt3:(NSString *)tt3{
    _tt3 = [self dataFromValue:tt3];
}

-(void)setTt4:(NSString *)tt4{
    _tt4 = [self dataFromValue:tt4];
}

-(void)setTt5:(NSString *)tt5{
    _tt5 = [self dataFromValue:tt5];
}



@end
@implementation EntityTest (Helper)

@end