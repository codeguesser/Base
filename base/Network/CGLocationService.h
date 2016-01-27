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
    CGLocationErrorNoPermision, //没有开启定位服务
    CGLocationErrorDenied,      //被拒绝的权限
    CGLocationErrorNoDetermined,//未曾选择的权限
    CGLocationErrorNormal       //访问正常
};
@interface CGLocationData:NSObject
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)CLLocation *location;
+(id)locationDataWithAddress:(NSString *)address location:(CLLocation *)location;
@end
@interface CGLocationService : NSObject<UIAlertViewDelegate>
/*!
 @brief 启动定位
 */
-(void)startLocation;
/*!
 @brief 如果你使用这种启动方式，则不会立即调用startLocation，你需要手动去调用
 
 @return
 */
- (instancetype)initWithoutGetLocation;
/*!
 @brief 获取授权事件，你可以不写，他会有弹框提供选择
 */
@property(nonatomic,strong)void(^warrantAction)(CGLocationError error);
@end
