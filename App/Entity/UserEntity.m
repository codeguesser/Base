//
//  UserEntity.m
//  base
//
//  Created by wsg on 15/8/15.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity
+(id)getObjectFromDic:(NSDictionary *)dic{
    UserEntity *t = [UserEntity new];
    t.username = dic[@"username"];
    t.uid = dic[@"uid"];
    return t;
}
+ (NSArray *)propertyKeys{
    return @[@"username",@"uid"];
}

#pragma mark - methods for Setter
-(void)setUsername:(NSString *)username{
    _username = [self dataFromValue:username];
}

-(void)setUid:(NSString *)uid{
    _uid = [self dataFromValue:uid];
}

#pragma mark - methods for NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_username  forKey:@"username"];
    [aCoder encodeObject:_uid  forKey:@"uid"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _uid = [aDecoder decodeObjectForKey:@"uid"];
    }
    return self;
}
@end
