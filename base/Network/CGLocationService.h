//
//  CGLocationService.h
//  base
//
//  简化的获取百度地理信息服务
//
//  Created by wsg on 15/12/25.
//  Copyright © 2015年 wsg. All rights reserved.
//
//  how to use it !!!如何使用！！！！
//
//  service2 = [[CGLocationService alloc]initWithoutGetLocation];
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocation:) name:CGBaiduGetLocationAttributeNotification object:nil];
//  service2.warrantAction =^(CGLocationError error){
//
//  };
//  [service2 startLocation];
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef NS_ENUM(NSUInteger, CGLocationError){
    CGLocationErrorNoPermision,
    CGLocationErrorDenied,
    CGLocationErrorNoDetermined,
    CGLocationErrorNormal
};
@interface CGLocationData:NSObject
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)CLLocation *location;
+(id)locationDataWithAddress:(NSString *)address location:(CLLocation *)location;
@end
@interface CGLocationService : NSObject<UIAlertViewDelegate>
-(void)startLocation;
- (instancetype)initWithoutGetLocation;
/*!
 @brief 获取授权事件
 */
@property(nonatomic,strong)void(^warrantAction)(CGLocationError error);
@end
