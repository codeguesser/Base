//
//  TestViewController.m
//  base
//
//  Created by wsg on 15/9/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "TestViewController.h"
#import "LoadingView.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LoadingView *view = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:view];
    self.view.backgroundColor = [UIColor whiteColor];
    view.center = self.view.center;
    
    
    
}

@end
