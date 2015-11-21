//
//  TestPayViewController.m
//  base
//
//  Created by wsg on 15/11/19.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "TestPayViewController.h"

#import "Order.h"
#import <DataSigner.h>
#import <AlipaySDK/AlipaySDK.h>
@interface TestPayViewController ()

@end

@implementation TestPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pay];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)pay{
    NSString *partner = @"2088611280436463";
    NSString *seller = @"hnrsaif6688@126.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAL67LG+ca+qD/IlRpgv/den/2GyzEede86Wj22PvUxxF+PeEKGK1Dz4HDbIu2Q20PL4H/ufgrSnu0oa/MZvtWBjTrqdYy7b7WLBxiS4mAuK8Q4eFZqjrDZrYD/x9Flqw34tg1w1tH7PtEljWyYD78gxRzmWoL526cLfiHHyNDSDHAgMBAAECgYBoXlgEgx3yaGMKaWlpa1MExwGRCbQkXasJ2s40s0NRV2DTYLgQu28pzAZMmKIhg50xh4KPNDzNk2gUYA8vegMYMLmOo2Xi5MxkmPrKU01s5vNCdOabkNbuLAoFj3DZs0tPjZ13q/ElZzSlglw0AhOwOkXYiuJYKlN6I5vuiqvBEQJBAOcko3lLA5kvi81jzr6eynpNbDgQF/4A5Zmb5NNdMicZdnNrQFwbUfZXKcmAxKI9kqzoUwyWR6f8OYyVUijuyqMCQQDTPf6yrwNYACiHbNVx7d2pkWphiE2+Gn4HL59/avDqBZC3XHyptAljF8dsL2CTgA/zv/KJXGiy35iJ8Cvmb7eNAkA4sCKrl7stMZz+5XCKDZWpAx38be4EbKHi13n6YIvxTOxhCDfDnyut19i2w671/1XetCfSGXU/fLt8gA6jXVUzAkEAlQEh68Bvx181N3GZjeePd9DPDUUsMXBWfZMmGqbAkRKj5fMjLEGGbZOUY8d3hBPNLM60shew8put6X60OLOM8QJAG3hIbDTtJ3pUHy4gBZ1pMRu0vjh7fqune/N1kat9qjEhx5DN563+sBttuz06EPWR/MQBddpOJYfwk/YEIoepsw==";
    
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"tm_1231231231"; //订单ID（由商家自行制定）
    order.productName = @"动本的支付"; //商品标题
    order.productDescription = @"动本的支付描述"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",100.0]; //商品价格
    order.notifyURL =  [NSString stringWithFormat:@"http://www.dongben.cc"]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"base";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *resultStr = resultDic[@"result"];
            NSLog(@"reslut = %@",resultStr);
            if (resultDic&&[resultDic isKindOfClass:[NSDictionary class]]&&resultDic[@"resultStatus"]&&[resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:CGAlipaySuccessNotification object:nil];
            }else{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:CGAlipayFalseNotification object:nil];
            }
        }];
    }
}
@end
