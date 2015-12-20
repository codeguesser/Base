//
//  CGWebViewHeightService.m
//  base
//
//  Created by wsg on 15/12/19.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "CGGetWebpageHeightService.h"

static UIWebView *serverWebView;
@interface WebHeightOperation : NSOperation<UIWebViewDelegate>
@property(nonatomic,strong)NSString *html;
@property(nonatomic,assign)CGSize size;
@property(nonatomic,strong)NSNumber *tag;
@property(nonatomic,strong)NSNumber *height;
@end
@implementation WebHeightOperation
@synthesize finished,executing;
- (instancetype)init
{
    self = [super init];
    if (self) {
        finished = NO;
        executing = NO;
    }
    return self;
}
-(void)main{
    dispatch_async(dispatch_get_main_queue(), ^{
        serverWebView.frame = CGRectMake(0, 0, self.size.width, self.size.height);
        serverWebView.delegate = self;
        [serverWebView loadHTMLString:_html baseURL:nil];
        serverWebView.tag = self.tag.integerValue;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        });
    });
}
-(void)start{
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}
- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    NSString *str = [webView stringByEvaluatingJavaScriptFromString: @"getBodyHeight()"];
    frame.size = CGSizeMake(frame.size.width, [str floatValue]);
    webView.frame = frame;
    self.height = @(webView.scrollView.contentSize.height);
    NSLog(@"%@",self.height);
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@",self.height];
}
@end
@interface CGGetWebpageHeightService()<UIWebViewDelegate>{
    NSOperationQueue *_queue;
    NSMutableArray *_taskList;
}
@end
@implementation CGGetWebpageHeightService
- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        [[[UIApplication sharedApplication] keyWindow]addSubview:view];
        view.hidden = YES;
        
        if(!serverWebView){
            serverWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
            serverWebView.delegate = self;
            
            [view addSubview:serverWebView];
        }
        _queue = [NSOperationQueue mainQueue];
        _taskList = [NSMutableArray new];
        
    }
    return self;
}
-(void)setHtmls:(NSArray<NSString *> *)htmls{
    _htmls = htmls;
    [self addAllTask];
}
-(void)addAllTask{
    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate]*1000;
    NSTimeInterval index = 0;
    for (NSString *s in self.htmls) {
        index++;
        WebHeightOperation *who = [[WebHeightOperation alloc]init];
        who.html = s;
        who.tag = @(time+index);
        who.size = self.size;
        who.height = @0;
        [_taskList addObject:who];
        [_queue addOperation:who];
        if (index==self.htmls.count-1) {
            [who setCompletionBlock:^{
                BOOL isAllSuccessed = YES;
                for (WebHeightOperation *who in _taskList) {
                    if (!who.isFinished) {
                        isAllSuccessed = NO;
                    }
                }
                if (isAllSuccessed) {
                    self.finishLoading(_taskList);
                }
            }];
        }
    }
}

@end
