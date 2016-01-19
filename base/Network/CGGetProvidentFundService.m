//
//  CGGetProvidentFundService.m
//  base
//
//  Created by wsg on 16/1/11.
//  Copyright © 2016年 wsg. All rights reserved.
//

#import "CGGetProvidentFundService.h"
#define kCGGetProvidentFundServiceKeys @[@"序号",@"交易日期",@"业务种类",@"增加金额",@"减少金额",@"账号余额",@"所属年月"]
static UIWebView *serverWebView;
@interface CGGetProvidentFundService()<UIWebViewDelegate>{
    NSString * _webExcuteState;//web的执行状态   unload （excuted excuting stillExcuting） computed
    NSMutableArray *_datas;//最终获取的全部数据
    NSMutableDictionary *_summaryData;//汇总信息
    NSString *_startDate;//开始日期
    NSString *_endDate;//结束日期
    dispatch_semaphore_t semaphore ;
}

@end
@implementation CGGetProvidentFundService
+ (id)service{
    CGGetProvidentFundService *service = [[CGGetProvidentFundService alloc]init];
    return service;
}
-(void)requestResultWithYear:(NSString *)year completion:(void(^)(NSArray *historyList,NSArray *keys,NSDictionary* otherInfo))completion{
    
    NSAssert(self.name&&self.cardId, @"请先执行object.name=@\"\"，还有object.cardId=@\"\"");

    _webExcuteState = @"unload";
    _summaryData = [NSMutableDictionary new];
    _startDate = [year stringByAppendingString:@"-01-01"];
    _endDate = [year stringByAppendingString:@"-12-31"];
    _datas = [NSMutableArray new];
    NSString *urlStr = [[NSString stringWithFormat:@"http://www.lyzfgjj.com/zxcx.aspx?userid=%@&sfz=%@&lmk=",self.name,self.cardId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL  URLWithString:urlStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view;
        if (!serverWebView) {
            view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
            [[[UIApplication sharedApplication] keyWindow]addSubview:view];
            view.hidden = YES;
            serverWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 10,10)];
            serverWebView.delegate = self;
            [view addSubview:serverWebView];
        }else{
            view = serverWebView.superview;
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            semaphore = dispatch_semaphore_create(0);
            [serverWebView loadRequest:[NSURLRequest requestWithURL:url]];
            dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*10);
            if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
                DDLogInfo(@"time out");
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                serverWebView = nil;
                serverWebView.delegate = nil;
                [serverWebView removeFromSuperview];
                [view removeFromSuperview];
                if (completion) {
                    completion([self historyList],kCGGetProvidentFundServiceKeys,_summaryData);
                }
            });
        });
    });
}
-(void)testJSContextWithWebView2:(UIWebView *)webView withStartDate:(NSString *)startDate endDate:(NSString *)endDate{
    //关键脚本，用于查询记录
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"dtpick1\").setAttribute(\"realvalue\",\"%@\");document.getElementById(\"dtpick1\").value = \"%@\";document.getElementById(\"dtpick2\").setAttribute(\"realvalue\",\"%@\");document.getElementById(\"dtpick2\").value = \"%@\";document.getElementById(\"ImageButton1\").click()",startDate,startDate,endDate,endDate]];
    _webExcuteState = @"excuted";
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if([_webExcuteState isEqualToString:@"unload"]){
        //第一次，未曾执行javascript进行查询的时候，这时需要去执行并进行查询
        //检验是否获取到正确的账号和名字配对
        NSString *webHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        if (!NSEqualRanges(NSMakeRange(NSNotFound, 0), [webHtml rangeOfString:@"操作失败信息"])) {
            dispatch_semaphore_signal(semaphore);
            _webExcuteState = @"computed";
        }
        [self excuteScriptToGetDataWithWebView:webView];
    } else {
        //当目标代码被执行之后，进行的html获取，这时实际上获取到的值
        NSString *webHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        [self analyseDataWithOriginHtml:webHtml];
    }
}
- (NSArray *)historyList{
    if ([_webExcuteState isEqualToString:@"computed"]) {
        return _datas;
    }
    return @[];
}
-(void)analyseDataWithOriginHtml:(NSString *)webHtml{
    if (!NSEqualRanges(NSMakeRange(NSNotFound, 0), [webHtml rangeOfString:@"objWebDataWindowControl1_datawindow"])) {
        
        int pageCount = [serverWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"option\").length"].intValue;
        if (pageCount<=1) {
            //数据已经是最后一页，完全结束
            [_datas addObjectsFromArray:[self filterExistedDataWithData:[self analyseDataWithoutJudge:webHtml]]];
            _webExcuteState = @"computed";
            dispatch_semaphore_signal(semaphore);
        } else{
            _webExcuteState = @"stillExcuting";
            //数据不是最后一页，需要进行下一次的数据解析
            NSArray *tempArr = [self analyseDataWithoutJudge:webHtml];
            //开始时间不变，更改结束时间，减少数据的返回数量，理论上不存在数据记录完全一致的record，暂时以此作为原始动力
            if ([tempArr lastObject][@"1"]) {
                if((![[tempArr lastObject][@"1"] isEqualToString:[_datas lastObject][@"1"]])||(![[tempArr lastObject][@"5"] isEqualToString:[_datas lastObject][@"5"]])){
                    [_datas addObjectsFromArray:[self filterExistedDataWithData:[self analyseDataWithoutJudge:webHtml]]];
                    _endDate = [_datas lastObject][@"1"];//实际上是kCGGetProvidentFundServiceKeys中的第1个对象，也就是交易日期，根据最后一个交易日期来压缩获取到的数据列表
                    [self testJSContextWithWebView2:serverWebView withStartDate:_startDate endDate:_endDate];
                }
            }
        }
    }
}
-(NSArray *)analyseDataWithoutJudge:(NSString *)webHtml{
    NSMutableArray *arr = [NSMutableArray new];
    webHtml = [[webHtml stringByReplacingOccurrencesOfString:@"\r\n" withString:@""]  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSRegularExpression *expression1 = [NSRegularExpression regularExpressionWithPattern:@"<tr>(.*?)</tr>"
                                                                                 options:0
                                                                                   error:nil];
    [expression1 enumerateMatchesInString:webHtml options:0 range:NSMakeRange(0, webHtml.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        NSString *targetStr2 = [webHtml substringWithRange:[result rangeAtIndex:1]];
        NSRegularExpression *expression2 = [NSRegularExpression regularExpressionWithPattern:@"<td(.*?)>(.*?)</td>(.*?)<td(.*?)<span id=\"Label(.*?)>(.*?)</span>(.*?)</td>" options:0 error:nil];
        [expression2 enumerateMatchesInString:targetStr2 options:0 range:NSMakeRange(0, targetStr2.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            NSString *key = [[targetStr2 substringWithRange:[result rangeAtIndex:2]] stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *value = [[targetStr2 substringWithRange:[result rangeAtIndex:6]] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (key&&value&&key.length>0&&value.length>0) {
                _summaryData[key]=value;
            }
        }];
    }];
    
    NSRegularExpression *expression3 = [NSRegularExpression regularExpressionWithPattern:@"<td(.*?)class=\"objWebDataWindowControl(.*?)>(.*?)</td>" options:0 error:nil];
    __block int idIndex = 0;
    [expression3 enumerateMatchesInString:webHtml options:0 range:NSMakeRange(0, webHtml.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if(![[webHtml substringWithRange:[result rangeAtIndex:3]] hasSuffix:@">"]){
            if (idIndex%7==0) {
                [arr addObject:[@{@"0":[webHtml substringWithRange:[result rangeAtIndex:3]]} mutableCopy]];
            }else{
                arr[idIndex/7][[NSString stringWithFormat:@"%d",idIndex%7]] = [webHtml substringWithRange:[result rangeAtIndex:3]];
            }
            idIndex++;
        }
    }];
    
    idIndex = 0;
    
    NSRegularExpression *expression4 = [NSRegularExpression regularExpressionWithPattern:@"<input(.*?)name=\"compute_(.*?)value=\"(.*?)\" class=\"objWebDataWindowControl(.*?)>" options:0 error:nil];
    [expression4 enumerateMatchesInString:webHtml options:0 range:NSMakeRange(0, webHtml.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (idIndex%2==0) {
            arr[idIndex/2][@"3"] = [webHtml substringWithRange:[result rangeAtIndex:3]];
        }else{
            arr[idIndex/2][@"4"] = [webHtml substringWithRange:[result rangeAtIndex:3]];
        }
        idIndex++;
    }];
    return arr;
}
-(NSArray *)filterExistedDataWithData:(NSArray *)arr{
    if ([_datas count]>0) {
        NSMutableArray *arrNew = [NSMutableArray new];
        NSMutableSet *checkSet = [NSMutableSet new];
        for (int i=(int)arr.count-12; i<arr.count; i++) {
            NSDictionary *dic = arr[i];
            [checkSet addObject:[NSString stringWithFormat:@"%@%@",dic[@"1"],dic[@"5"]]];
            if (checkSet.count>arrNew.count) {
                [arrNew addObject:dic];
            }
        }
        return arrNew;
    }
    return arr;
}
-(void)excuteScriptToGetDataWithWebView:(UIWebView *)webView{
    _webExcuteState = @"excuting";
    [self testJSContextWithWebView2:webView withStartDate:_startDate endDate:_endDate];
}
-(void)dealloc{
    [serverWebView stopLoading];
    [serverWebView removeFromSuperview];
    [serverWebView.superview removeFromSuperview];
    serverWebView = nil;
    serverWebView.delegate = nil;
}
@end
