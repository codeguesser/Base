//
//  CGLocationService.h
//  base
//
//  Created by wsg on 15/12/25.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGLocationService : NSObject
@property(nonatomic,strong)void(^clickAction)();
-(void)startLocation;
@end
