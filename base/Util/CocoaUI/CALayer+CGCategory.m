//
//  CGLayer.m
//  base
//
//  Created by wsg on 15/9/6.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "CALayer+CGCategory.h"

@implementation CALayer(CGCategory)
-(void)roundWithRadius:(CGFloat)radius{
    self.cornerRadius = radius;
    self.masksToBounds = YES;
}
-(void)borderWithWidth:(CGFloat)width color:(UIColor *)c{
    self.borderWidth = width;
    self.borderColor = c.CGColor;
}
@end
