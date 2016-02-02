//
//  CGGetProvidentFundService.h
//  base
//
//  Created by wsg on 16/1/11.
//  Copyright © 2016年 wsg. All rights reserved.
//
//  *****获取公积金的内容*****
//
//  如何使用 How to use it!!!!!!
//
//    CGGetProvidentFundService *service3 = [CGGetProvidentFundService service];
//    service3.name = @"姓名";
//    service3.cardId = @"身份证号";
//    [service3 asyncRequestResultWithYear:@"2015" completion:^(NSArray *historyList, NSArray *keys, NSDictionary *otherInfo, NSError *error){
//        int j=0;
//        for (NSDictionary *dic in historyList) {
//            NSLog(@"%@:%d",keys[0],j);
//            for (int i=1; i<dic.count; i++) {
//                NSLog(@"%@:%@",keys[i],dic[[NSString stringWithFormat:@"%d",i]]);
//            }
//            j++;
//        }
//        NSLog(@"%@",otherInfo);
//    }];
//    //或者采用以下方法
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"%@",[service3 requestResultWithYear:@"2015"]);
//    });
//
//
#import <Foundation/Foundation.h>
NS_ENUM(NSInteger,ProvidentFundServiceError){
    ProvidentFundServiceErrorTimeOut = 0,//访问网站自设置timeout超时
    ProvidentFundServiceErrorTimeOut2 = 1,//异端超时
    ProvidentFundServiceErrorRemoteNetworkConnect = 2,//远端网络访问失败
    ProvidentFundServiceErrorAnalyse = 3,//解析错误
};
@interface CGGetProvidentFundService : NSObject

/*!
 @brief  初始化服务
 
 @return 服务的对象，仅用此做服务
 */
+ (id)service;
/*!
 @brief 姓名
 */
@property(nonatomic,strong)NSString *name;
/*!
 @brief 身份证号
 */
@property(nonatomic,strong)NSString *cardId;
/*!
 @brief 异步根据年份获取数据列表
 
 @param year       年份
 @param completion 数据的详情，数据集和key的列表，other info 存储
 */
-(void)requestResultWithYear:(NSString *)year completion:(void(^)(NSArray *historyList,NSArray *keys,NSDictionary *otherInfo))completion;
/*!
 @brief 对requestResultWithYear:completion:的补充，同样是异步方法，多加了一error，返回错误
 
 @param year       年份
 @param completion 数据的详情，数据集和key的列表，other info 存储，另外多了一个error接受错误，如果正常，则error为nil
 */
-(void)asyncRequestResultWithYear:(NSString *)year completion:(void(^)(NSArray *historyList,NSArray *keys,NSDictionary *otherInfo,NSError *error))completion;
/*!
 @brief 同步根据年份获取数据列表
 
 @param year 年份
 
 @return 默认为空数组
 */
-(NSDictionary *)syncRequestResultWithYear:(NSString *)year;
/*!
 @brief web的执行状态
 
 @return unload(第一次加载) excuted(已经执行过了) excuting(正在执行) stillExcuting(数据较多需要多次执行) computed(执行完毕)
 */
-(NSString *)webExcuteState;
@end
