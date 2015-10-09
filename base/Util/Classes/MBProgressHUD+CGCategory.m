//
//  MBProgressHUD+CGCategory.m
//  base
//
//  Created by wsg on 15/7/30.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "MBProgressHUD+CGCategory.h"
/*!
 @author wangshuguan, 15-08-03 12:08:25
 
 @brief  简略版的显示弹框
 
 @param s 弹框的提示文字
 */
inline void ShowMessage(NSString * s){
    [NSObject showMessageOnWindowWithText:s];
}
@implementation NSObject(MBProgressHUD)
/*!
 @author wangshuguan, 15-08-03 12:08:57
 
 @brief  任何地方加上弹框
 
 @param text 弹框的提示文字
 */
-(void)showMessageOnWindowWithText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication]keyWindow] animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.labelText = text;
    hud.color = [UIColor blueColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [hud hide:YES afterDelay:3];
}
/*!
 @author wangshuguan, 15-08-03 12:08:14
 
 @brief  任何地方加上弹框
 
 @param text 弹框的提示文字
 */
+(void)showMessageOnWindowWithText:(NSString *)text{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication]keyWindow] animated:YES];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.labelText = text;
    hud.color = [UIColor blueColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [hud hide:YES afterDelay:.5];
}

@end
