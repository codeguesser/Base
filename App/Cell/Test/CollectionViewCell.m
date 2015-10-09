//
//  CollectionViewCell.m
//  base
//
//  Created by wsg on 15/6/30.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(void)layoutSubviews{
    [super layoutSubviews];
    if ([self.data isKindOfClass:[UIImage class]]) {
        [_img setImage:self.data];
    }else{
        [_img setImage:nil];
    }
}
-(UIView *)copiedView{
    UIImageView *copied = [[UIImageView alloc] initWithFrame:self.frame];
    copied.image = [self copyedImage];
    return copied;
}
-(UIImage *)copyedImage{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, [[UIScreen mainScreen] scale]);
    [self.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (IBAction)del:(UIButton *)sender {
    if(self.deleteAction)self.deleteAction();
}
@end
