//
//  main.m
//  base
//
//  Created by wsg on 15/6/5.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        DDLogInfo(@"%@",DOCUMENT_DIR);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
