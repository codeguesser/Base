//
//  CGLocationService.m
//  base
//
//  Created by wsg on 15/12/25.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "CGLocationService.h"
#ifdef U_BAIDU_KEY
#import <BaiduMapAPI/BMapKit.h>
#endif
@implementation CGLocationData
+(id)locationDataWithAddress:(NSString *)address location:(CLLocation *)location{
    CGLocationData *d = [[CGLocationData alloc]init];
    d.address =  address;
    d.location = location;
    return d;
}
@end

@interface CGLocationService()
#ifdef U_BAIDU_KEY
<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    BMKLocationService *_locService;
    BMKMapManager* _mapManager;
}
#endif
@end
@implementation CGLocationService
- (instancetype)init
{
    self = [super init];
    if (self) {
        
#ifdef U_BAIDU_KEY
        _mapManager = [[BMKMapManager alloc]init];
        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
        BOOL ret = [_mapManager start:U_BAIDU_KEY  generalDelegate:nil];
        if (!ret) {
            NSLog(@"manager start failed!");
        }
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:50.f];
        
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
#endif
        [self startLocation];
    }
    return self;
}
- (instancetype)initWithoutGetLocation
{
    self = [super init];
    if (self) {
#ifdef U_BAIDU_KEY
        _mapManager = [[BMKMapManager alloc]init];
        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
        BOOL ret = [_mapManager start:U_BAIDU_KEY  generalDelegate:nil];
        if (!ret) {
            NSLog(@"manager start failed!");
        }
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:50.f];
        
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
#endif
    }
    return self;
}
-(void)startLocation{
#ifdef U_BAIDU_KEY
    if (![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
        if (self.warrantAction) {
            self.warrantAction();
        }else{
            NSLog(@"权限不足，请重新取得权限之后再操作！！！");
        }
    }
    [_locService startUserLocationService];
#endif
}
#ifdef U_BAIDU_KEY
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self geocodeLocation:userLocation];
    [_locService stopUserLocationService];
}
-(void)didFailToLocateUserWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:CGBaiduGetLocationAttributeNotification object:nil];
    [_locService stopUserLocationService];
}
- (void)geocodeLocation:(BMKUserLocation *)userLocation
{
    BMKGeoCodeSearch *_geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CGBaiduGetLocationAttributeNotification object:[CGLocationData locationDataWithAddress:result.address location:[[CLLocation alloc] initWithLatitude:result.location.latitude longitude:result.location.longitude]]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:CGBaiduGetLocationAttributeNotification object:nil];
    }
}
#endif
@end
