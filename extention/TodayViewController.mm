//
//  TodayViewController.m
//  extention
//
//  Created by wsg on 15/12/4.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#ifdef U_BAIDU_KEY
#import <BaiduMapAPI/BMapKit.h>
#endif
@interface TodayViewController ()
#ifdef U_BAIDU_KEY
<NCWidgetProviding,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    BMKMapManager* _mapManager;
    BMKLocationService *_locService;
}
#endif
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
#ifdef U_BAIDU_KEY
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:U_BAIDU_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
#endif
}
-(CGSize)preferredContentSize{
    return CGSizeMake([[UIScreen mainScreen]bounds].size.width, 100);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.rsaif.base"];
    if ([[userDefault objectForKey:@"地址"] isEqualToString:@"nmj"]) {
        [touchIconButton setImage:[UIImage imageNamed:@"phone1icon1"] forState:0];
    }else{
        [touchIconButton setImage:[UIImage imageNamed:@"phone2icon2"] forState:0];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);

}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}
#pragma mark - custom methods
- (IBAction)buttonClicked:(UIButton *)sender {
#ifdef U_BAIDU_KEY
    [_locService startUserLocationService];
#endif
}
#ifdef U_BAIDU_KEY
#pragma mark - for baidu map
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (result) {
        NSLog(@"%@",result.address);
    }
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    BMKGeoCodeSearch *_geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    [_locService stopUserLocationService];
}
#endif
@end
