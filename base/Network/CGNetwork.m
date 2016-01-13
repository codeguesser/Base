//
//  CGNetwork.m
//  base
//
//  Created by wsg on 15/11/9.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "CGNetwork.h"
static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";
@implementation CGNetworkConnect
static CGNetworkConnect *nc;
+ (BOOL)canInitWithRequest:(NSURLRequest * _Nonnull)request{
    //这里写你监听到的事情
    [[NSNotificationCenter defaultCenter] postNotificationName:kCGNetworkConnectNotification object:nil];
    if(request.HTTPBody.length>0){
        DDLogInfo(@"%@,%@",request.URL.absoluteString,[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
        return ![NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request];
    }
    return NO;
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}
+(BOOL)registerClass:(Class)protocolClass{
    nc = [CGNetworkConnect new];
    return [super registerClass:protocolClass];
}
+(void)unregisterClass:(Class)protocolClass{
    if (nc) {
        nc = nil;
    }
    [super unregisterClass:protocolClass];
}
+(BOOL)isClassRegisted{
    return nc?YES:NO;
}
+ (NSURLRequest * _Nonnull)canonicalRequestForRequest:(NSURLRequest * _Nonnull)request{
    //这里写你要重新处理的request
    NSMutableURLRequest *request2 = [request mutableCopy];
    NSString *targetPara = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    targetPara = [targetPara stringByReplacingOccurrencesOfString:@"2015-01-13" withString:@"2015-08-13"];
    DDLogInfo(@"%@",targetPara);
    request2.HTTPBody = [targetPara dataUsingEncoding:NSUTF8StringEncoding];
    return request2;
}
-(void)startLoading{
    //这里写你开始加载时要做的事情
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
}
-(void)stopLoading{
    //这里写加载结束的事情
    [self.connection cancel];
}

#pragma mark - NSURLConnectionDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}
@end
@implementation CGNetwork
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
