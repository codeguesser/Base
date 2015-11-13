//
//  TableViewCell2.h
//  base
//
//  Created by wsg on 15/10/23.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell2 : UITableViewCell{
    
    __weak IBOutlet UILabel *_label3;
    __weak IBOutlet UILabel *_label1;
    __weak IBOutlet UILabel *_label2;
}
@property(nonatomic,assign)BOOL isUpdated;
@property(nonatomic,strong)NSString *str1;
@property(nonatomic,strong)NSString *str2;
@property(nonatomic,strong)NSString *str3;
@end
