//
//  TestPayViewController.m
//  base
//
//  Created by wsg on 15/11/19.
//  Copyright © 2015年 wsg. All rights reserved.
//
// pod 'cg-weixinpay', :git => 'https://git.oschina.net/codeguesser/cg-weixinpay.git'#如果有了sharesdk，就要去掉这个，这个和sharesdk的微信是冲突的
// pod 'openssl', :git => 'https://git.oschina.net/codeguesser/openssl.git'#支付宝专用openssl
// pod 'CG-AlipaySDK', :git => 'https://git.oschina.net/codeguesser/CG-AlipaySDK.git'#支付宝

#import "TestPayViewController.h"

#ifdef AlipayPartner
#ifdef AlipaySeller
#ifdef AlipayPrivateKey
#import "Order.h"
#import <DataSigner.h>
#import <AlipaySDK/AlipaySDK.h>
#endif
#endif
#endif
#ifdef WeixinAppId
#import "WXApi.h"
#import "WechatAuthSDK.h"
#import "WXApiObject.h"
#endif
@interface TestPayViewController ()

@end

@implementation TestPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self payByzhifubao];
        [self payByzhifubao];
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
#ifdef AlipayPartner
#ifdef AlipaySeller
#ifdef AlipayPrivateKey
-(void)payByzhifubao{
    NSString *partner = AlipayPartner;
    NSString *seller = AlipaySeller;
    NSString *privateKey = AlipayPrivateKey;
    
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"tm_51"; //订单ID（由商家自行制定）
    order.productName = @"动本的支付"; //商品标题
    order.productDescription = @"动本的支付描述"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
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
            DDLogInfo(@"result = %@",resultDic);
            NSString *resultStr = resultDic[@"result"];
            DDLogInfo(@"reslut = %@",resultStr);
            if (resultDic&&[resultDic isKindOfClass:[NSDictionary class]]&&resultDic[@"resultStatus"]&&[resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:CGAlipaySuccessNotification object:nil];
            }else{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:CGAlipayFalseNotification object:nil];
            }
        }];
    }
}

#endif
#endif
#endif
#ifdef WeixinAppId
- (void)payByweixin {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                DDLogInfo(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                
            }else{
                DDLogInfo(@"%@",[dict objectForKey:@"retmsg"]);
            }
        }else{
            DDLogInfo(@"%@",@"服务器返回错误，未获取到json对象");
        }
    }else{
        DDLogInfo(@"%@",@"服务器返回错误");
    }
}
#endif
@end
