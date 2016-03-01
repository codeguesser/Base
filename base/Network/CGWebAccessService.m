//
//  CGWebAccessService.m
//  base
//
//  Created by wsg on 16/2/29.
//  Copyright © 2016年 wsg. All rights reserved.
//

#import "CGWebAccessService.h"
#import <TesseractOCR/TesseractOCR.h>
@interface CGWebAccessService()<UIWebViewDelegate>{
    dispatch_semaphore_t semaphore ;//实际的等错信号
    dispatch_semaphore_t semaphore1 ;//辅助信号
    UIWebView *_serverWebView;//服务用webview
    NSError *_error;//存储服务端错误
    NSMutableDictionary *_summaryData;//汇总信息
    WebAccessServiceState state;
    NSMutableSet *set;
}
@end
@implementation CGWebAccessService
+ (id)service{
    CGWebAccessService *service = [[CGWebAccessService alloc]init];
    return service;
}
-(void)requestWithCompletion:(void(^)(NSDictionary *otherInfo))completion{
    NSAssert(self.password&&self.cardId, @"请先执行object.password=@\"\"，还有object.cardId=@\"\"");
    set = [NSMutableSet new];
    state = WebAccessServiceStateUnload;
    NSString *urlStr = [[NSString stringWithFormat:@"http://www.haly.lss.gov.cn/BusinessPage/RlzySbj/ZCcxxt/Default.aspx"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL  URLWithString:urlStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view;
        if (!_serverWebView) {
            view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
            [[[UIApplication sharedApplication] keyWindow]addSubview:view];
            view.hidden = YES;
            _serverWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 10,10)];
            _serverWebView.delegate = self;
            [view addSubview:_serverWebView];
        }else{
            view = _serverWebView.superview;
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            semaphore = dispatch_semaphore_create(0);
            [_serverWebView loadRequest:[NSURLRequest requestWithURL:url]];
            dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*30);
            if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
                _error = [NSError errorWithDomain:@"www.haly.lss.gov.cn" code:WebAccessServiceErrorTimeOut userInfo:@{@"msg":@"访问网站自设置timeout超时"}];
                DDLogInfo(@"time out");
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                _serverWebView = nil;
                _serverWebView.delegate = nil;
                [_serverWebView removeFromSuperview];
                [view removeFromSuperview];
                if (completion) {
                    completion(_summaryData);
                }
            });
        });
    });
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *webHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    if (!NSEqualRanges(NSMakeRange(NSNotFound, 0), [webHtml rangeOfString:@"社保信息查询"])) {
        
        NSString *errorMsg = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"ctl00_ctl00_ContentPlaceHolder1_ContentPlaceHolder1_errmsg\").textContent"];
        if ([errorMsg stringByReplacingOccurrencesOfString:@" " withString:@""].length==0) {
            //没有错误数据就代表这是第一次加载
            NSLog(@"1");
            if (state==WebAccessServiceStateUnload) {
                state = WebAccessServiceStateLoad;
            }
            NSInteger oldCount=set.count;
            [set addObject:webView.request];
            if(oldCount != set.count){
                NSLog(@"%lu",webView.request.hash);
                [self askCodeWithWeb:webView];
            }
        }else if([[errorMsg stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"验证码错误，请输入正确的验证码。"]){
            NSLog(@"2");
            if (state==WebAccessServiceStateLoad)[self askCodeWithWeb:webView];
        }else{
            NSLog(@"3");
            DDLogInfo(@"%@",errorMsg);
            dispatch_semaphore_signal(semaphore);
        }
    }else{
//        NSInteger oldCount=set.count;
//        [set addObject:webView.request];
//        if(oldCount != set.count){
//            NSLog(@"%lu",webView.request.hash);
//        }
        NSLog(@"%@",webHtml);
        dispatch_semaphore_signal(semaphore);
    }
}
-(void)askCodeWithWeb:(UIWebView *)webView {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.haly.lss.gov.cn/GetImageCode.aspx"]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *img = [UIImage imageWithData:data];
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];
    
    // Configure inner G8Tesseract object as described before
    operation.tesseract.charWhitelist = @"0123456789ABCDEFGHIGJKLMNOPQRSTUVWXYZ";
    operation.tesseract.charBlacklist = @".,:;'";
    operation.tesseract.image = [img g8_blackAndWhite];
    
    // Setup the recognitionCompleteBlock to receive the Tesseract object
    // after text recognition. It will hold the recognized text.
    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract) {
        // Retrieve the recognized text upon completion
        NSString *code = [[[recognizedTesseract recognizedText] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if (code.length==5) {
            state = WebAccessServiceStateSuccess;
            NSString *javascriptString = [NSString stringWithFormat:@"document.getElementById(\"ctl00_ctl00_ContentPlaceHolder1_ContentPlaceHolder1_ddl_SearchType\").value=\"wzcx_gr\";document.getElementById(\"ctl00_ctl00_ContentPlaceHolder1_ContentPlaceHolder1_t_usercode\").value=%@;document.getElementById(\"ctl00_ctl00_ContentPlaceHolder1_ContentPlaceHolder1_t_password\").value=%@;document.getElementById(\"ctl00_ctl00_ContentPlaceHolder1_ContentPlaceHolder1_txt_valCode\").value=\"%@\";document.getElementsByName(\"ctl00$ctl00$ContentPlaceHolder1$ContentPlaceHolder1$btn_search\")[0].click();",self.cardId,self.password,code];
            DDLogInfo(@"%@",javascriptString);
            [webView stringByEvaluatingJavaScriptFromString:javascriptString];
        }else{
            DDLogInfo(@"%@",code);
            [self askCodeWithWeb:webView];
        }
    };
    
    // Add operation to queue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}
@end
