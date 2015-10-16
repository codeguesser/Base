//
//  LoadingView.h
//  base
//
//  Created by wsg on 15/10/12.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView{
    CALayer *layer1;
    CAGradientLayer *tLayer2;
    CGFloat angel;
    CADisplayLink *link;
}

@end
