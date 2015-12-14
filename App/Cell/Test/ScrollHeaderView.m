//
//  ScrollHeaderView.m
//  base
//
//  Created by wsg on 15/12/9.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "ScrollHeaderView.h"
@interface ScrollHeaderView()<UIScrollViewDelegate>{
    NSMutableArray *_subImageViews;
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIPageControl *_pageControl;
}
@end
@implementation ScrollHeaderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [NSTimer scheduledTimerWithTimeInterval: 3
                                                          target: self
                                                        selector: @selector(incrementCounter:)
                                                        userInfo: nil
                                                         repeats: YES];
        self.clipsToBounds = YES;
        _subImageViews = [NSMutableArray new];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.images&&self.images.count>0&&[self.images[0] isKindOfClass:[UIImage class]]) {
                [self setupSubviews];
            }
            
        });
    }
    return self;
}
-(void)setupSubviews{
    [self.images enumerateObjectsUsingBlock:^(UIImage * img, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(idx*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = img;
        [_scrollView addSubview:imgView];
        imgView.userInteractionEnabled = NO;
        [_subImageViews addObject:imgView];
    }];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width*self.images.count, self.frame.size.height);
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = self.images.count;
}
- (IBAction)changePage:(UIPageControl *)sender {
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*sender.currentPage, 0) animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = ceilf(scrollView.contentOffset.x/scrollView.frame.size.width);
    _pageControl.currentPage = page;
    
}
- (void)incrementCounter:(NSTimer *)theTimer
{
    long targetPage = _pageControl.currentPage+1;
    if (targetPage==_pageControl.numberOfPages) {
        targetPage = 0;
    }
    _pageControl.currentPage = targetPage;
    [self changePage:_pageControl];
}
@end
