//
//  CGTableViewCell.h
//  base
//
//  Created by wsg on 15/8/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGTableViewCell : UITableViewCell
/**
 *  传递的data，必须是实体类，也就是EnityObject的子类或者它本身
 */
@property(nonatomic,strong)id data;
-(void)Init __attribute((objc_requires_super));
@end
