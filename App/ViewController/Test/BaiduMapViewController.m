//
//  BaiduMapViewController.m
//  base
//
//  Created by wsg on 15/9/2.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "BaiduMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>
/*!
 @brief  百度地图demo
 */
@interface BaiduMapViewController ()<BMKGeoCodeSearchDelegate>{
    BMKMapManager* _mapManager;
}

@end

@implementation BaiduMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"ImZ1b3Kyc0c9QsuGold6RED6"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    BMKGeoCodeSearch *_geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(112.37347,34.66624);
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (result) {
        
    }
}
@end
