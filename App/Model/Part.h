//
//  Part.h
//  base
//
//  Created by wsg on 15/9/8.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Part : NSManagedObject

@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;

@end
