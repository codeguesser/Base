//
//  TableViewController.m
//  base
//
//  Created by wsg on 15/8/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
NSString *const cellId = @"TableViewCell";
@interface TableViewController ()<UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITableViewDelegate>{
    NSMutableArray *_dataList;
    __weak IBOutlet UITableView *_tableView;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _tableView.tableFooterView = [UIView new];
//    _tableView.tableHeaderView = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil][0];
    _dataList = [NSMutableArray new];
    [_dataList addObject:@"123123"];
    [_dataList addObject:@"123123123123123123123123123123"];
    [_dataList addObject:@"123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123"];
    [_dataList addObject:@"123123"];
    [_dataList addObject:@"123123123123123123123123123123"];
    [_dataList addObject:@"123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123"];
    [_dataList addObject:@"123123"];
    [_dataList addObject:@"123123123123123123123123123123"];
    [_dataList addObject:@"123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123"];
    [_dataList addObject:@"123123"];
    [_dataList addObject:@"123123123123123123123123123123"];
    [_dataList addObject:@"123123123123123123123123123123123123123123123123123123123123123123123123123123123123123123"];
    [_tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    @weakify_self
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify_self
        self.title = @"";
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.data = _dataList[indexPath.row];
//    cell.str1 = @"第一个值";
//    cell.str2 = @"第二个值";
//    cell.str3 = @"低三个值低三个值低三个值低三个值低三个值低三个值低三个值";
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell layoutSubviews];
    [cell layoutIfNeeded];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.data = _dataList[indexPath.row];
//    cell.str1 = @"第一个值";
//    cell.str2 = @"第二个值";
//    cell.str3 = @"低三个值低三个值低三个值低三个值低三个值低三个值低三个值";
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell layoutSubviews];
    [cell layoutIfNeeded];
    float height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    return [[NSAttributedString alloc] initWithString:@"没有数据"];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1;
//}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [UIView new];
//}
@end
