//
//  TableViewCell.m
//  base
//
//  Created by wsg on 15/8/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "TableViewCell.h"
@implementation TableViewCell
-(void)layoutSubviews{
    [super layoutSubviews];
    _label.text = self.data;
    _label2.text = self.data;
    [_label layoutIfNeeded];
    [_label setNeedsLayout];
    [_label2 layoutIfNeeded];
    [_label2 setNeedsLayout];
}
-(void)updateConstraints{
    if (!self.isUpdated) {
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[contentView]-(0)-|" options:0 metrics:nil views:@{@"contentView":self.contentView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[contentView]-(0)-|" options:0 metrics:nil views:@{@"contentView":self.contentView}]];
        self.isUpdated = YES;
    }
    
    [super updateConstraints];
}
@end
