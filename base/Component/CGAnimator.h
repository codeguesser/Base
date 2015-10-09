//
//  Animator.h
//  base
//
//  Created by wsg on 15/8/25.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CGAnimator : NSObject<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>
/*!
 @brief  转换方式
 */
@property(nonatomic,assign)ITransformMethod method;
@end
