//
//  ShareHandle.h
//  base
//
//  Created by wsg on 15/8/6.
//  Copyright (c) 2015年 wsg. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "UserEntity.h"
typedef NS_ENUM(NSUInteger, ITransformMethod){
    ITransformMethodPush,
    ITransformMethodPresent,
    ITransformMethodTab
};
/*!
 @brief  网络任务管理器
 */
@protocol ITaskManager <NSObject>
/*!
 @brief  全部的任务
 
 @return 全部的任务列表
 */
-(NSArray *)allTask;
/*!
 @brief  取消全部的任务
 */
-(void)cancelAllTask;
/*!
 *  @author wsg
 *
 *  @brief  全局下缓存到的任务号
 */
@property(nonatomic,strong)NSNumber *cachedLastTaskIndex;
@optional
/*!
 @brief  添加后台任务，用于网络和本地数据同步，同时添加通知，use ONLY in sharehandle，如果需要启用前台任务请使用addTask:
 
 @param url             访问的链接
 @param para            链接的参数
 @param method          访问的方法描述
 @param completionBlock 完成时的block
 
 @return 网络操作对象
 */
-(MKNetworkRequest *)addTaskWithUrl:(NSString *)url para:(NSDictionary *)para method:(NSString *)method completeClass:(NSString *)classString operateRule:(NSString *)rule;
/*!
 @brief  添加前台任务，use ONLY in cgviewcontroller，如果需要启用后台任务请使用addTaskWithUrl:para:method:complete:
 
 @param op 网络操作
 */
-(void)addTask:(MKNetworkRequest *)op;
@end
/*!
 @brief  场景切换器
 */
@protocol IViewControllerTransformManager <NSObject>
/*!
 @brief  通过特殊的场景转换以统一管理场景
 
 @param method           转换方法，tab、push、present是主要的几种方式
 @param fromController   发起该操作的控制器
 @param targetController 需要展现的控制器
 */
-(void)transformViewControllerWithMethod:(ITransformMethod)method fromController:(UIViewController *)fromController targetController:(UIViewController *)targetController;
/*!
 @brief  缓存给登陆页面的目标控制器
 */
@property(nonatomic,weak)UIViewController * cachedTargetController;
/*!
 @brief  缓存给登陆页面的来源控制器
 */
@property(nonatomic,weak)UIViewController * cachedFromController;
@property(nonatomic,assign)ITransformMethod cachedMehod;
@end

/*!
 @author wangshuguan, 15-08-06 11:08:43
 
 @brief  单例，保存全局的内容
 */
@interface ShareHandle : NSObject<ITaskManager>
/*!
 @author wangshuguan, 15-08-06 11:08:13
 
 @brief  单例的对象
 
 @return 单例
 */
+(ShareHandle *)shareHandle;
/*!
 *  @author wsg
 *
 *  @brief  我，它的存在引导了，用户是否登录，允许设置为空
 */
@property(nonatomic,strong)UserEntity *me;
/*!
 @author wangshuguan
 
 @brief  当前的控制器
 */
@property(nonatomic,weak)UIViewController *currentController;
/*!
 @brief  应用启动的时刻
 */
@property(nonatomic,strong)NSDate *appStartDate;

#pragma mark - other property -necesary
/*!
 @brief  拼音的数据源
 */
-(NSDictionary *)pinyinSourceDic;
@end