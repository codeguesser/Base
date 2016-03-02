//
//  CGGetProvidentFundService.m
//  base
//
//  Created by wsg on 16/1/11.
//  Copyright © 2016年 wsg. All rights reserved.
//

#import "CGGetProvidentFundService.h"
#define kCGGetProvidentFundServiceKeys @[@"序号",@"交易日期",@"业务种类",@"增加金额",@"减少金额",@"账号余额",@"所属年月"]

#define K_SERVICE_WAIT_TIME 5
#define K_SERVICE_TIME_OUT [[[UIDevice currentDevice] systemVersion]compare:@"8.0"]==NSOrderedAscending?10+K_SERVICE_WAIT_TIME:10

@interface CGGetProvidentFundService()<UIWebViewDelegate>{
    
    NSMutableArray *_datas;//最终获取的全部数据
    NSMutableDictionary *_summaryData;//汇总信息
    NSString *_startDate;//开始日期
    NSString *_endDate;//结束日期
    dispatch_semaphore_t semaphore ;//实际的等错信号
    dispatch_semaphore_t semaphore1 ;//辅助信号
    UIWebView *_serverWebView;//服务用webview
    NSError *_error;//存储服务端错误
}
@property(nonatomic,strong)NSString *webExcuteState;
@end
@implementation CGGetProvidentFundService
#pragma mark - system methods
+ (id)service{
    CGGetProvidentFundService *service = [[CGGetProvidentFundService alloc]init];
    return service;
}
-(void)setWebExcuteState:(NSString *)webExcuteState{
    _webExcuteState = webExcuteState;
    DDLogInfo(@"%@",_webExcuteState);
}
-(void)dealloc{
    [_serverWebView stopLoading];
    [_serverWebView removeFromSuperview];
    [_serverWebView.superview removeFromSuperview];
    _serverWebView = nil;
    _serverWebView.delegate = nil;
}

#pragma mark - public methods
-(NSDictionary *)syncRequestResultWithYear:(NSString *)year{
    NSAssert(![[NSThread currentThread] isMainThread], @"请在多线程下使用该方法");
    NSAssert(self.name&&self.cardId, @"请先执行object.name=@\"\"，还有object.cardId=@\"\"");
    
    self.webExcuteState = @"unload";
    _summaryData = [NSMutableDictionary new];
    _startDate = [year stringByAppendingString:@"-01-01"];
    _endDate = [year stringByAppendingString:@"-12-31"];
    _datas = [NSMutableArray new];
    NSString *urlStr = [[NSString stringWithFormat:@"http://www.lyzfgjj.com/zxcx.aspx?userid=%@&sfz=%@&lmk=",self.name,self.cardId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL  URLWithString:urlStr];
    semaphore1 = dispatch_semaphore_create(0);
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
            dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*10);
            if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
                _error = [NSError errorWithDomain:@"www.lyzfgjj.com" code:ProvidentFundServiceErrorTimeOut userInfo:@{@"msg":@"访问网站自设置timeout超时"}];
                DDLogInfo(@"time out1");
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                _serverWebView = nil;
                _serverWebView.delegate = nil;
                [_serverWebView removeFromSuperview];
                [view removeFromSuperview];
                
                dispatch_semaphore_signal(semaphore1);
            });
        });
    });
    if (dispatch_semaphore_wait(semaphore1, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*20))) {
        _error = [NSError errorWithDomain:PROJECT_CANNEL code:ProvidentFundServiceErrorTimeOut2 userInfo:@{@"msg":@"异常超时"}];
        DDLogInfo(@"time out2");
    }
//    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"history" ofType:@"plist"]];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"summary" ofType:@"plist"]];
    return _error?@{@"history":[self historyList],@"keys":kCGGetProvidentFundServiceKeys,@"summary":_summaryData,@"error":_error}:@{@"history":[self historyList],@"keys":kCGGetProvidentFundServiceKeys,@"summary":_summaryData};
}
-(void)asyncRequestResultWithYear:(NSString *)year completion:(void(^)(NSArray *historyList,NSArray *keys,NSDictionary *otherInfo,NSError *error))completion{
    NSAssert(self.name&&self.cardId, @"请先执行object.name=@\"\"，还有object.cardId=@\"\"");
    
    self.webExcuteState = @"unload";
    _summaryData = [NSMutableDictionary new];
    _startDate = [year stringByAppendingString:@"-01-01"];
    _endDate = [year stringByAppendingString:@"-12-31"];
    _datas = [NSMutableArray new];
    NSString *urlStr = [[NSString stringWithFormat:@"http://www.lyzfgjj.com/zxcx.aspx?userid=%@&sfz=%@&lmk=",self.name,self.cardId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            int time = K_SERVICE_TIME_OUT;
            dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*time);
            if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
                _error = [NSError errorWithDomain:@"www.lyzfgjj.com" code:ProvidentFundServiceErrorTimeOut userInfo:@{@"msg":@"访问网站自设置timeout超时"}];
                DDLogInfo(@"time out");
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                _serverWebView = nil;
                _serverWebView.delegate = nil;
                [_serverWebView removeFromSuperview];
                [view removeFromSuperview];
                if (completion) {
                    completion([self historyList],kCGGetProvidentFundServiceKeys,_summaryData,_error);
                }
            });
        });
    });
}
-(void)requestResultWithYear:(NSString *)year completion:(void(^)(NSArray *historyList,NSArray *keys,NSDictionary* otherInfo))completion{
    
    NSAssert(self.name&&self.cardId, @"请先执行object.name=@\"\"，还有object.cardId=@\"\"");

    self.webExcuteState = @"unload";
    _summaryData = [NSMutableDictionary new];
    _startDate = [year stringByAppendingString:@"-01-01"];
    _endDate = [year stringByAppendingString:@"-12-31"];
    _datas = [NSMutableArray new];
    NSString *urlStr = [[NSString stringWithFormat:@"http://www.lyzfgjj.com/zxcx.aspx?userid=%@&sfz=%@&lmk=",self.name,self.cardId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*10);
            if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
                _error = [NSError errorWithDomain:@"www.lyzfgjj.com" code:ProvidentFundServiceErrorTimeOut userInfo:@{@"msg":@"访问网站自设置timeout超时"}];
                DDLogInfo(@"time out");
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                _serverWebView = nil;
                _serverWebView.delegate = nil;
                [_serverWebView removeFromSuperview];
                [view removeFromSuperview];
                if (completion) {
                    completion([self historyList],kCGGetProvidentFundServiceKeys,_summaryData);
                }
            });
        });
    });
}

- (NSArray *)historyList{
    if ([self.webExcuteState isEqualToString:@"computed"]) {
        return _datas;
    }
    return @[];
}
#pragma mark - private methods
-(void)testJSContextWithWebView2:(UIWebView *)webView withStartDate:(NSString *)startDate endDate:(NSString *)endDate{
    //关键脚本，用于查询记录
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"dtpick1\").setAttribute(\"realvalue\",\"%@\");document.getElementById(\"dtpick1\").value = \"%@\";document.getElementById(\"dtpick2\").setAttribute(\"realvalue\",\"%@\");document.getElementById(\"dtpick2\").value = \"%@\";document.getElementById(\"ImageButton1\").click()",startDate,startDate,endDate,endDate]];
    self.webExcuteState = @"excuted";
}
-(void)analyseDataWithOriginHtml:(NSString *)webHtml{
    if (!NSEqualRanges(NSMakeRange(NSNotFound, 0), [webHtml rangeOfString:@"objWebDataWindowControl1_datawindow"])) {
        
        int pageCount = [_serverWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"option\").length"].intValue;
        if (pageCount<=1) {
            //数据已经是最后一页，完全结束
            [_datas addObjectsFromArray:[self filterExistedDataWithData:[self analyseDataWithoutJudge:webHtml]]];
            self.webExcuteState = @"computed";
            dispatch_semaphore_signal(semaphore);
        } else{
            self.webExcuteState = @"stillExcuting";
            //数据不是最后一页，需要进行下一次的数据解析
            NSArray *tempArr = [self analyseDataWithoutJudge:webHtml];
            //开始时间不变，更改结束时间，减少数据的返回数量，理论上不存在数据记录完全一致的record，暂时以此作为原始动力
            if ([tempArr lastObject][@"1"]) {
                if((![[tempArr lastObject][@"1"] isEqualToString:[_datas lastObject][@"1"]])||(![[tempArr lastObject][@"5"] isEqualToString:[_datas lastObject][@"5"]])){
                    [_datas addObjectsFromArray:[self filterExistedDataWithData:[self analyseDataWithoutJudge:webHtml]]];
                    _endDate = [_datas lastObject][@"1"];//实际上是kCGGetProvidentFundServiceKeys中的第1个对象，也就是交易日期，根据最后一个交易日期来压缩获取到的数据列表
                    [self testJSContextWithWebView2:_serverWebView withStartDate:_startDate endDate:_endDate];
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
    self.webExcuteState = @"excuting";
    [self testJSContextWithWebView2:webView withStartDate:_startDate endDate:_endDate];
}
#pragma mark - methods for webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if([self.webExcuteState isEqualToString:@"unload"]){
        //第一次，未曾执行javascript进行查询的时候，这时需要去执行并进行查询
        //检验是否获取到正确的账号和名字配对
        NSString *webHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
        if (!NSEqualRanges(NSMakeRange(NSNotFound, 0), [webHtml rangeOfString:@"操作失败信息"])) {
            NSString *errorMsg = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(\"ul\")[0].childNodes[1].textContent"];
            _error = [NSError errorWithDomain:@"www.lyzfgjj.com" code:ProvidentFundServiceErrorAnalyse userInfo:@{@"msg":errorMsg}];
            dispatch_semaphore_signal(semaphore);
            self.webExcuteState = @"computed";
        }else{
            [self excuteScriptToGetDataWithWebView:webView];
            if ([[[UIDevice currentDevice] systemVersion]compare:@"8.0"]==NSOrderedAscending) {
                //ios7提前执行
                int time = K_SERVICE_WAIT_TIME-1;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSString *webHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
                    [self analyseDataWithOriginHtml:webHtml];
                });
            }
        }
    } else {
        //当目标代码被执行之后，进行的html获取，这时实际上获取到的值
        if ([[[UIDevice currentDevice] systemVersion]compare:@"8.0"]!=NSOrderedAscending) {
            NSString *webHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
            [self analyseDataWithOriginHtml:webHtml];
        }
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    _error = [NSError errorWithDomain:@"www.lyzfgjj.com" code:ProvidentFundServiceErrorRemoteNetworkConnect userInfo:@{@"msg":@"远端网络访问失败"}];
}
@end
