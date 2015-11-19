//
//  CGContactService.m
//  base
//
//  Created by wsg on 15/11/19.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "CGContactService.h"
@import Contacts;
@implementation CGContactService
+ (id)service{
    CGContactService *s = [[CGContactService alloc] init];
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=9) {
        [s allgroupsFor9Checked];
    }else{
        s.groups = [s allgroupsFor9Minus];
    }
    return s;
}
- (NSArray *)allContacts{
    return @[];
}
-(NSArray *)allgroupsFor9Minus{
    NSMutableArray *arr = [NSMutableArray new];
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                               kCFAllocatorDefault,
                                                               CFArrayGetCount(people),
                                                               people
                                                               );
    
    
    CFArraySortValues(
                      peopleMutable,
                      CFRangeMake(0, CFArrayGetCount(peopleMutable)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*) ABPersonGetSortOrdering()
                      );
    [arr addObjectsFromArray:(__bridge NSArray * _Nonnull)(peopleMutable)];
    CFRelease(addressBook);
    CFRelease(people);
    CFRelease(peopleMutable);
    return arr;
}
-(void)allgroupsFor9Checked{
   
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]==CNAuthorizationStatusAuthorized) {
        CNContactStore *store = [[CNContactStore alloc]init];
        self.groups = [self allgroupsFor9WithStore:store];
    }else{
        CNContactStore *store = [[CNContactStore alloc]init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                self.groups = [self allgroupsFor9WithStore:store];
            }
        }];
    }
}
-(NSArray *)allgroupsFor9WithStore:(CNContactStore *)store{
    return [store groupsMatchingPredicate:[NSPredicate predicateWithValue:YES] error:nil];
}
@end
