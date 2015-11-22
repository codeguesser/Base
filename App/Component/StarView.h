//
//  StarView.h
//  base
//
//  用于显示小星星，如果允许用户录入，还可以用来触摸并进行反馈
//
//  Created by wsg on 15/11/22.
//  Copyright © 2015年 wsg. All rights reserved.
//
//  how to use it，怎么使用它呢？
//
//

#import <UIKit/UIKit.h>

@interface StarView : UIView
/*!
 * @brief 公共初始化方法
 */
-(void)Init;
/*!
 * @brief 总共的星数
 */
@property(nonatomic,assign)NSInteger count;
/*!
 * @brief 当前的进度
 */
@property(nonatomic,assign)CGFloat progress;
/*!
 * @brief 图片地址
 */
@property(nonatomic,strong)NSURL *imgUrl;
@end
