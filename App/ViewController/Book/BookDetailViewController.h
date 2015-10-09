//
//  BookDetailViewController.h
//  base
//
//  Created by wsg on 15/9/8.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "CGViewController.h"
#import "PartEntity.h"
@interface BookDetailViewController : CGViewController
@property(nonatomic,strong)PartEntity *part;
@property(nonatomic,assign)NSUInteger countStart;
@property(nonatomic,assign)NSUInteger currentPage;
@end
