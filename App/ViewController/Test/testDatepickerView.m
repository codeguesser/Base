//
//  testDatepickerView.m
//  base
//
//  Created by wsg on 15/10/22.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "testDatepickerView.h"

@implementation testDatepickerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        picker.date = [NSDate dateYesterday];
        [self addSubview:picker];
        picker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
        picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_ch"];
        picker.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [NSDateFormatter defaultDateFormatter];
            NSLog(@"%@,%@",[formatter dateFromString:[formatter stringFromDate:picker.date] ],[formatter stringFromDate:picker.date]);
            for (UIView *v in picker.subviews) {
                if ([NSStringFromClass(v.class) isEqualToString:@"_UIDatePickerView"]) {
                    int i=0;
                    for (UIView *v1 in v.subviews.firstObject.subviews) {
                        if (i==0) {
                            
                        }else{
                            [v1 removeFromSuperview];
                        }
                        i++;
                    }
                }
            }
            picker.hidden = NO;
        });
    }
    return self;
}
@end
