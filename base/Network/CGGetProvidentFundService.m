//
//  CGGetProvidentFundService.m
//  base
//
//  Created by wsg on 16/1/11.
//  Copyright © 2016年 wsg. All rights reserved.
//

#import "CGGetProvidentFundService.h"
static UIWebView *serverWebView;
@interface CGGetProvidentFundService()<UIWebViewDelegate>{
    NSString * _webExcuteState;
    NSMutableArray *_datas;
    NSString *_year;
}

@end
@implementation CGGetProvidentFundService
+ (id)service{
    CGGetProvidentFundService *service = [[CGGetProvidentFundService alloc]init];
    return service;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)requestResultWithYear:(NSString *)year completion:(void(^)(NSArray *historyList,NSArray *keys))completion{
    _webExcuteState = @"unload";
    _year = year;
    _datas = [NSMutableArray new];
    if (!serverWebView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
            [[[UIApplication sharedApplication] keyWindow]addSubview:view];
            view.hidden = YES;
            serverWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 10,10)];
            serverWebView.delegate = self;
            [view addSubview:serverWebView];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [serverWebView loadRequest:[NSURLRequest requestWithURL:[NSURL  URLWithString:@"http://www.lyzfgjj.com/zxcx.aspx?userid=%E7%8E%8B%E4%B9%A6%E5%80%8C&sfz=410311199002021538&lmk="]]];
                
                while (![_webExcuteState isEqualToString: @"computed"]) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    serverWebView.delegate = nil;
                    [serverWebView removeFromSuperview];
                    [view removeFromSuperview];
                    if (completion) {
                        completion([self historyList],@[@"序号",@"交易日期",@"业务种类",@"增加金额",@"减少金额",@"账号余额",@"所属年月"]);
                    }
                });
            });
            
        });
    }
}
-(void)testJSContextWithWebView2:(UIWebView *)webView{
    NSString *startDate = [_year stringByAppendingString:@"-01-01"];
    NSString *endDate = [_year stringByAppendingString:@"-12-31"];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"dtpick1\").setAttribute(\"realvalue\",\"%@\");document.getElementById(\"dtpick1\").value = \"%@\";document.getElementById(\"dtpick2\").setAttribute(\"realvalue\",\"%@\");document.getElementById(\"dtpick2\").value = \"%@\";document.getElementById(\"ImageButton1\").click()",startDate,startDate,endDate,endDate]];
    _webExcuteState = @"excuted";
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if([_webExcuteState isEqualToString:@"unload"]){
        _webExcuteState = @"excuting";
        [self testJSContextWithWebView2:webView];
    } else {
        if([_webExcuteState isEqualToString:@"excuted"]){
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
                
                NSRegularExpression *expression3 = [NSRegularExpression regularExpressionWithPattern:@"<td(.*?)class=\"objWebDataWindowControl(.*?)>(.*?)</td>" options:0 error:nil];
                __block int idIndex = 0;
                [expression3 enumerateMatchesInString:webHtml options:0 range:NSMakeRange(0, webHtml.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    if(![[webHtml substringWithRange:[result rangeAtIndex:3]] hasSuffix:@">"]){
                        if (idIndex%7==0) {
                            [_datas addObject:[@{@"0":[webHtml substringWithRange:[result rangeAtIndex:3]]} mutableCopy]];
                        }else{
                            _datas[idIndex/7][[NSString stringWithFormat:@"%d",idIndex%7]] = [webHtml substringWithRange:[result rangeAtIndex:3]];
                        }
                        idIndex++;
                    }
                }];
                
                idIndex = 0;
                
                NSRegularExpression *expression4 = [NSRegularExpression regularExpressionWithPattern:@"<input(.*?)name=\"compute_(.*?)value=\"(.*?)\" class=\"objWebDataWindowControl(.*?)>" options:0 error:nil];
                [expression4 enumerateMatchesInString:webHtml options:0 range:NSMakeRange(0, webHtml.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    if (idIndex%2==0) {
                        _datas[idIndex/2][@"3"] = [webHtml substringWithRange:[result rangeAtIndex:3]];
                    }else{
                        _datas[idIndex/2][@"4"] = [webHtml substringWithRange:[result rangeAtIndex:3]];
                    }
                    idIndex++;
                }];
                _webExcuteState = @"computed";
            }
        }
    }
}
- (NSArray *)historyList{
    if ([_webExcuteState isEqualToString:@"computed"]) {
        return _datas;
    }
    return @[];
}
@end
