//
//  ShareHandle.m
//  base
//
//  Created by wsg on 15/8/6.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "ShareHandle.h"
#import "Prefrence.h"
#import "Network.h"
#import "NSNotification+CGCategory.h"
@interface ShareHandle(){
    MKNetworkEngine *_networkEngine;
    NSMutableArray *_networkOperationArray;
    NSDictionary *_pinyinSourceDic;
}
@end
@implementation ShareHandle
@synthesize cachedLastTaskIndex;
+(ShareHandle *)shareHandle{
    static ShareHandle *sh;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sh = [[ShareHandle alloc]init];
    });
    return sh;
}





- (instancetype)init
{
    self = [super init];
    if (self) {
        _me = [Prefrence me];
        NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
        [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
        _networkEngine = [[MKNetworkEngine alloc] initWithHostName:@"dlsw.baidu.com"
                                                         customHeaderFields:headerFields];
        _networkOperationArray = [NSMutableArray new];
        cachedLastTaskIndex = @(1);
    }
    return self;
}
-(void)setMe:(UserEntity *)me{
    _me = me;
    if (_me) {
        [Prefrence saveUserMe:me];
    }else{
        [Prefrence clearUserMe];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kCGNotificationUserStatusChanged object:me];
}
-(void)setCurrentController:(UIViewController *)currentController{
    _currentController = currentController;
}
#pragma mark - delegate for ITask
-(NSArray *)allTask{
    return _networkOperationArray;
}
-(void)cancelAllTask{
    for (MKNetworkOperation *op in _networkOperationArray) {
        [op cancel];
        [_networkOperationArray removeObject:op];
    }
}
-(MKNetworkOperation *)addTaskWithUrl:(NSString *)url para:(NSDictionary *)para method:(NSString *)method completeClass:(NSString *)classString operateRule:(NSString *)rule{
#warning 任务暂时搁置，嗯，需要考虑存储规则和添加依赖
    NSAssert(YES, @"任务暂时搁置，嗯，需要考虑存储规则和添加依赖");
    MKNetworkOperation *op = [[MKNetworkOperation alloc]initWithURLString:url params:para httpMethod:method];
    __weak MKNetworkOperation *weakOp = op;
    [_networkOperationArray addObject:weakOp];
    Network *networkTask = [Network MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    networkTask.nid = [NSString stringWithFormat:@"%f-%@",[[ShareHandle shareHandle].appStartDate timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:0]],cachedLastTaskIndex];
    networkTask.url = op.url;
    [weakOp setCompletionBlock:^{
        [_networkOperationArray removeObject:op];
    }];
    [_networkEngine enqueueOperation:op];
    cachedLastTaskIndex = @(cachedLastTaskIndex.integerValue+1);
    return op;
}
#pragma mark - methods for IViewControllerTransformManager


#pragma mark - other property - necesary
-(NSDictionary *)pinyinSourceDic{
    if (!_pinyinSourceDic) {
        _pinyinSourceDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pinyin" ofType:@"plist"]];
        NSAssert(_pinyinSourceDic, @"无法获取pinyin plist，请检查配置！！");
    }
    return _pinyinSourceDic;
    
}
@end
