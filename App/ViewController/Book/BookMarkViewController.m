//
//  BookMarkViewController.m
//  base
//
//  Created by wsg on 15/9/10.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "BookMarkViewController.h"
#import "Part.h"
#import "Prefrence.h"
#import "BookMarkViewController.h"
#import "PartEntity.h"
@interface BookMarkViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *dataList;
}

@end

@implementation BookMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    dataList = [self getBookPartsFromLocal];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [dataList[indexPath.row] title];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList.count;
}
-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSArray *)getBookPartsFromLocal{
    NSArray *sourceArr = [Part MR_findAllSortedBy:@"pid" ascending:YES];
    NSMutableArray *arr = [NSMutableArray new];
    for (Part *p in sourceArr) {
        PartEntity *pe = [PartEntity new];
        pe.pid = p.pid;
        pe.title = p.title;
        pe.content = [p.content copy];
        [arr addObject:pe];
    }
    return arr;
}
@end
