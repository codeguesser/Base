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
//        
//        CALayer *layer = [CALayer layer];
////        layer.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"delete"]CGImage]);
//        layer.backgroundColor = [UIColor greenColor].CGColor;
//        layer.contentsScale = [UIScreen mainScreen].scale;
//        layer.contentsGravity = kCAGravityCenter;
//        
//        layer.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
////                layer.contentsRect = CGRectMake(0, 0, 0.5, 0.5);
//        //    layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
//        
//        layer.anchorPoint = CGPointMake(0.5, 0.5);
////        self.transform = CGAffineTransformMakeRotation(M_PI_4);
//        layer.transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
//        
//        
//        CATransform3D perspective = CATransform3DIdentity;
//        perspective.m34 = - 1.0 / 500.0;
//        self.layer.transform = CATransform3DRotate(perspective, M_PI_4, 0, 1, 0);
//        layer.transform = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
//        /*
//         //二维仿射变换
//        CGAffineTransform form = CGAffineTransformIdentity;
//        form.c = -1;
//        form.b = 0;
//        layer.affineTransform = form;
//        */
//        
//        
//        
////        layer.borderWidth = 1;
////        layer.borderColor = [UIColor greenColor].CGColor;
//        layer.masksToBounds = YES;
//        [self.layer addSublayer:layer];
////        self.layer.cornerRadius = 20.0;
//        /*
//        //阴影
//        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//        self.layer.shadowRadius = 5.0;
//        self.layer.shadowOffset = CGSizeMake(5, 5);
//        self.layer.shadowOpacity = 0.5;
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathAddRect(path, NULL, CGRectMake(0, 0, 110, 110));
//         self.layer.shadowPath = path;
//         */
//        self.backgroundColor = [UIColor redColor];
        
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CALayer *tLayer1 = [CALayer layer];
    tLayer1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    tLayer1.delegate = self;
    [tLayer1 display];
    
    CAGradientLayer *tLayer2 = [CAGradientLayer layer];
    tLayer2.frame = CGRectMake(0, 0 , self.frame.size.width, self.frame.size.height);

    tLayer2.colors =  @[(id)[[UIColor greenColor] CGColor],(id)[[UIColor redColor]CGColor]];
    tLayer2.locations =  @[@(0),@(1)];
//    tLayer2.backgroundColor = [UIColor greenColor].CGColor;
    tLayer2.mask = tLayer1;
    
//    layer1 = [CALayer layer];
//    layer1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    layer1.backgroundColor = [UIColor blueColor].CGColor;
//    layer1.contentsScale = [UIScreen mainScreen].scale;
//    layer1.delegate = self;
//    [self.layer addSublayer:layer1];
//    [layer1 display];
    
    
    [self.layer addSublayer:tLayer2];
}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGRect frame = layer.frame;
    CGFloat margin = 5;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, frame.size.width, margin));
    CGPathAddRect(path, NULL, CGRectMake(frame.size.width-margin, 0, margin, self.frame.size.height));
    CGPathAddRect(path, NULL, CGRectMake(0, frame.size.height-margin, self.frame.size.width, margin));
    CGPathAddRect(path, NULL, CGRectMake(0, 0, margin, frame.size.height));
    CGContextAddPath(ctx, path);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);
    
//    CGContextSetLineWidth(ctx, 10.0f);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}
@end
