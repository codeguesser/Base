//
//  Network.h
//  base
//
//  Created by wsg on 15/8/16.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Network : NSManagedObject

@property (nonatomic, retain) NSString * nid;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * para;

@end
