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
    //    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL  URLWithString:@"http://dongbenmall.2dian.cc:81/mobile/"]]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    [_webView loadHTMLString:[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
}
/*
 -(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
 resultView.hidden = NO;
 }
 -(void)webViewDidStartLoad:(UIWebView *)webView{
 resultView.hidden = YES;
 }
 */

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"webShell"] = self;
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"mm":@"xx"} options:0 error:nil];
    [context evaluateScript:[NSString stringWithFormat:@"show(%@)",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]]];
    
}
-(void)log:(NSString *)txt{
    
}
@end
