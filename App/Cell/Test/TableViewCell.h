//
//  TableViewCell.h
//  base
//
//  Created by wsg on 15/8/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "CGTableViewCell.h"
@interface TableViewCell : CGTableViewCell{
    __weak IBOutlet UILabel *_label;
    __weak IBOutlet UILabel *_label2;
}
@property(nonatomic,assign)BOOL isUpdated;
@end
