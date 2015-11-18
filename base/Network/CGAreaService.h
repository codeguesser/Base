//
//  CGAreaService.h
//  base
//
//  Created by wsg on 15/11/18.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
@interface CGAreaData:Entity
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSArray *data;
@end
@interface CGAreaService : NSObject
+ (id)service;
@end
