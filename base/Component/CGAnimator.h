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
@property(nonatomic,assign)ITransformMethod method;//逻辑的类型,tab ,nav ，present
@property(nonatomic,assign)UIViewController * fromViewController;//开始的那个源控制器，用以判断当前真正需要的是哪个控制器
@end
