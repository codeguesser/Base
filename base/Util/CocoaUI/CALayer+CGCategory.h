//
//  CGLayer.h
//  base
//
//  Created by wsg on 15/9/6.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer(CGCategory)
/*!
 *  @author wsg
 *
 *  @brief  圆角
 *
 *  @param radius 角度
 */
-(void)roundWithRadius:(CGFloat)radius;
/*!
 *  @author wsg
 *
 *  @brief  设置边框样式
 *
 *  @param width 边框长度
 *  @param c     边框颜色
 */
-(void)borderWithWidth:(CGFloat)width color:(UIColor *)c;
@end
