//
//  TableViewCell2.m
//  base
//
//  Created by wsg on 15/10/23.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "TableViewCell2.h"

@implementation TableViewCell2

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _label1.text = self.str1;
    _label2.text = self.str2;
    _label3.text = self.str3;
    [_label1 layoutIfNeeded];
    [_label1 setNeedsLayout];
    [_label2 layoutIfNeeded];
    [_label2 setNeedsLayout];
    [_label3 layoutIfNeeded];
    [_label3 setNeedsLayout];
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
