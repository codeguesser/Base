//
//  UserEntity.h
//  base
//
//  Created by wsg on 15/8/15.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "Entity.h"

@interface UserEntity : Entity<NSCoding>
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *uid;
@end
