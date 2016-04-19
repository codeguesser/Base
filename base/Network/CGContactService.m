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
NSString *const kServiceDepartment = @"kServiceDepartment";
NSString *const kServiceJob = @"kServiceJob";
NSString *const kServiceBirthday = @"kServiceBirthday";
NSString *const kServiceNonGregorianBirthday = @"kServiceNonGregorianBirthday";
NSString *const kServiceNote = @"kServiceNote";
NSString *const kServiceEmails = @"kServiceEmails";
NSString *const kServicePostals = @"kServicePostals";
NSString *const kServiceDates = @"kServiceDates";
NSString *const kServiceUrls = @"kServiceUrls";
NSString *const kServiceRelations = @"kServiceRelations";
NSString *const kServiceProfiles = @"kServiceProfiles";
NSString *const kServiceIMs = @"kServiceIMs";

NSString *const kServiceTels = @"kServiceTels";
NSString *const kServiceContactId = @"kServiceContactId";
NSString *const kServiceContactPhoto = @"kServiceContactPhoto";

NSString *const kNotificationContactUpdated = @"kNotificationContactUpdated";
#define kFetchedField @[CNContactFamilyNameKey,CNContactGivenNameKey,CNContactMiddleNameKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactImageDataKey,CNContactDepartmentNameKey,CNContactJobTitleKey,CNContactBirthdayKey,CNContactNonGregorianBirthdayKey,CNContactNoteKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactDatesKey,CNContactUrlAddressesKey,CNContactRelationsKey,CNContactSocialProfilesKey,CNContactInstantMessageAddressesKey]
@interface CGContactService(){
    NSDateFormatter *formatter;
}
-(void)allgroupsFor9MinusChecked;
@end
@implementation CGContactService
- (instancetype)init
{
    self = [super init];
    if (self) {
        formatter = [NSDateFormatter dateFormatterWithFormat:@"yyyyMMdd"];
    }
    return self;
}
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
                                 @"contact_other":[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[self withoutFirstObjectFromData:tels] options:0 error:nil] encoding:NSUTF8StringEncoding]
                                 ,@"photo":contactDic[kServiceContactPhoto]?contactDic[kServiceContactPhoto]:[NSNull null],
                                 @"department":contactDic[kServiceDepartment],
                                 @"job":contactDic[kServiceJob],
                                 @"birthday":contactDic[kServiceBirthday],
                                 @"nonGregorianBirthday":contactDic[kServiceNonGregorianBirthday],
                                 @"note":contactDic[kServiceNote],
                                 @"emails":contactDic[kServiceEmails],
                                 @"postals":contactDic[kServicePostals],
                                 @"dates":contactDic[kServiceDates],
                                 @"urls":contactDic[kServiceUrls],
                                 @"relations":contactDic[kServiceRelations],
                                 @"profiles":contactDic[kServiceProfiles],
                                 @"ims":contactDic[kServiceIMs],
                                 }
                 ];
                [arrForCheck addObject:contactDic[kServiceContactId]];
            }
        }else{
            //改组没人
            [arr addObject:@{
                             @"group_title":groupDic[kGroupServiceName],
                             @"name":@"",
                             @"tel":@"",
                             @"photo":@"",
                             @"contact_other":@""}];
        }
    }
    //没有分组的，孤单的人
    for (NSDictionary *contactDic in self.contacts) {
        NSInteger originCount = arrForCheck.count;
        [arrForCheck addObject:contactDic[kServiceContactId]];
        if (originCount < arrForCheck.count) {
//            没有重复的(属于没分组的)，添加
            NSMutableArray *tels = [NSMutableArray new];
            for (NSString *tel in contactDic[kServiceTels]) {
                [tels addObject:@{@"type":@"mobile",@"type_title":@"手机",@"content":tel}];
            }
            [arr addObject:@{
                             @"group_title":@"",
                             @"name":[contactDic[kContactServiceName] length]>0?contactDic[kContactServiceName]:[contactDic[kServiceTels] firstObject],
                             @"tel":[contactDic[kServiceTels] count]>0?[contactDic[kServiceTels] firstObject]:@"",
                             @"contact_other":[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[self withoutFirstObjectFromData:tels] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]
                             ,@"photo":contactDic[kServiceContactPhoto]?contactDic[kServiceContactPhoto]:[NSNull null],
                             @"department":contactDic[kServiceDepartment],
                             @"job":contactDic[kServiceJob],
                             @"birthday":contactDic[kServiceBirthday],
                             @"nonGregorianBirthday":contactDic[kServiceNonGregorianBirthday],
                             @"note":contactDic[kServiceNote],
                             @"emails":contactDic[kServiceEmails],
                             @"postals":contactDic[kServicePostals],
                             @"dates":contactDic[kServiceDates],
                             @"urls":contactDic[kServiceUrls],
                             @"relations":contactDic[kServiceRelations],
                             @"profiles":contactDic[kServiceProfiles],
                             @"ims":contactDic[kServiceIMs],
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
    NSString *identifier = contact.identifier;
    NSString *contactName = [NSString stringWithFormat:@"%@%@%@",contact.familyName,contact.middleName,contact.givenName];
    UIImage *contactPhotoImage = contact.imageDataAvailable?[UIImage imageWithData:contact.imageData]:[UIImage new];
    
    NSMutableArray *telArr = [NSMutableArray new];
    for (CNLabeledValue *v in contact.phoneNumbers) {
        [telArr addObject:[(CNPhoneNumber *)v.value stringValue]];
    }
    NSArray *emailArr = [self formattedAarrayFromArray:contact.emailAddresses];
    NSArray *postalArr = [self formattedAarrayFromArray:contact.postalAddresses];
    NSArray *dateArr = [self formattedAarrayFromArray:contact.dates];
    NSArray *urlArr = [self formattedAarrayFromArray:contact.urlAddresses];
    NSArray *relationArr = [self formattedAarrayFromArray:contact.contactRelations];
    NSArray *profileArr = [self formattedAarrayFromArray:contact.socialProfiles];
    NSArray *imArr = [self formattedAarrayFromArray:contact.instantMessageAddresses];
    
    return @{kContactServiceName:contactName,kServiceTels:telArr,kServicePinyin:[contactName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],kServiceContactId:identifier,kServiceContactPhoto:contactPhotoImage,kServiceDepartment:contact.departmentName,
             kServiceJob:contact.jobTitle,kServiceBirthday:contact.birthday?[formatter stringFromDate:contact.birthday.date]:@"",kServiceNonGregorianBirthday:contact.nonGregorianBirthday?[formatter stringFromDate:contact.nonGregorianBirthday.date]:@"",kServiceNote:contact.note,kServiceEmails:emailArr,kServicePostals:postalArr,kServiceDates:dateArr,kServiceUrls:urlArr,kServiceRelations:relationArr,kServiceProfiles:profileArr,kServiceIMs:imArr};
}
-(NSArray <NSDictionary<NSString *,NSString *>*>*)formattedAarrayFromArray:(NSArray<CNLabeledValue*>*)arr{
    NSMutableArray *_arr = [NSMutableArray new];
    for (CNLabeledValue *v in arr) {
        [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:v.value}];
    }
    return _arr;
}
-(NSArray <NSDictionary<NSString *,NSString *>*>*)formattedAarrayFromMultiValue:(ABMultiValueRef)value{
    NSMutableArray *_arr = [NSMutableArray new];
    if(value&&ABMultiValueGetCount(value)>0){
        for (int i=0; i<ABMultiValueGetCount(value); i++) {
            [_arr addObject:@{(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(value, i)):(__bridge NSString *)ABMultiValueCopyValueAtIndex(value, i)}];
        }
    }
    return _arr;
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
    CFDataRef contactPhoto = ABPersonCopyImageDataWithFormat(contact, kABPersonImageFormatOriginalSize);
    UIImage *contactPhotoImage = [UIImage imageWithData:(__bridge NSData * _Nonnull)(contactPhoto)];
    if (contactPhotoImage) {
        
    }
    CFTypeRef contactName = ABRecordCopyValue(contact, kABPersonFirstNameProperty);
    CFTypeRef contactMiddleName = ABRecordCopyValue(contact, kABPersonMiddleNameProperty);
    CFTypeRef contactFamilyName = ABRecordCopyValue(contact, kABPersonLastNameProperty);
    CFTypeRef contactDepartmentName = ABRecordCopyValue(contact, kABPersonDepartmentProperty);
    CFTypeRef contactJob = ABRecordCopyValue(contact, kABPersonJobTitleProperty);
    CFTypeRef contactBirthday = ABRecordCopyValue(contact, kABPersonBirthdayProperty);
    CFTypeRef contactNonGregorianBirthday = ABRecordCopyValue(contact, kABPersonAlternateBirthdayProperty);
    CFTypeRef contactNote = ABRecordCopyValue(contact, kABPersonNoteProperty);
    NSString *identifier = [NSString stringWithFormat:@"%d",ABRecordGetRecordID(contact)];
    ABMultiValueRef tels = ABRecordCopyValue(contact, kABPersonPhoneProperty);
    ABMultiValueRef emails = ABRecordCopyValue(contact, kABPersonEmailProperty);
    ABMultiValueRef postals = ABRecordCopyValue(contact, kABPersonAddressProperty);
    ABMultiValueRef dates = ABRecordCopyValue(contact, kABPersonDateProperty);
    ABMultiValueRef urls = ABRecordCopyValue(contact, kABPersonURLProperty);
    ABMultiValueRef relations = ABRecordCopyValue(contact, kABPersonRelatedNamesProperty);
    ABMultiValueRef profiles = ABRecordCopyValue(contact, kABPersonSocialProfileProperty);
    ABMultiValueRef ims = ABRecordCopyValue(contact, kABPersonInstantMessageProperty);
    

    if(!contactName)contactName = @"";
    if(!contactMiddleName)contactMiddleName = @"";
    if(!contactFamilyName)contactFamilyName = @"";
    if(!contactDepartmentName)contactDepartmentName = @"";
    if(!contactJob)contactJob = @"";
    if(!contactBirthday)contactBirthday = @"";
    if(!contactNonGregorianBirthday)contactNonGregorianBirthday = @"";
    if(!contactNote)contactNote = @"";
    if(!contactPhotoImage)contactPhotoImage = [UIImage new];
    
    NSString *finalName = [NSString stringWithFormat:@"%@%@%@",(__bridge NSString *)contactFamilyName,(__bridge NSString *)contactMiddleName,(__bridge NSString *)contactName];
    NSString *finalDepartment = [NSString stringWithFormat:@"%@",contactDepartmentName];
    NSString *finalJob = [NSString stringWithFormat:@"%@",contactJob];
    NSString *finalBirthday = [NSString stringWithFormat:@"%@",contactBirthday];
    NSString *finalNonGregorianBirthday = [NSString stringWithFormat:@"%@",contactNonGregorianBirthday];
    NSString *finalNote = [NSString stringWithFormat:@"%@",contactNote];
    NSArray *targetArr = tels&&ABMultiValueGetCount(tels)>0?(__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(tels):@[];
    NSArray *targetEmailArr = [self formattedAarrayFromMultiValue:emails];
    NSArray *targetPostalArr = [self formattedAarrayFromMultiValue:postals];
    NSArray *dateArr = [self formattedAarrayFromMultiValue:dates];
    NSArray *urlArr = [self formattedAarrayFromMultiValue:urls];
    NSArray *relationArr = [self formattedAarrayFromMultiValue:relations];
    NSArray *profileArr = [self formattedAarrayFromMultiValue:profiles];
    NSArray *imArr = [self formattedAarrayFromMultiValue:ims];
    
    return @{kContactServiceName:finalName,kServiceTels:targetArr,kServicePinyin:[finalName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],kServiceContactId:identifier,kServiceContactPhoto:contactPhotoImage,kServiceDepartment:finalDepartment,kServiceJob:finalJob,kServiceBirthday:finalBirthday,kServiceNonGregorianBirthday:finalNonGregorianBirthday,kServiceNote:finalNote,kServiceEmails:targetEmailArr,kServicePostals:targetPostalArr,kServiceDates:dateArr,kServiceUrls:urlArr,kServiceRelations:relationArr,kServiceProfiles:profileArr,kServiceIMs:imArr};
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
    if (!groupName)groupName = @"";
    return  @{kGroupServiceName:(__bridge NSString *)groupName,kServicePinyin:[(__bridge NSString *)groupName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],@"data":arr};
}
-(BOOL)isContactValable:(NSDictionary *)dic{
    return (dic[kContactServiceName]&&dic[kServiceTels])&&([dic[kContactServiceName] length]>0||[dic[kServiceTels] count]>0);
}
-(NSArray *)withoutFirstObjectFromData:(NSArray *)arr{
    NSMutableArray *arrNew = [[NSMutableArray alloc] initWithArray:arr];
    if(arrNew.count>0)[arrNew removeObjectAtIndex:0];
    return arrNew;
}
@end
