//
//  CGLocationService.h
//  base
//
//  Created by wsg on 15/12/25.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CGLocationData:NSObject
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)CLLocation *location;
+(id)locationDataWithAddress:(NSString *)address location:(CLLocation *)location;
@end
@interface CGLocationService : NSObject
@property(nonatomic,strong)void(^clickAction)();
-(void)startLocation;
- (instancetype)initWithoutGetLocation;
@end
