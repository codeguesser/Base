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
#import "CalenderView.h"
#import <Accelerate/Accelerate.h>
@interface ViewControllerPreviewing:UIViewController<UIViewControllerPreviewingDelegate>
@end
@implementation ViewControllerPreviewing

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems{
    UIPreviewAction *p1 =[UIPreviewAction actionWithTitle:@"分享" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"点击了分享");
    }];
    UIPreviewAction *p2 =[UIPreviewAction actionWithTitle:@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"点击了收藏");
    }];
    NSArray *actions = @[p1,p2];
    return actions;
}

@end
@interface TestViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIViewControllerPreviewingDelegate>{
    
    __weak IBOutlet UILabel *_label2;
    __weak IBOutlet UILabel *_label4;
    __weak IBOutlet UILabel *_label1;
    __weak IBOutlet UILabel *_label3;
    __weak IBOutlet UIView *myContentVIew;
    
//    __weak IBOutlet UILabel *_detailLabel;
//    __weak IBOutlet UIButton *_configButton;
//    __weak IBOutlet CalenderView *contentView;
    NSMutableDictionary *dic;
    UIControl *ctrl;
    UIPickerView *pickview;
    NSString *defaultDateRange;
}

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    dic = [NSMutableDictionary new];
    defaultDateRange = @"08:00-18:00";
    
    if (NSClassFromString(@"UITraitCollection")&&[UITraitCollection instancesRespondToSelector:@selector(traitCollectionWithForceTouchCapability:)]&&[UITraitCollection traitCollectionWithForceTouchCapability:UIForceTouchCapabilityAvailable]) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    
    
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"xxxx" style:UIBarButtonItemStylePlain target:self action:@selector(getResult)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"xxxx" style:UIBarButtonItemStylePlain target:self action:@selector(inputData)];
    
    // Do any additional setup after loading the view.
    /*
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
     */
    
    /*
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     UIGraphicsBeginImageContext(contentView.frame.size);
     CGContextRef context = UIGraphicsGetCurrentContext();
     [contentView.layer renderInContext:context];
     UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     UIImage *img = [self accelerateBlurWithImage:sourceImage];
     UIImageView*v = [[UIImageView alloc]initWithFrame:contentView.frame];
     v.image = img;
     v.backgroundColor = [UIColor greenColor];
     v.contentMode = UIViewContentModeScaleToFill;
     [self.view addSubview:v];
     });
     */
    /*
    [dic setValue:@"11:11-19:00" forKey:@"20160325"];
    contentView.outtimeRange = dic;
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeRangeChangeAction:)];
    _detailLabel.userInteractionEnabled = YES;
    [_detailLabel addGestureRecognizer:editTap];
    contentView.changeSelectDateAction = ^(CVDayEntity *day){
        _configButton.tag = day.date.year*10000+day.date.month*100+day.date.day;
        _detailLabel.tag = day.date.year*10000+day.date.month*100+day.date.day;
        if (day.state & CVStateWorkday) {
            NSString *key = [NSString stringWithFormat:@"%ld",(long)_configButton.tag];
            _detailLabel.text = dic[key]?dic[key]:defaultDateRange;
            [_configButton setTitle:@"设置为休息" forState:0];
        }else{
            _detailLabel.text = @"休息";
            [_configButton setTitle:@"设置为考勤" forState:0];
        }
    };
    [_configButton addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
     */
}
/*
-(void)changeStatus:(UIButton *)b{
    contentView.changeSelectDateAction([contentView reverseMarkStatusWithTag:b.tag]);
}
-(void)timeRangeChangeAction:(UITapGestureRecognizer*)sender{
    
    [self showDatePickerWith:dic[[NSString stringWithFormat:@"%ld",(long)_detailLabel.tag]]?dic[[NSString stringWithFormat:@"%ld",(long)_detailLabel.tag]]:defaultDateRange];
}
-(void)showDatePickerWith:(NSString*)date{
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 300)];
    v.backgroundColor = [UIColor whiteColor];
    ctrl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    ctrl.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
    [ctrl addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    
    pickview = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 180)];
    pickview.delegate = self;
    if ([date rangeOfString:@"^(\\d){2}:(\\d){2}-(\\d){2}:(\\d){2}$" options:NSRegularExpressionSearch].length>0) {
        [pickview selectRow:[[[date componentsSeparatedByString:@"-"][0] componentsSeparatedByString:@":"][0] integerValue] inComponent:0 animated:YES];
        [pickview selectRow:[[[date componentsSeparatedByString:@"-"][0] componentsSeparatedByString:@":"][1] integerValue] inComponent:1 animated:YES];
        [pickview selectRow:[[[date componentsSeparatedByString:@"-"][1] componentsSeparatedByString:@":"][0] integerValue] inComponent:3 animated:YES];
        [pickview selectRow:[[[date componentsSeparatedByString:@"-"][1] componentsSeparatedByString:@":"][1] integerValue] inComponent:4 animated:YES];
    }
    
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(-10, 40, SCREEN_WIDTH+20, 40)];
    textlabel.text = @"设置工作时间段 ";
    textlabel.textAlignment = NSTextAlignmentCenter;
    textlabel.textColor = [UIColor darkTextColor];
    textlabel.backgroundColor = [UIColor colorWithWhite:249.0/255 alpha:1];
    textlabel.layer.borderWidth = .8;
    textlabel.layer.borderColor = [UIColor colorWithWhite:221.0/255 alpha:1].CGColor;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 50, 40)];
    [btn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确定" forState:0];
    [btn setTitleColor:[UIColor colorWithRed:39.0/255 green:211.0/255 blue:144.0/255 alpha:1] forState:0];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
    [leftBtn addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"取消" forState:0];
    [leftBtn setTitleColor:[UIColor colorWithRed:39.0/255 green:211.0/255 blue:144.0/255 alpha:1] forState:0];
    UIView *btnview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    btnview.backgroundColor = [UIColor colorWithWhite:238.0/255 alpha:1];
    [v addSubview:btnview];
    [v addSubview:pickview];
    [btnview addSubview:btn];
    [btnview addSubview:leftBtn];
    [v addSubview:textlabel];
    [ctrl addSubview:v];
    [[UIApplication sharedApplication].keyWindow addSubview:ctrl];
}
-(void)getResult{
    NSLog(@"%@",[contentView description]);
}
-(void)inputData{
    [contentView initData:nil];
}
-(void)changeAction{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc]init];
    nf.minimumIntegerDigits = 2;
    NSString *str = [NSString stringWithFormat:@"%@:%@-%@:%@",[nf stringFromNumber:@([pickview selectedRowInComponent:0])],[nf stringFromNumber:@([pickview selectedRowInComponent:1])],[nf stringFromNumber:@([pickview selectedRowInComponent:3])],[nf stringFromNumber:@([pickview selectedRowInComponent:4])]];
    [contentView updateoutTimeWith:str targetTime:_detailLabel.tag standardTime:defaultDateRange];
    _detailLabel.text = str;
    [self controlAction];
}
-(void)controlAction{
    [ctrl removeFromSuperview];
}
*/
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    ViewControllerPreviewing *vc = [[ViewControllerPreviewing alloc] init];
    return vc;
}
#pragma mark - pickview
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0||component==3) return 24;
    if (component==1||component==4) return 60;
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==2) {
        return @"到";
    }else{
        return row<10? [NSString stringWithFormat:@"0%li",(long)row]:[NSString stringWithFormat:@"%li",(long)row];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger a = [pickerView selectedRowInComponent:0];
    NSInteger b = [pickerView selectedRowInComponent:1];
    NSInteger c = [pickerView selectedRowInComponent:3];
    NSInteger d = [pickerView selectedRowInComponent:4];
    void(^selectRow)(NSInteger,NSInteger) = ^(NSInteger row,NSInteger comp) {
        [pickview selectRow:row inComponent:comp animated:YES];
    };
    if(c<=a){
        selectRow(a,3);
        if (b==59) {
            if(a==23){
                selectRow(0,3);
                selectRow(0,4);
            }else{
                selectRow(a+1,3);
                selectRow(0,4);
            }
        }else if(d<=b) {
            selectRow(a,3);
            selectRow(b+1,4);
        }
    }
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
- (UIImage *)accelerateBlurWithImage:(UIImage *)image
{
    /*
     float scare = 0.4;
     UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scare, image.size.height*scare));
     [image drawInRect:CGRectMake(0, 0, image.size.width*scare, image.size.height*scare)];
     UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
     [sourceImage drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
     UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return outputImage;
     */
    NSInteger scare = 5;
    NSInteger boxSize = (NSInteger)(scare * scare);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer, rgbOutBuffer;
    vImage_Error error;
    
    void *pixelBuffer, *convertBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    convertBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    rgbOutBuffer.width = CGImageGetWidth(img);
    rgbOutBuffer.height = CGImageGetHeight(img);
    rgbOutBuffer.rowBytes = CGImageGetBytesPerRow(img);
    rgbOutBuffer.data = convertBuffer;
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    
    if (pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    void *rgbConvertBuffer = malloc( CGImageGetBytesPerRow(img) * CGImageGetHeight(img) );
    vImage_Buffer outRGBBuffer;
    outRGBBuffer.width = CGImageGetWidth(img);
    outRGBBuffer.height = CGImageGetHeight(img);
    outRGBBuffer.rowBytes = 3;
    outRGBBuffer.data = rgbConvertBuffer;
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    const uint8_t mask[] = {2, 1, 0, 3};
    
    vImagePermuteChannels_ARGB8888(&outBuffer, &rgbOutBuffer, mask, kvImageNoFlags);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(rgbOutBuffer.data,
                                             rgbOutBuffer.width,
                                             rgbOutBuffer.height,
                                             8,
                                             rgbOutBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    
    free(pixelBuffer);
    free(convertBuffer);
    free(rgbConvertBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
@end
