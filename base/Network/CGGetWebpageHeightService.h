//
//  CGWebViewHeightService.h
//  base
//
//  Created by wsg on 15/12/19.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGGetWebpageHeightService : NSObject
@property(nonatomic,strong)NSArray<NSString*> *htmls;
@property(nonatomic,strong)void(^finishLoading)(NSArray<NSDictionary<NSString *,NSNumber *> *> *);
@property(nonatomic,assign)CGSize size;
@end