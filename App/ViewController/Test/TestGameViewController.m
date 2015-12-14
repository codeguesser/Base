//
//  TestGameViewController.m
//  base
//
//  Created by wsg on 15/12/2.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "TestGameViewController.h"
#import "ScrollHeaderView.h"
@import NotificationCenter;
@interface TestGameViewController ()

@end

@implementation TestGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor redColor];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [bt setTitle:@"这是个按钮" forState:0];
    [self.view addSubview:bt];
    [bt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    ScrollHeaderView *view1 = [[NSBundle mainBundle] loadNibNamed:@"ScrollHeaderView" owner:nil options:nil][0];
    view1.frame = CGRectMake(0, 100, self.view.frame.size.width, 100);
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view1];
    view1.images = @[[UIImage imageNamed:@"phone1"],[UIImage imageNamed:@"phone1"],[UIImage imageNamed:@"phone1"],[UIImage imageNamed:@"phone1"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickAction:(UIButton *)bt{
    
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.rsaif.base"];
    if ([[userDefault objectForKey:@"地址"] isEqualToString:@"nmj"]) {
        [userDefault setObject:@"nmjxxx" forKey:@"地址"];
    }else{
        [userDefault setObject:@"nmj" forKey:@"地址"];
    }
    [userDefault synchronize];
    [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.rsaif.base.extention"];
}
@end
