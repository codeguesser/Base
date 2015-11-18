//
//  CGAreaService.m
//  base
//
//  Created by wsg on 15/11/18.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "CGAreaService.h"
@implementation CGAreaData
+(id)getObjectFromDic:(NSDictionary *)dic{
    CGAreaData *t = [CGAreaData new];
    t.name = dic[@"name"];
    t.data = dic[@"data"];
    return t;
}
+ (NSArray *)propertyKeys{
    return @[@"name",@"data"];
}

#pragma mark - methods for Setter
-(void)setName:(NSString *)name{
    _name = [self dataFromValue:name];
}

-(void)setData:(NSString *)data{
    _data = [self dataFromValue:data];
}

#pragma mark - methods for NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name  forKey:@"name"];
    [aCoder encodeObject:_data  forKey:@"data"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _data = [aDecoder decodeObjectForKey:@"data"];
    }
    return self;
}
-(BOOL)isEqual:(CGAreaData *)object{
    return [self.name isEqualToString:object.name];
}
@end
@implementation CGAreaService
+ (id)service{
    CGAreaService *service = [[CGAreaService alloc]init];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"] ];
    service.allProvinces = [self arrayFormDictionary:dic];
    NSMutableArray *citys = [NSMutableArray new];
    for (CGAreaData *p in service.allProvinces) {
        if (p.data.count>0) {
            [citys addObjectsFromArray:p.data];
        }
    }
    service.allCitys = citys;
    return service;
}
- (CGAreaData *)provinceWithName:(NSString *)province{
    for (CGAreaData *d in self.allProvinces) {
        if ([d.name isEqual:province]) {
            return d;
        }
    }
    return nil;
}
+(NSArray *)arrayFormDictionary:(NSDictionary *)dic{
    NSMutableArray *allProvinces = [NSMutableArray new];
    for (int i=0; i<dic.count; i++) {
        NSDictionary *provinceDir = dic[[NSString stringWithFormat:@"%d",i]] ;
        NSString *provinceName = [[provinceDir allKeys] firstObject];
        NSDictionary *provinceData = provinceDir[provinceName];
        if ([provinceData isKindOfClass:[NSDictionary class]]) {
            CGAreaData *data = [CGAreaData getObjectFromDic:@{@"name":provinceName,@"data":[self arrayFormDictionary:provinceData]}];
            [allProvinces addObject:data];
        }else if([provinceData isKindOfClass:[NSArray class]]){
            CGAreaData *data = [CGAreaData getObjectFromDic:@{@"name":provinceName,@"data":provinceData}];
            [allProvinces addObject:data];
        }
        
    }
    return allProvinces;
}
@end
