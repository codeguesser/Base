//
//  TestSocketUDPViewController.m
//  base
//
//  Created by wsg on 16/2/9.
//  Copyright © 2016年 wsg. All rights reserved.
//

#import "TestSocketUDPViewController.h"
#import <GCDAsyncUdpSocket.h>
@interface TestSocketUDPViewController (){
    GCDAsyncUdpSocket  *socket;
}

@end

@implementation TestSocketUDPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_queue_t udpSocketQueue = dispatch_queue_create("com.manmanlai.updSocketQueue", DISPATCH_QUEUE_CONCURRENT);
    
    socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:udpSocketQueue];
    
    [self startUdpSocket];
}
- (void)startUdpSocket
{
//    [socket sendData:[@"3" dataUsingEncoding:NSUTF8StringEncoding] toHost:@"127.0.0.1" port:9999 withTimeout:1 tag:0];
    
    [socket sendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] toHost:@"127.0.0.1" port:9999 withTimeout:1 tag:0];

    [socket receiveOnce:nil];
}



- (void)stopUdpSocket
{
    [socket close];
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext{
    if ([[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]
         isEqualToString:@"1"]) {
        [socket sendData:[@"3" dataUsingEncoding:NSUTF8StringEncoding] toHost:@"127.0.0.1" port:9999 withTimeout:1 tag:0];
    }else{
        DDLogInfo(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }
    [socket receiveOnce:nil];
}
@end
