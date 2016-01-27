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
    CLLocationManager *_service;
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
    
    if (self.warrantAction) {
        CGLocationError error = CGLocationErrorNormal;
        if (![CLLocationManager locationServicesEnabled]) {
            error = CGLocationErrorNoPermision;
        }
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
            error = CGLocationErrorDenied;
        }else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            error = CGLocationErrorNoDetermined;
        }
        if(error!=CGLocationErrorNormal)self.warrantAction(error);
    }else{
        if (![CLLocationManager locationServicesEnabled]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取定位" message:@"请在iPhone \"设置-隐私-定位服务\"中允许启用定位服务" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            });
        }else{
            if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取定位" message:@"请在iPhone \"设置-隐私-定位服务\"中允许动本使用定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
                    [alert show];
                });
            }else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
                _service = [[CLLocationManager alloc] init];
                if ([_service respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [_service requestWhenInUseAuthorization];
                }
            }
        }
        
    }
    [_locService startUserLocationService];
#endif
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
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
