//
//  Cell.h
//  base
//
//  Created by wsg on 15/7/19.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UICollectionViewCell{
    
    __weak IBOutlet UIButton *_btDel;
    __weak IBOutlet UIButton *_bt;
}
@property(nonatomic,strong)id data;
@property(nonatomic,copy)void(^delAction)();
@end
