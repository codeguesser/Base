//
//  TestImageMemoryViewController.m
//  base
//
//  Created by wsg on 15/12/28.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "TestImageMemoryViewController.h"

@interface TestImageMemoryViewController (){
    NSMutableArray *imgs;
    __weak IBOutlet UIImageView *imageView;
    NSInteger index;
    dispatch_source_t timer;
}

@end

@implementation TestImageMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    imgs = [NSMutableArray new];
    [imgs addObjectsFromArray:@[@"myimage.jpeg",@"phone1@3x.png",@"phone2@3x.png",@"phone3@3x.png"]];
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgs[index] ofType:nil]];
        index++;
        if (index==imgs.count) {
            index = 0;
        }
    });
    dispatch_resume(timer);
    
    
    
    /*!
     @brief 拷贝用的menu
     */
    
    
    imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [imageView addGestureRecognizer:press];
    
}
-(void)longPressAction:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:CGRectMake(0, 0, 200, 200) inView:imageView];
        [menu setMenuItems:@[[[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyAction:)]]];
        [menu setMenuVisible:YES animated:YES];
    }
    
}
-(void)copyAction:(UIMenuItem *)item{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
@end
