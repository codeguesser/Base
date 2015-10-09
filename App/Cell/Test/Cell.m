//
//  Cell.m
//  base
//
//  Created by wsg on 15/7/19.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "Cell.h"

@implementation Cell
-(void)setData:(id)data{
    _data = data;
    if ([_data isKindOfClass:[UIImage class]]) {
        [_bt setImage:_data forState:0];
        _btDel.hidden = NO;
    }else{
        [_bt setImage:nil forState:0];
        _btDel.hidden = YES;
    }
}
- (IBAction)doDel:(UIButton *)sender {
    if (self.delAction) {
        self.delAction();
    }
}

@end
