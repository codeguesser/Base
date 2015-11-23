//
//  StarView.m
//  base
//
//  Created by wsg on 15/11/22.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "StarView.h"
@interface StarView (){
    UIImage *img;
    UIImageView *imgBackGroundView;
    UIImageView *imgView;
}
@end
@implementation StarView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
-(void)Init{
    imgBackGroundView = [[UIImageView alloc]init];
    imgView = [[UIImageView alloc]init];
    [self addSubview:imgBackGroundView];
    [self addSubview:imgView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:self.imgUrl]];
        imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imgView.contentMode = UIViewContentModeLeft;
        imgBackGroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imgView.image = [self imgFromSources];
        imgBackGroundView.image = [self createMaskImageWithImage:[self imgFromSources]];
        
        imgView.clipsToBounds = YES;
        imgBackGroundView.clipsToBounds = YES;
        [UIView animateWithDuration:.3f animations:^{
            imgView.frame = CGRectMake(0, 0, self.frame.size.width*self.progress, self.frame.size.height);
        }];
    });
}


-(UIImage *)imgFromSources{
    UIGraphicsBeginImageContext(self.frame.size);
    for (int i=0; i<self.count; i++) {
        CGFloat cellWidth = self.frame.size.width/self.count;
        CGFloat cellHeight = self.frame.size.height;
        
        CGSize finalSize = CGSizeMake(cellWidth, cellWidth*img.size.height/img.size.width);
        if (finalSize.height>cellHeight) {
            finalSize = CGSizeMake(cellHeight*img.size.width/img.size.height, cellHeight);
        }
        [img drawInRect:CGRectMake(cellWidth*i+(cellWidth-finalSize.width)/2.0, (cellHeight-finalSize.height)/2.0, finalSize.width, finalSize.height)];
    }
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage;
}
-(UIImage *)createMaskImageWithImage:(UIImage *)oldImage{
    UIGraphicsBeginImageContext(oldImage.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0,0.0,0.0,0.3);
    CGContextClipToMask(context, CGRectMake(0, 0, oldImage.size.width, oldImage.size.height), oldImage.CGImage);
    CGContextFillRect(context, CGRectMake(0, 0,oldImage.size.width, oldImage.size.height));
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    self.progress = [touch locationInView:self].x/self.frame.size.width;
//    self.progress =
    imgView.frame = CGRectMake(0, 0, self.frame.size.width*self.progress, self.frame.size.height);
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    self.progress = [touch locationInView:self].x/self.frame.size.width;
    imgView.frame = CGRectMake(0, 0, self.frame.size.width*self.progress, self.frame.size.height);
}
@end
