//
//  Prefrence.m
//  base
//
//  Created by wsg on 15/8/15.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "Prefrence.h"

@implementation Prefrence
+(void)saveUserMe:(UserEntity *)me{
    NSUserDefaults  *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:[NSKeyedArchiver archivedDataWithRootObject:me] forKey:kPrefrenceUserMe];
    [settings synchronize];
}
+(void)clearUserMe{
    NSUserDefaults  *settings = [NSUserDefaults standardUserDefaults];
    if([settings objectForKey:kPrefrenceUserMe]){
        [settings removeObjectForKey:kPrefrenceUserMe];
        [settings synchronize];
    }
}
+(UserEntity *)me{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kPrefrenceUserMe]?[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:kPrefrenceUserMe]]:nil;
}

+(void)saveLastPageWith:(NSUInteger)page{
    NSUserDefaults  *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:@(page) forKey:kPrefrencePartPage];
    [settings synchronize];
}
+(NSInteger)lastPage{
    NSUserDefaults  *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:kPrefrencePartPage]?[[settings objectForKey:kPrefrencePartPage] integerValue]:0;
}
+(void)saveLastPageNumberWith:(NSUInteger)page{
    NSUserDefaults  *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:@(page) forKey:kPrefrencePartPageStartNumber];
    [settings synchronize];
}
+(NSInteger)lastPageNumber{
    NSUserDefaults  *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:kPrefrencePartPageStartNumber]?[[settings objectForKey:kPrefrencePartPageStartNumber] integerValue]:0;
}
@end
