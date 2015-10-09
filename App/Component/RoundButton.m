//
//  RoundButton.m
//  base
//
//  Created by wsg on 15/9/6.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.layer roundWithRadius:self.frame.size.height];
            [self.layer borderWithWidth:0.5f color:[UIColor colorWithWhite:.3 alpha:1]];
            self.backgroundColor = [UIColor greenColor];
        });
    }
    return self;
}

@end
