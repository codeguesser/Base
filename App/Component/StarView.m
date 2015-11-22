//
//  StarView.m
//  base
//
//  Created by wsg on 15/11/22.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "StarView.h"

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
    
}
-(void)drawRect:(CGRect)rect{
    UIImage *img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:self.imgUrl]];
    for (int i=0; i<self.count; i++) {
        CGFloat cellWidth = self.frame.size.width/self.count;
        CGFloat cellHeight = self.frame.size.height;
        
        CGSize finalSize = CGSizeMake(cellWidth, cellWidth*img.size.height/img.size.width);
        if (finalSize.height>cellHeight) {
            finalSize = CGSizeMake(cellHeight*img.size.width/img.size.height, cellHeight);
        }
        [img drawInRect:CGRectMake(cellWidth*i+(cellWidth-finalSize.width)/2.0, (cellHeight-finalSize.height)/2.0, finalSize.width, finalSize.height)];
    }
}
@end
