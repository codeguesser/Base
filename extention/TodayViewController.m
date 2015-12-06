//
//  TodayViewController.m
//  extention
//
//  Created by wsg on 15/12/4.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}
- (IBAction)buttonClicked:(UIButton *)sender {
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.rsaif.base"];
    NSLog(@"%@",[[NSBundle mainBundle] infoDictionary]);
    NSLog(@"app group:\n%@",containerURL.path);
    
    
    
    //打印可执行文件路径
    
    NSLog(@"bundle:\n%@",[[NSBundle mainBundle] bundlePath]);
    
    
    
    //打印documents
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *path = [paths objectAtIndex:0];
    
    NSLog(@"documents:\n%@",path);
}

@end
