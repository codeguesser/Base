//
//  UserLoginViewController.m
//  base
//
//  Created by wsg on 15/8/15.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "UserLoginViewController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self addTaskWithUrl:@"http://www.baidu.com" para:nil method:@"GET"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightItemClicked:)];
}
- (void)rightItemClicked:(UIBarButtonItem *)item{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)login:(id)sender {
    [ShareHandle shareHandle].me = [UserEntity new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
