//
//  CGWebAccessService.m
//  base
//
//  Created by wsg on 16/2/29.
//  Copyright © 2016年 wsg. All rights reserved.
//

#import "CGWebAccessService.h"
@interface CGWebAccessService()<UIWebViewDelegate>{
    dispatch_semaphore_t semaphore ;//实际的等错信号
    dispatch_semaphore_t semaphore1 ;//辅助信号
    UIWebView *_serverWebView;//服务用webview
    NSError *_error;//存储服务端错误
    NSMutableDictionary *_summaryData;//汇总信息
    int countOfReading;
}
@end
@implementation CGWebAccessService
+ (id)service{
    CGWebAccessService *service = [[CGWebAccessService alloc]init];
    return service;
}
-(void)requestWithCompletion:(void(^)(NSDictionary *otherInfo))completion{
    countOfReading = 0;
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
            dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*130);
            if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
                _error = [NSError errorWithDomain:@"www.lyzfgjj.com" code:WebAccessServiceErrorTimeOut userInfo:@{@"msg":@"访问网站自设置timeout超时"}];
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
            countOfReading++;
            if (countOfReading==1) {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.haly.lss.gov.cn/GetImageCode.aspx"]];
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                UIImage *img = [UIImage imageWithData:data];
                NSString *code = @"qq";
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"ctl00_ctl00_ContentPlaceHolder1_ContentPlaceHolder1_ddl_SearchType\").value=\"wzcx_gr\";document.getElementById(\"ctl00_ctl00_ContentPlaceHolder1_ContentPlaceHolder1_t_usercode\").value=41039931846206;document.getElementById(\"ctl00_ctl00_ContentPlaceHolder1_ContentPlaceHolder1_t_password\").value=19900202;document.getElementById(\"ctl00_ctl00_ContentPlaceHolder1_ContentPlaceHolder1_txt_valCode\").value=\"%@\";document.getElementsByName(\"ctl00$ctl00$ContentPlaceHolder1$ContentPlaceHolder1$btn_search\")[0].click();",code]];
            }
        }else{
            //这是第二次加载
            DDLogInfo(@"%@",errorMsg);
        }
        
        
        
        
        
//        NSString *errorMsg = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"ul\")[0].childNodes[1].textContent"];
//        _error = [NSError errorWithDomain:@"www.lyzfgjj.com" code:WebAccessServiceErrorAnalyse userInfo:@{@"msg":errorMsg}];
//        dispatch_semaphore_signal(semaphore);
    }else{
        NSLog(@"%@",webHtml);
    }
    
//    if (!NSEqualRanges(NSMakeRange(NSNotFound, 0), [webHtml rangeOfString:@"操作失败信息"])) {
//        NSString *errorMsg = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"ul\")[0].childNodes[1].textContent"];
//        _error = [NSError errorWithDomain:@"www.lyzfgjj.com" code:ProvidentFundServiceErrorAnalyse userInfo:@{@"msg":errorMsg}];
//        dispatch_semaphore_signal(semaphore);
//        self.webExcuteState = @"computed";
//    }

//    if([self.webExcuteState isEqualToString:@"unload"]){
//        //第一次，未曾执行javascript进行查询的时候，这时需要去执行并进行查询
//        //检验是否获取到正确的账号和名字配对
//        NSString *webHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//        if (!NSEqualRanges(NSMakeRange(NSNotFound, 0), [webHtml rangeOfString:@"操作失败信息"])) {
//            NSString *errorMsg = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"ul\")[0].childNodes[1].textContent"];
//            _error = [NSError errorWithDomain:@"www.lyzfgjj.com" code:ProvidentFundServiceErrorAnalyse userInfo:@{@"msg":errorMsg}];
//            dispatch_semaphore_signal(semaphore);
//            self.webExcuteState = @"computed";
//        }
//        [self excuteScriptToGetDataWithWebView:webView];
//    } else {
//        //当目标代码被执行之后，进行的html获取，这时实际上获取到的值
//        NSString *webHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//        [self analyseDataWithOriginHtml:webHtml];
//    }
}
@end
