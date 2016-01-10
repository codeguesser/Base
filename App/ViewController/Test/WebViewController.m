//
//  WebViewController.m
//  base
//
//  Created by wsg on 15/8/12.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "WebViewController.h"
#import <NJKWebViewProgress.h>
#import <NJKWebViewProgressView.h>
@import JavaScriptCore;
#import "ContactViewController.h"
#import "CGNetwork.h"
@protocol TESTPROTO <JSExport>
-(void)log:(NSString *)txt;
@end
@interface WebViewController ()<UIWebViewDelegate,TESTPROTO>{
    NJKWebViewProgress *_progressProxy;
    NJKWebViewProgressView *_progressView;
    __weak IBOutlet UIWebView *_webView;
    __weak IBOutlet NSLayoutConstraint *_layout;
    NSString * webExcuteState;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @" web 测试页";
    //    [self addProgressView];
    [self startLoadWeb];
    _webView.delegate = self;
    webExcuteState = @"unload";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightItemClicked:)];
}
-(void)addProgressView{
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    _progressView = [[NJKWebViewProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    __weak NJKWebViewProgressView* progressView = _progressView;
    _webView.delegate = _progressProxy;
    progressView.hidden = YES;
    [progressView setProgress:0 animated:NO];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressBlock = ^(float progress) {
        progressView.hidden = NO;
        [progressView setProgress:progress animated:YES];
        
    };
    [_webView addSubview:_progressView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)rightItemClicked:(UIBarButtonItem *)item{
    
    if (![CGNetworkConnect isClassRegisted]) {
        [CGNetworkConnect registerClass:[CGNetworkConnect class]];
    }else{
        [CGNetworkConnect unregisterClass:[CGNetworkConnect class]];
    }
    //    [self transformViewControllerWithMethod:ITransformMethodPush fromController:self.navigationController targetController:[ContactViewController new]];
}
-(IBAction)startLoadWeb{
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL  URLWithString:@"http://www.lyzfgjj.com/zxcx.aspx?userid=%E7%8E%8B%E4%B9%A6%E5%80%8C&sfz=410311199002021538&lmk="]]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
//    [_webView loadHTMLString:[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
}

/*
 -(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
 resultView.hidden = NO;
 }
 -(void)webViewDidStartLoad:(UIWebView *)webView{
 resultView.hidden = YES;
 }
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if([webExcuteState isEqualToString:@"unload"]){
        webExcuteState = @"excuting";
        [self testJSContextWithWebView2:webView];
    } else {
        if([webExcuteState isEqualToString:@"excuted"]){
            NSString *webHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
            if (!NSEqualRanges(NSMakeRange(NSNotFound, 0), [webHtml rangeOfString:@"objWebDataWindowControl1_datawindow"])) {
                webHtml = [[webHtml stringByReplacingOccurrencesOfString:@"\r\n" withString:@""]  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                NSRegularExpression *expression1 = [NSRegularExpression regularExpressionWithPattern:@"<tr>(.*?)</tr>"
                                                                                             options:0
                                                                                               error:nil];
                [expression1 enumerateMatchesInString:webHtml options:0 range:NSMakeRange(0, webHtml.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    
                    NSString *targetStr2 = [webHtml substringWithRange:[result rangeAtIndex:1]];
                    NSRegularExpression *expression2 = [NSRegularExpression regularExpressionWithPattern:@"<td(.*?)>(.*?)</td>(.*?)<td(.*?)<span id=\"Label(.*?)>(.*?)</span>(.*?)</td>" options:0 error:nil];
                    [expression2 enumerateMatchesInString:targetStr2 options:0 range:NSMakeRange(0, targetStr2.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                        DDLogInfo(@"======%@,%@",[[targetStr2 substringWithRange:[result rangeAtIndex:2]] stringByReplacingOccurrencesOfString:@" " withString:@""],[[targetStr2 substringWithRange:[result rangeAtIndex:6]] stringByReplacingOccurrencesOfString:@" " withString:@""]);
                    }];
                }];
//                DDLogInfo(@"%@",webHtml);
                
                NSRegularExpression *expression3 = [NSRegularExpression regularExpressionWithPattern:@"<td valign=\"TOP\"><input type=\"text\"(.*?)value=\"(.*?)\"(.*?)</td>"
                                                                                             options:0
                                                                                               error:nil];
                [expression3 enumerateMatchesInString:webHtml options:0 range:NSMakeRange(0, webHtml.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    NSLog(@"%@",[webHtml substringWithRange:[result rangeAtIndex:2]]);
                }];
                
                webExcuteState = @"computed";
            }
        }
    }
}
-(void)testJSContextWithWebView2:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"ImageButton1\").click()"];
    webExcuteState = @"excuted";
}
-(void)testJSContextWithWebView:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"webShell"] = self;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"mm":@"xx"} options:0 error:nil];
    [context evaluateScript:[NSString stringWithFormat:@"show(%@)",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]]];
}
-(void)log:(NSString *)txt{
    
}
@end
