//
//  TestLayoutViewController.m
//  base
//
//  Created by wsg on 15/8/21.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "TestLayoutViewController.h"

@interface TestLayoutViewController (){
    UIScrollView *_scrollView;
}

@end

@implementation TestLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(changeAction:)];
    
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    @weakify_self
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify_self
        make.edges.equalTo(self.view).insets = UIEdgeInsetsMake(20, 20, 20, 20);
    }];
}

- (void)changeAction:(UIBarButtonItem *)item{
    UITableView *table1 = [[UITableView alloc]init];
    table1.backgroundColor = [UIColor brownColor];
    UITableView *table2 = [[UITableView alloc]init];
    table2.backgroundColor = [UIColor purpleColor];
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor orangeColor];
    
    [_scrollView addSubview:table1];
    [_scrollView addSubview:table2];
    [_scrollView addSubview:scrollView];
    @weakify(_scrollView)
    [table1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(_scrollView)
        make.centerY.equalTo(strong__scrollView).offset = 0;
        make.top.equalTo(strong__scrollView).offset = 0;
        make.bottom.equalTo(strong__scrollView).offset = 0;
        make.left.equalTo(strong__scrollView).offset = 0;
        make.size.with.equalTo(strong__scrollView).offset = 0;
    }];
    @weakify(table1);
    [table2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(_scrollView)
        @strongify(table1)
        make.centerY.equalTo(strong__scrollView).offset = 0;
        make.top.equalTo(strong__scrollView).offset = 0;
        make.bottom.equalTo(strong__scrollView).offset = 0;
        make.left.equalTo(strong_table1.mas_right).offset = 0;
        make.size.width.equalTo(strong__scrollView).offset = 0;
    }];
    @weakify(table2);
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(_scrollView)
        @strongify(table2)
        make.centerY.equalTo(strong__scrollView).offset = 0;
        make.top.equalTo(strong__scrollView).offset = 0;
        make.bottom.equalTo(strong__scrollView).offset = 0;
        make.left.equalTo(strong_table2.mas_right).offset = 0;
        make.right.equalTo(strong__scrollView).offset = 0;
        make.size.width.equalTo(strong__scrollView).offset = 0;
    }];
}

@end
