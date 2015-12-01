//
//  CGNetwork.m
//  base
//
//  Created by wsg on 15/11/9.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "CGNetwork.h"

@implementation CGNetworkConnect
static CGNetworkConnect *nc;
+ (BOOL)canInitWithRequest:(NSURLRequest * _Nonnull)request{
    //这里写你监听到的事情
    [[NSNotificationCenter defaultCenter] postNotificationName:kCGNetworkConnectNotification object:nil];
    DDLogInfo(@"%@,%@",request.URL.absoluteString,[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    return NO;
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
    return request;
}
-(void)startLoading{
    //这里写你开始加载时要做的事情
}
-(void)stopLoading{
    //这里写加载结束的事情
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
