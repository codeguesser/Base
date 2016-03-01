//
//  CGWebAccessService.h
//  base
//
//  Created by wsg on 16/2/29.
//  Copyright © 2016年 wsg. All rights reserved.
//
//
//    CGWebAccessService *as = [CGWebAccessService service];
//    as.cardId = @"社保卡号";
//    as.password =  @"卡号密码";
//    [as requestWithCompletion:^(NSDictionary *otherInfo) {
//        
//    }];
//
//
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,WebAccessServiceError){
    WebAccessServiceErrorTimeOut = 0,//访问网站自设置timeout超时
    WebAccessServiceErrorTimeOut2 = 1,//异端超时
    WebAccessServiceErrorRemoteNetworkConnect = 2,//远端网络访问失败
    WebAccessServiceErrorAnalyse = 3,//解析错误
};
typedef NS_ENUM(NSInteger,WebAccessServiceState){
    WebAccessServiceStateUnload = 0,//未加载
    WebAccessServiceStateLoad = 1,//已加载
    WebAccessServiceStateSuccess = 2,//加载成功
};
@interface CGWebAccessService : NSObject
/*!
 @brief  初始化服务
 
 @return 服务的对象，仅用此做服务
 */
+ (id)service;
/*!
 @brief 异步根据年份获取数据列表
 
 @param year       年份
 @param completion 数据的详情，数据集和key的列表，other info 存储
 */
-(void)requestWithCompletion:(void(^)(NSDictionary *otherInfo))completion;

/*!
 @brief 密码
 */
@property(nonatomic,strong)NSString *password;
/*!
 @brief 社保卡号
 */
@property(nonatomic,strong)NSString *cardId;
@end
