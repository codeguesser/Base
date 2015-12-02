//
//  TestGameViewController.m
//  base
//
//  Created by wsg on 15/12/2.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "TestGameViewController.h"

@interface TestGameViewController ()

@end

@implementation TestGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
