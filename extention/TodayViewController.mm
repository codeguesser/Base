//
//  TodayViewController.m
//  extention
//
//  Created by wsg on 15/12/4.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "CGLocationService.h"
#import <UIKit/UIKit.h>
@interface TodayViewController ()
#ifdef U_BAIDU_KEY
<NCWidgetProviding>{
    CGLocationService *service;
}
#endif
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    resultlabel.adjustsFontSizeToFitWidth = YES;
    service = [[CGLocationService alloc]initWithoutGetLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocation:) name:CGBaiduGetLocationAttributeNotification object:nil];
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
    [service startLocation];
}
-(void)getLocation:(NSNotification *)no{
#ifdef U_BAIDU_KEY
    CGLocationData *result = no.object;
    if (result) {
        NSLog(@"%@,%f,%f",result.address,result.location.coordinate.latitude,result.location.coordinate.longitude);
        dispatch_async(dispatch_get_main_queue(), ^{
            [resultlabel setText:[[NSDate date].description stringByAppendingString:result.address]];
        });
    }else{
        
    }
#endif
    
}
@end
