//
//  LoadingView.m
//  base
//
//  Created by wsg on 15/10/12.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CALayer *layer = [CALayer layer];
//        layer.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"delete"]CGImage]);
        layer.backgroundColor = [UIColor greenColor].CGColor;
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.contentsGravity = kCAGravityCenter;
        
        layer.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
//                layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
        //    layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
        
        layer.anchorPoint = CGPointMake(0.5, 0.5);
//        self.transform = CGAffineTransformMakeRotation(M_PI_4);
        layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
        
        
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = - 1.0 / 500.0;
        self.layer.transform = CATransform3DRotate(perspective, M_PI_4, 0, 1, 0);
        layer.transform = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
        /*
         //二维仿射变换
        CGAffineTransform form = CGAffineTransformIdentity;
        form.c = -1;
        form.b = 0;
        layer.affineTransform = form;
        */
        
        
        
//        layer.borderWidth = 1;
//        layer.borderColor = [UIColor greenColor].CGColor;
        layer.masksToBounds = YES;
        [self.layer addSublayer:layer];
//        self.layer.cornerRadius = 20.0;
        /*
        //阴影
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowOpacity = 0.5;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, 110, 110));
         self.layer.shadowPath = path;
         */
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end
