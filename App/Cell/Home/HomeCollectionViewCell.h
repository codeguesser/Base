//
//  HomeCollectionViewCell.h
//  base
//
//  Created by wsg on 15/9/6.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemEntity.h"
@interface HomeCollectionViewCell : UICollectionViewCell{
    
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIButton *_coverButton;
}
@property(nonatomic,strong)ItemEntity *data;
@end
