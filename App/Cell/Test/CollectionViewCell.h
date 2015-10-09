//
//  CollectionViewCell.h
//  base
//
//  Created by wsg on 15/6/30.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell{
    
    __weak IBOutlet UIButton *_btDel;
    __weak IBOutlet UIImageView *_imgBackground;
    __weak IBOutlet UIImageView *_img;
}
@property(nonatomic,strong)void(^deleteAction)();
@property(nonatomic,strong)id data;
-(UIView *)copiedView;
@end
