//
//  CGViewController.h
//  base
//
//  Created by wsg on 15/8/16.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGViewController : UIViewController<ITaskManager,IViewControllerTransformManager>
/*!
 @brief  控制器运行的路线，创建的时候出现，改变的时候改变
 */
@property(nonatomic,strong)NSString *runningPath;
@end
