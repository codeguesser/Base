//
//  HomeViewController.m
//  base
//
//  Created by wsg on 15/9/6.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "HomeViewController.h"
#import "ContactCell.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    __weak IBOutlet UIScrollView *_scrollView;
    NSMutableArray *tables;
    NSMutableArray *datas;
    __weak IBOutlet UIProgressView *_progress;
    int _page;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = PROJECT_DISPLAY_NAME;
    tables = [NSMutableArray new];
    datas = [NSMutableArray new];
    _page = 0 ;
    _scrollView.delegate = self;
    [datas addObjectsFromArray:@[@"",@"",@""]];
    _progress.progress = 1.0/(float)datas.count;
    
    
    for (int i=0; i<datas.count; i++) {
        UITableView *tableView = [[UITableView alloc]init];
        
        [_scrollView addSubview:tableView];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [tableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
        tableView.dataSource = self;
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_scrollView).offset = 0;
            make.top.equalTo(_scrollView).offset = 0;
            make.bottom.equalTo(_scrollView).offset = 0;
            make.size.with.equalTo(_scrollView).offset = 0;
            
            if (i==0) {
                make.left.equalTo(_scrollView).offset = 0;
            }else{
                make.left.equalTo(((UITableView *)[tables lastObject]).mas_right).offset = 0;
            }
            if(i==datas.count-1){
                make.right.equalTo(_scrollView).offset = 0;
            }
        }];
        tableView.tableFooterView = [UIView new];
        [tables addObject:tableView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (scrollView.contentOffset.x+scrollView.frame.size.width)/scrollView.frame.size.width;
    if (page != _page) {
        _page = page;
        self.title = [NSString stringWithFormat:@"%d",_page];
        
        _progress.progress = _page/(float)datas.count;
    }
}
@end
