//
//  Prefrence.h
//  base
//
//  Created by wsg on 15/8/15.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"
#define kPrefrenceUserMe @"kPrefrenceUserMe"


#define kPrefrencePartPage @"kPrefrencePartPage"
#define kPrefrencePartPageStartNumber @"kPrefrencePartPageStartNumber"
@interface Prefrence : NSObject
+(void)saveUserMe:(UserEntity *)me;
+(void)clearUserMe;
+(UserEntity *)me;


+(void)saveLastPageWith:(NSUInteger)page;
+(NSInteger)lastPage;
+(void)saveLastPageNumberWith:(NSUInteger)page;
+(NSInteger)lastPageNumber;
@end
