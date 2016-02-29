//
//  TestViewController.m
//  base
//
//  Created by wsg on 15/9/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "TestViewController.h"
#import "LoadingView.h"
#import "testDatepickerView.h"
#import "StarView.h"
#import <AdSupport/AdSupport.h>
@interface TestViewController (){
    
    __weak IBOutlet UILabel *_label2;
    __weak IBOutlet UILabel *_label4;
    __weak IBOutlet UILabel *_label1;
    __weak IBOutlet UILabel *_label3;
    __weak IBOutlet UIView *myContentVIew;
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:[[testDatepickerView alloc] initWithFrame:CGRectMake(0, 0, 160, 320)]];
    
    
    //被证明如果想要使用systemLayoutSizeFittingSize来获取高度，必须让最后一个对象启用bottom的
    _label4.text = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
    NSLog(@"%@",[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]);
    _label1.text = @"阿里；弗拉德科夫";
    _label2.text = @"阿里；弗拉德科夫阿里；弗拉德科夫阿里；弗拉德科夫阿里；弗拉德科夫阿里；弗拉德科夫阿里；弗拉德科夫";
    _label3.text = @"第二";
    [_label1 layoutIfNeeded];
    [_label1 setNeedsLayout];
    [_label2 layoutIfNeeded];
    [_label2 setNeedsLayout];
    [_label3 layoutIfNeeded];
    [_label3 setNeedsLayout];
    float height = [myContentVIew systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"%f",height);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5f animations:^{
            myContentVIew.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:.5f animations:^{
                
                myContentVIew.transform = CGAffineTransformIdentity;
            }];
        }];
    });
}
//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
//    CGContextSetLineWidth(ctx, 10.0f);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextStrokeEllipseInRect(ctx, layer.bounds);
//}
/*!
 @brief 星星控件的使用
 */
-(void)setupStarDemo{
    StarView *starView = [[StarView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    starView.imgUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"名片icon4" ofType:@"png"]];
    starView.count = 9;
    starView.progress = 0.5;
    starView.userInteractionEnabled = NO;
    starView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:starView];

}
/*!
 @brief 重置光标
 */
-(void)setupSelectionMarkDemo{
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(10, 30, 200, 55)];
    field.backgroundColor = [UIColor greenColor];
    [self.view addSubview:field];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [field setSelectedTextRange:[field textRangeFromPosition:[field beginningOfDocument] toPosition:[field beginningOfDocument]]];
    });

}
/*!
 @brief 测试加载视图
 */
-(void)testLoadingView{
    
    LoadingView *view = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:view];
    view.center = self.view.center;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.delegate = self;
    [view.layer addSublayer:layer];
    [layer display];
}
@end
