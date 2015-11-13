//
//  PunchedCardButton.m
//  base
//
//  Created by wsg on 15/11/5.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "PunchedCardButton.h"

@implementation PunchedCardButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self Init];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self Init];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self Init];
    }
    return self;
}
- (void)Init{
    [self addTarget:self action:@selector(punched) forControlEvents:UIControlEventTouchUpInside];
}
-(void)punched{
    self.transform = CGAffineTransformMakeScale(20, 20);
}
@end
