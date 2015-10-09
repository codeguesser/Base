//
//  TestAttributeViewController.m
//  base
//
//  Created by wsg on 15/8/22.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "TestAttributeViewController.h"

@interface TestAttributeViewController ()
/*!
 *  @author wsg
 *
 *  @brief  非空对象 __attribute__((nonnull(1)))   1代表第一个对象不为空，多选用空格隔开，全不为空，小括号里可以不选
 ,noreturn代表必须有return    const表示调用频繁，const可以生成缓存值
 *
 *  @param paraString <#paraString description#>
 *  @param para2      <#para2 description#>
 */
-(NSString *)testActionWithPara:(NSString *)paraString para2:(NSString *)para2 __attribute__((nonnull(1))) __attribute__((noreturn)) __attribute__((const));
@end

@implementation TestAttributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self testActionWithPara:@"" para2:nil];
    
    
    
    
    
}
-(NSString *)testActionWithPara:(NSString *)paraString para2:(NSString *)para2 __attribute__((nonnull(1))) __attribute__((noreturn)){
    return @"";
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

@end
