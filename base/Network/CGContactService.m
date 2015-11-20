//
//  CGContactService.m
//  base
//
//  Created by wsg on 15/11/19.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "CGContactService.h"
@import Contacts;
NSString *const kContactServiceName = @"kContactServiceName";
NSString *const kGroupServiceName = @"kGroupServiceName";
NSString *const kServicePinyin = @"kServicePinyin";
NSString *const kServiceTels = @"kServiceTels";

NSString *const kNotificationContactUpdated = @"kNotificationContactUpdated";
#define kFetchedField @[CNContactFamilyNameKey,CNContactGivenNameKey,CNContactMiddleNameKey,CNContactPhoneNumbersKey]
@interface CGContactService()
-(void)allgroupsFor9MinusChecked;
@end
@implementation CGContactService
+ (id)service{
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sthComming:) name:kNotificationContactUpdated object:nil];
    CGContactService *s = [[CGContactService alloc] init];
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=9) {
        [s allgroupsFor9Checked];
    }else{
        [s allgroupsFor9MinusChecked];
    }
    return s;
}
//+(void)sthComming:(NSNotification *)no{
//    DDLogInfo(@"%@",no);
//}
-(NSArray *)contactsForExport{
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableSet *arrForCheck = [NSMutableSet new];//检验重复的人
    
    //通过分组得到人
    for (NSDictionary *groupDic in self.groups) {
        if ([groupDic[@"data"] count]>0) {
            //该组有人
            for (NSDictionary *contactDic in groupDic[@"data"]) {
                NSMutableArray *tels = [NSMutableArray new];
                for (NSString *tel in contactDic[kServiceTels]) {
                    [tels addObject:@{@"type":@"mobile",@"type_title":@"手机",@"content":tel}];
                }
                [arr addObject:@{
                                 @"group_title":groupDic[kGroupServiceName],
                                 @"name":[contactDic[kContactServiceName] length]>0?contactDic[kContactServiceName]:[contactDic[kServiceTels] firstObject],
                                 @"tel":[contactDic[kServiceTels] count]>0?[contactDic[kServiceTels] firstObject]:@"",
                                 @"contact_other":[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:tels options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]
                                 }];
                [arrForCheck addObject:contactDic.description];
            }
        }else{
            //改组没人
            [arr addObject:@{
                             @"group_title":groupDic[kGroupServiceName],
                             @"name":@"",
                             @"tel":@"",
                             @"contact_other":@""}];
        }
    }
    //没有分组的，孤单的人
    for (NSDictionary *contactDic in self.contacts) {
        NSInteger originCount = arrForCheck.count;
        [arrForCheck addObject:contactDic.description];
        if (originCount < arrForCheck.count) {
            //没有重复的(属于没分组的)，添加
            NSMutableArray *tels = [NSMutableArray new];
            for (NSString *tel in contactDic[kServiceTels]) {
                [tels addObject:@{@"type":@"mobile",@"type_title":@"手机",@"content":tel}];
            }
            [arr addObject:@{
                             @"group_title":@"",
                             @"name":[contactDic[kContactServiceName] length]>0?contactDic[kContactServiceName]:[contactDic[kServiceTels] firstObject],
                             @"tel":[contactDic[kServiceTels] count]>0?[contactDic[kServiceTels] firstObject]:@"",
                             @"contact_other":[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:tels options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]
                             }];
        }
        
    }
    return arr;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@\n%@",self.contacts,self.groups];
}

-(void)allgroupsFor9MinusChecked{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized) {
        CFRetain(addressBook);
        self.contacts = [self allContactsFor9MinusWithAddress:addressBook];
        self.groups = [self allgroupsFor9MinusWithAddress:addressBook];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContactUpdated object:self];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
                dispatch_semaphore_signal(sema);
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CFRetain(addressBook);
                        self.contacts = [self allContactsFor9MinusWithAddress:addressBook];
                        self.groups = [self allgroupsFor9MinusWithAddress:addressBook];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContactUpdated object:self];
                    });
                }
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        });
    }
    
}
-(NSArray *)allgroupsFor9MinusWithAddress:(ABAddressBookRef)addressBook{
    NSMutableArray *arr = [NSMutableArray new];
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllGroups(addressBook);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                               kCFAllocatorDefault,
                                                               CFArrayGetCount(people),
                                                               people
                                                               );
    NSArray *translateArr = (__bridge NSArray *)(peopleMutable);
    for (int i=0; i<translateArr.count; i++) {
        ABRecordRef group = (__bridge ABRecordRef)([translateArr objectAtIndex:i]);
        [arr addObject:[self groupFromRecordId:group]];
    }
    CFRelease(addressBook);
    CFRelease(people);
    CFRelease(peopleMutable);
    return arr;
}
-(NSArray *)allContactsFor9MinusWithAddress:(ABAddressBookRef)addressBook{
    NSMutableArray *arr = [NSMutableArray new];
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                               kCFAllocatorDefault,
                                                               CFArrayGetCount(people),
                                                               people
                                                               );
    
    
    NSArray *translateArr = (__bridge NSArray *)(peopleMutable);
    for (int i=0; i<translateArr.count; i++) {
        ABRecordRef contact = (__bridge ABRecordRef)([translateArr objectAtIndex:i]);
        NSDictionary *c = [self contactFromRecordId:contact];
        if([self isContactValable:c])[arr addObject:c];
    }
    CFRelease(addressBook);
    CFRelease(people);
    CFRelease(peopleMutable);
    return arr;
}
-(void)allgroupsFor9Checked{
    
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]==CNAuthorizationStatusAuthorized) {
        CNContactStore *store = [[CNContactStore alloc]init];
        self.groups = [self allgroupsFor9WithStore:store];
        self.contacts = [self allContactsFor9WithStore:store];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContactUpdated object:self];
    }else{
        CNContactStore *store = [[CNContactStore alloc]init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                self.groups = [self allgroupsFor9WithStore:store];
                self.contacts = [self allContactsFor9WithStore:store];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContactUpdated object:self];
            }
        }];
    }
}
-(NSArray *)allgroupsFor9WithStore:(CNContactStore *)store{
    NSMutableArray *arr = [NSMutableArray new];
    for (CNGroup *group in [store groupsMatchingPredicate:nil error:nil]) {
        [arr addObject:[self groupFromCNRecode:group]];
    }
    return arr;
}
-(NSArray *)allContactsFor9WithStore:(CNContactStore *)store{
    NSMutableArray *arr = [NSMutableArray new];
    BOOL result = [store enumerateContactsWithFetchRequest:[[CNContactFetchRequest alloc] initWithKeysToFetch:kFetchedField] error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSDictionary *c = [self contactFromCNRecode:contact];
        if([self isContactValable:c])[arr addObject:c];
    }];
    if (result) {
        return arr;
    }else return @[];
}
-(CFArrayRef)contactsInGroup9Minus:(ABRecordRef)group{
    return  ABGroupCopyArrayOfAllMembers(group);
}
-(NSArray *)contactsInGroup9:(CNGroup *)group{
    NSMutableArray *arr = [NSMutableArray new];
    CNContactStore *store = [[CNContactStore alloc]init];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:kFetchedField];
    request.predicate = [CNContact predicateForContactsInGroupWithIdentifier:group.identifier];
    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [arr addObject:contact];
    }];
    return arr;
}
-(NSDictionary *)contactFromCNRecode:(CNContact *)contact{
    NSMutableArray *telArr = [NSMutableArray new];
    for (CNLabeledValue *v in contact.phoneNumbers) {
        [telArr addObject:[(CNPhoneNumber *)v.value stringValue]];
    }
    NSString *contactName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    return @{kContactServiceName:contactName,kServiceTels:telArr,kServicePinyin:[contactName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]]};
}
-(NSDictionary *)groupFromCNRecode:(CNGroup *)group{
    
    NSMutableArray *arr = [NSMutableArray new];
    NSArray * contactsInGroup = [self contactsInGroup9:group];
    for (int i=0; i<contactsInGroup.count; i++) {
        NSDictionary *c = [self contactFromCNRecode:contactsInGroup[i]];
        if([self isContactValable:c])[arr addObject:c];
    }
    return @{kGroupServiceName:group.name,kServicePinyin:[group.name pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],@"data":arr};
}
-(NSDictionary *)contactFromRecordId:(ABRecordRef)contact{
    CFTypeRef contactName = ABRecordCopyValue(contact, kABGroupNameProperty);
    ABMultiValueRef tels = ABRecordCopyValue(contact, kABPersonPhoneProperty);
    return @{kContactServiceName:(__bridge NSString *)contactName,kServiceTels:(__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(tels),kServicePinyin:[(__bridge NSString *)contactName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]]};
}
-(NSDictionary *)groupFromRecordId:(ABRecordRef)group{
    NSMutableArray *arr = [NSMutableArray new];
    CFArrayRef contactsInGroup = [self contactsInGroup9Minus:group];
    if (contactsInGroup) {
        for (int i=0; i<CFArrayGetCount(contactsInGroup); i++) {
            NSDictionary *c = [self contactFromRecordId:CFArrayGetValueAtIndex(contactsInGroup, i)];
            if([self isContactValable:c])[arr addObject:c];
        }
    }
    CFTypeRef groupName = ABRecordCopyValue(group, kABGroupNameProperty);
    return  @{kGroupServiceName:(__bridge NSString *)groupName,kServicePinyin:[(__bridge NSString *)groupName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],@"data":arr};
}
-(BOOL)isContactValable:(NSDictionary *)dic{
    return (dic[kContactServiceName]&&dic[kServiceTels])&&([dic[kContactServiceName] length]>0||[dic[kServiceTels] count]>0);
}
@end
