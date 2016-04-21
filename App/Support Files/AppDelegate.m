//
//  AppDelegate.m
//  base
//
//  [NSDecimalNumber decimalNumberWithString:numberString]
//
//  Created by wsg on 15/6/5.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "AppDelegate.h"
//#import "TestAnimate1ViewController.h"
//#import "PartEntity.h"
//#import "TableViewController.h"
#import "TestSocketViewController.h"
//#import "LoadingViewController.h"
//#import "MasMakeViewController.h"
//#import "TestLayoutViewController.h"

#import "WebViewController.h"
#import "NSString+Pinyin.h"
//#import "TestContactManagerViewController.h"
#import "CGAreaService.h"
#import "CGLocationService.h"
#import "WebViewController.h"
#import "CGContactService.h"
#import "TestViewController.h"
#import "CGGetWebpageHeightService.h"
#import "TestImageMemoryViewController.h"
#import "CGNetwork.h"
#import "CGGetProvidentFundService.h"
#import "TestSocketUDPViewController.h"
#import "BookDetailViewController.h"
#import "CGWebAccessService.h"
#import <LocalAuthentication/LocalAuthentication.h>
//#include <stdio.h>
//#include <stdlib.h>
//#include <dlfcn.h>
//
//#include <sys/types.h>
//#include <sys/socket.h>
//#include <ifaddrs.h>
//#include <arpa/inet.h>
//
//
//#import <sys/sysctl.h>
//struct rt_metrics {
//    u_int32_t   rmx_locks;  /* Kernel must leave these values alone */
//    u_int32_t   rmx_mtu;    /* MTU for this path */
//    u_int32_t   rmx_hopcount;   /* max hops expected */
//    int32_t     rmx_expire; /* lifetime for route, e.g. redirect */
//    u_int32_t   rmx_recvpipe;   /* inbound delay-bandwidth product */
//    u_int32_t   rmx_sendpipe;   /* outbound delay-bandwidth product */
//    u_int32_t   rmx_ssthresh;   /* outbound gateway buffer limit */
//    u_int32_t   rmx_rtt;    /* estimated round trip time */
//    u_int32_t   rmx_rttvar; /* estimated rtt variance */
//    u_int32_t   rmx_pksent; /* packets sent using this route */
//    u_int32_t   rmx_filler[4];  /* will be used for T/TCP later */
//};
//struct rt_msghdr {
//    u_short rtm_msglen;     /* to skip over non-understood messages */
//    u_char  rtm_version;        /* future binary compatibility */
//    u_char  rtm_type;       /* message type */
//    u_short rtm_index;      /* index for associated ifp */
//    int rtm_flags;      /* flags, incl. kern & message, e.g. DONE */
//    int rtm_addrs;      /* bitmask identifying sockaddrs in msg */
//    pid_t   rtm_pid;        /* identify sender */
//    int rtm_seq;        /* for sender to identify action */
//    int rtm_errno;      /* why failed */
//    int rtm_use;        /* from rtentry */
//    u_int32_t rtm_inits;        /* which metrics we are initializing */
//    struct rt_metrics rtm_rmx;  /* metrics themselves */
//};
//#define ROUNDUP(a) \
//((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))
//
//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
@interface AppDelegate ()<UIAlertViewDelegate,UIWebViewDelegate>{
    CGContactService *service;
    CGLocationService *service2;
    int count;
}
#warning 什么东西来的
@property NSString<UIDataSourceModelAssociation> *xx;
@end

@implementation AppDelegate
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    NSLog(@"1:%@",shortcutItem.localizedTitle);
    NSLog(@"2:%@",shortcutItem.localizedSubtitle);
    NSLog(@"3:%@",shortcutItem.userInfo);
    NSLog(@"4:%@",shortcutItem.type);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    window.backgroundColor = [UIColor grayColor];
    self.window = window;
    [window makeKeyAndVisible];
    [[UIButton appearance]setTintColor:[UIColor greenColor]];
    [[UIAlertView appearance]setTintColor:[UIColor greenColor]];
    [[UIBarButtonItem appearance]setTintColor:[UIColor greenColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor greenColor]];
    [self tableViewEmptyPageDemo];
    
//    [self getUserContact];
//    [self getTouchidPower];
//    [self getGatewayIPAddress];
//    [self testProvidentFund];
//    [self setupTestWebAccess];
//    float qq = 94.944;
//    float qq1 = 0.33;
//    NSString *str = [[NSNumber numberWithFloat:qq+qq1] stringValue];
//    NSLog(@"%@",str);
//    float qq3 = str.floatValue;
//    DDLogInfo(@"%@",str);
    return YES;
}
-(void)getUserContact{
//    ABAddressBookRef address = ABAddressBookCreateWithOptions(nil, nil);
//     *callback = ABExternalChangeCallback{
//        
//    };
//    ABAddressBookRegisterExternalChangeCallback(address,callback , nil);
}
-(void)getTouchidPower{
    LAContext *context = [[LAContext alloc]init];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]){
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证您的指纹来确认您的身份信息" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"成功");
            }else{
                NSLog(@"%@",error);
            }
        }];
    }
    
    
}
-(void)getDynamicLinkLibrary{
    
//    CTTelephonyNetworkInfo* info = [[CTTelephonyNetworkInfo alloc] init];
//    id trength = [info performSelector:NSSelectorFromString(@"cachedSignalStrength")];
//    
//    void *libHandle = dlopen("/System/Library/Frameworks/SystemConfiguration.framework/SystemConfiguration",RTLD_LAZY);//获取库句柄
//    int (*CTGetSignalStrength)(); //定义一个与将要获取的函数匹配的函数指针
//    CTGetSignalStrength = (int(*)())dlsym(libHandle,"CTGetSignalStrength"); //获取指定名称的函数
//    
//    if(CTGetSignalStrength == NULL)
//        NSLog(@"error");
//    else{
//        int level = CTGetSignalStrength();
//        dlclose(libHandle); //切记关闭库
//        NSLog(@"%d",level);
//    }
}
-(void)getIpInfo{
//    struct ifaddrs *list;
//    if(getifaddrs(&list) < 0) {
//        perror("getifaddrs");
//    }
//    
//    NSMutableDictionary *d = [NSMutableDictionary dictionary];
//    struct ifaddrs *cur;
//    for(cur = list; cur != NULL; cur = cur->ifa_next) {
//        if(cur->ifa_addr->sa_family != AF_INET)
//            continue;
//        
//        struct sockaddr_in *addrStruct = (struct sockaddr_in *)cur->ifa_addr;
//        NSString *name = [NSString stringWithUTF8String:cur->ifa_name];
//        NSString *addr = [NSString stringWithUTF8String:inet_ntoa(addrStruct->sin_addr)];
//        NSString *netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cur->ifa_netmask)->sin_addr)];
//        [d setValue:[NSString stringWithFormat:@"%@,%@",addr,netmask] forKey:name];
//    }
//    NSLog(@"%@",d);
//    freeifaddrs(list);
}
- (NSString *)getGatewayIPAddress {
//    
//    NSString *address = nil;
//    
//    /* net.route.0.inet.flags.gateway */
//    int mib[] = {4, PF_ROUTE, 0, AF_INET,
//        NET_RT_FLAGS, 0x2};
//    size_t l;
//    char * buf;char * p;
//    struct rt_msghdr * rt;
//    struct sockaddr * sa;
//    struct sockaddr * sa_tab[8];
//    int i;
//    int r = -1;
//    
//    if(sysctl(mib, sizeof(mib)/sizeof(int), 0, &l, 0, 0) < 0) {
//        address = @"192.168.0.1";
//    }
//    
//    if(l>0) {
//        buf = malloc(l);
//        if(sysctl(mib, sizeof(mib)/sizeof(int), buf, &l, 0, 0) < 0) {
//            address = @"192.168.0.1";
//        }
//        
//        for(p=buf; p<buf+l; p+=rt->rtm_msglen) {
//            rt = (struct rt_msghdr *)p;
//            sa = (struct sockaddr *)(rt + 1);
//            for(i=0; i<8; i++)
//            {
//                if(rt->rtm_addrs & (1 << i)) {
//                    sa_tab[i] = sa;
//                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
//                } else {
//                    sa_tab[i] = NULL;
//                }
//            }
//            
//            if( ((rt->rtm_addrs & (0x1|0x2)) == (0x1|0x2))
//               && sa_tab[0]->sa_family == AF_INET
//               && sa_tab[1]->sa_family == AF_INET) {
//                unsigned char octet[4]  = {0,0,0,0};
//                int i;
//                for (i=0; i<4; i++){
//                    octet[i] = ( ((struct sockaddr_in *)(sa_tab[1]))->sin_addr.s_addr >> (i*8) ) & 0xFF;
//                }
//                if(((struct sockaddr_in *)sa_tab[0])->sin_addr.s_addr == 0) {
//                    in_addr_t addr = ((struct sockaddr_in *)(sa_tab[1]))->sin_addr.s_addr;
//                    r = 0;
//                    address = [NSString stringWithFormat:@"%s", inet_ntoa(*((struct in_addr*)&addr))];
//                    NSLog(@"\naddress%@",address);
//                    break;
//                }
//            }
//        }
//        free(buf);
//    }
//    return address;
    return nil;
}
-(void)setupTestWebAccess{
    CGWebAccessService *as = [CGWebAccessService service];
    as.cardId = @"卡号";
    as.password =  @"密码";
    [as requestWithCompletion:^(NSDictionary *otherInfo) {
        
    }];
}
-(void)tableViewEmptyPageDemo{
    TestViewController *vc = [[TestViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"电话本" image:[[UIButton buttonWithType:UIButtonTypeDetailDisclosure] currentImage] tag:0];
    UITabBarController *tbc = [[UITabBarController alloc]init];
    tbc.viewControllers = @[nav];
    
    self.window.rootViewController = tbc;
}
-(void)sthComming:(NSNotification *)no{
    NSLog(@"%@",[(CGContactService*)no.object contactsForExport]);
}
//测试获取定位服务
#ifdef U_BAIDU_KEY
-(void)testGetLocation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        service2 = [[CGLocationService alloc]initWithoutGetLocation];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(@"getLocation:") name:CGBaiduGetLocationAttributeNotification object:nil];
        //        service2.warrantAction =^(CGLocationError error){
        //
        //        };
        [service2 startLocation];
    });
}
#endif
//测试获取中国行政区
-(void)testGetChinaArea{
    [CGAreaService service];
}
//调用本地联系人
-(void)testContact{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sthComming:) name:@"kNotificationContactUpdated" object:nil];
    service = [CGContactService service];
}
//获取html的高度
-(void)testWebpageHeight{
    CGGetWebpageHeightService *whs = [[CGGetWebpageHeightService alloc]init];
    whs.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    whs.htmls = @[
                  [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil]
                  ];
    whs.finishLoading = ^(NSArray<WebHeightOperation *> *arr) {
        NSLog(@"%@",arr);
    };
}
//获取公积金内容
-(void)testProvidentFund{
    count = 0;
    CGGetProvidentFundService *service3 = [CGGetProvidentFundService service];
    service3.name = @"王书倌";
    service3.cardId = @"410311199002021538";
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSDictionary *dic = [service3 syncRequestResultWithYear:@"2015"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            DDLogInfo(@"%@",dic);
//        });
//    });
    
    [service3 asyncRequestResultWithYear:@"2015" completion:^(NSArray *historyList, NSArray *keys, NSDictionary *otherInfo, NSError *error) {
        int j=0;
        for (NSDictionary *dic in historyList) {
            NSLog(@"%@:%d",keys[0],j);
            for (int i=1; i<dic.count; i++) {
                NSLog(@"%@:%@",keys[i],dic[[NSString stringWithFormat:@"%d",i]]);
            }
            j++;
        }
        NSLog(@"%@",otherInfo);
    }];
}

//测试数字number的转换
-(void)testNumber{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    formatter.maximumFractionDigits = 20;
    [formatter stringFromNumber:@(253412312312311123.94)];
}
//entity的测试，以及拼音的使用
-(void)testPinyin{
//    PartEntity *part = [PartEntity getObjectFromDic:@{@"pid":@(534.94)}];

    NSLog(@"%@",[@"--" pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]]);
}
//线程分析
-(void)testThread{
    NSLog(@"1%@",[[NSThread currentThread] isMainThread]?@"主线程":@"分线程");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@",[[NSThread currentThread] isMainThread]?@"主线程":@"分线程");
        });
    });
    NSLog(@"4%@",[[NSThread currentThread] isMainThread]?@"主线程":@"分线程");
}
/*
-(void)setupHTTPNetworkDemo{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://192.168.2.36:9100/dongbenservice.asmx/book_print_base_info" parameters:@{@"token":@"string",@"book_id":@"123"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)setupHTTPSNetworkDemo{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:NO];
    [securityPolicy setPinnedCertificates:@[certData]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = securityPolicy;
    [manager GET:@"https://codeguesser.cn" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
 */

/*!
 @author wangshuguan, 15-08-05 13:08:28
 
 @brief  证书生成说明
 http://www.codeguesser.cn/openssljian-li-shuang-xiang-ren-zheng-de-zheng-shu/
 */
-(void)setupHTTPSNetworkDemo{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    MKNetworkHost *engine = [[MKNetworkHost alloc] initWithHostName:@"www.codeguesser.cn"];
    MKNetworkRequest *op = [engine requestWithPath:@"/" params:nil httpMethod:@"GET" body:nil ssl:YES];
    op.clientCertificate = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ca.cer"];
    op.clientCertificatePassword = @"";
    [op addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        DDLogInfo(@"%@",completedRequest.responseAsJSON);
    }];
    [engine startRequest:op];
}
 

/*!
 @author wangshuguan, 15-08-05 17:08:51
 
 @brief  一个普通的网络连接的demo
 */
-(void)setupNetworkDemo{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    MKNetworkHost *engine = [[MKNetworkHost alloc] initWithHostName:@"dlsw.baidu.com"];
    
    
    
    MKNetworkRequest *op = [engine requestWithPath:@"sw-search-sp/soft/3a/12350/QQ_V7.5.15456.0_setup.1438225942.exe" params:nil httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        DDLogInfo(@"%@",completedRequest.responseAsJSON);
    }];
    [engine startRequest:op];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [op cancel];
    });
}
-(void)setupNetworkDemo2{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    MKNetworkHost *engine = [[MKNetworkHost alloc] initWithHostName:@"192.168.2.36:9100"];
    
    MKNetworkRequest *op = [engine requestWithPath:@"/dongbenservice.asmx/book_print_base_info" params:@{@"token":@"string",@"book_id":@"123"} httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        DDLogInfo(@"%@",completedRequest.responseAsJSON);
    }];
    [engine startRequest:op];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [op cancel];
    });
}
@end
