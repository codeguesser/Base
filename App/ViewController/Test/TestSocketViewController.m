//
//  TestViewController.m
//  base   增加socket支持
//
//  Created by wsg on 15/9/2.
//  Copyright (c) 2015年 wsg. All rights reserved.
//
/**
 * Created by wsg on 15/9/6.
 * Node JS code
 
var net = require('net');

var HOST = '192.168.2.201';
var PORT = 6969;
var connections = [];
// 创建一个TCP服务器实例，调用listen函数开始监听指定端口
// 传入net.createServer()的回调函数将作为”connection“事件的处理函数
// 在每一个“connection”事件中，该回调函数接收到的socket对象是唯一的
net.createServer(function(sock) {
    
    // 我们获得一个连接 - 该连接自动关联一个socket对象
    console.log('CONNECTED: ' +
                sock.remoteAddress + ':' + sock.remotePort);
    connections.push(sock);
    // 为这个socket实例添加一个"data"事件处理函数
    sock.on('data', function(data) {
        console.log('DATA ' + sock.remoteAddress + ': ' + data);
        // 回发该数据，客户端将收到来自服务端的数据
        for(var i=0;i<connections.length;i++){
            var con = connections[i];
            if(con!=sock)con.write('Other said "' + data + '"');
        }
    });
    
    // 为这个socket实例添加一个"close"事件处理函数
    sock.on('close', function(data) {
        connections.pop(sock);
        console.log('CLOSED: ' +
                    sock.remoteAddress + ' ' + sock.remotePort);
    });
    
}).listen(PORT, HOST);

console.log('Server listening on ' + HOST +':'+ PORT);
 
 */

#import "TestSocketViewController.h"
#import <GCDAsyncSocket.h>
@interface TestSocketViewController (){
    GCDAsyncSocket  *socket;
    UITextField *contentField;
}
@end

@implementation TestSocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err;
    if (![socket connectToHost:@"codeguesser.cn" onPort:8083 error:&err]){
        NSLog(@"%@",err);
    }
    contentField = [[UITextField alloc]init];
    [self.view addSubview:contentField];
    contentField.backgroundColor = [UIColor whiteColor];
    [contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, -60));
        make.size.mas_equalTo(CGSizeMake(200, 44));
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendAction)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendAction{
    [socket writeData:[contentField.text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:30 tag:0];
    contentField.text = @"";
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [sock performBlock:^{
        [sock enableBackgroundingOnSocket];
        [sock readDataWithTimeout:-1 tag:0];
    }];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showMessageOnWindowWithText:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    });
    [sock readDataWithTimeout:-1 tag:0];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"%@",err);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
