//
//  CGContactService.m
//  base
//
//  Created by wsg on 15/11/19.
//  Copyright © 2015年 wsg. All rights reserved.
//

#import "CGContactService.h"
@import Contacts;
NSString *const kServicePinyin = @"kServicePinyin";

NSString *const kGroupServiceId = @"kGroupServiceId";
NSString *const kGroupServiceName = @"kGroupServiceName";

NSString *const kContactServiceId = @"kContactServiceId";
NSString *const kContactServiceName = @"kContactServiceName";
NSString *const kContactServiceFamilyName = @"kContactServiceFamilyName";
NSString *const kContactServiceGivenName = @"kContactServiceGivenName";
NSString *const kContactServiceMiddleName = @"kContactServiceMiddleName";
NSString *const kContactServiceNamePrefix = @"kContactServiceNamePrefix";
NSString *const kContactServicePreviousFamilyName = @"kContactServicePreviousFamilyName";
NSString *const kContactServiceSuffixName = @"kContactServiceSuffixName";
NSString *const kContactServiceNickName = @"kContactServiceNickName";
NSString *const kContactServicePhoneticGivenName = @"kContactServicePhoneticGivenName";
NSString *const kContactServicePhoneticMiddleName = @"kContactServicePhoneticMiddleName";
NSString *const kContactServicePhoneticFamilyName = @"kContactServicePhoneticFamilyName";
NSString *const kContactServiceType = @"kContactServiceType";
NSString *const kServiceContactPhoto = @"kServiceContactPhoto";
NSString *const kServiceCompany = @"kServiceCompany";
NSString *const kServiceDepartment = @"kServiceDepartment";
NSString *const kServiceJob = @"kServiceJob";
NSString *const kServiceBirthday = @"kServiceBirthday";
NSString *const kServiceNonGregorianBirthday = @"kServiceNonGregorianBirthday";
NSString *const kServiceNote = @"kServiceNote";
NSString *const kServiceTels = @"kServiceTels";
NSString *const kServiceEmails = @"kServiceEmails";
NSString *const kServicePostals = @"kServicePostals";
NSString *const kServiceDates = @"kServiceDates";
NSString *const kServiceUrls = @"kServiceUrls";
NSString *const kServiceRelations = @"kServiceRelations";
NSString *const kServiceProfiles = @"kServiceProfiles";
NSString *const kServiceIMs = @"kServiceIMs";



NSString *const kNotificationContactUpdated = @"kNotificationContactUpdated";
NSString *const kNotificationContactSaved = @"kNotificationContactSaved";
#define kFetchedField @[CNContactFamilyNameKey,CNContactGivenNameKey,CNContactMiddleNameKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactImageDataKey,CNContactDepartmentNameKey,CNContactJobTitleKey,CNContactBirthdayKey,CNContactNonGregorianBirthdayKey,CNContactNoteKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactDatesKey,CNContactUrlAddressesKey,CNContactRelationsKey,CNContactSocialProfilesKey,CNContactInstantMessageAddressesKey,CNContactOrganizationNameKey,CNContactNamePrefixKey,CNContactPreviousFamilyNameKey,CNContactNameSuffixKey,CNContactNicknameKey,CNContactPhoneticGivenNameKey,CNContactPhoneticMiddleNameKey,CNContactPhoneticFamilyNameKey,CNContactTypeKey]
@interface CGContactService(){
    NSDateFormatter *formatter;
}
-(void)allgroupsFor9MinusChecked:(void(^)(ABAddressBookRef addressBook))action;
@end
@implementation CGContactService
#pragma mark - system methods
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
    [s requestData];
    
    return s;
}
//+(void)sthComming:(NSNotification *)no{
//    DDLogInfo(@"%@",no);
//}

-(NSArray *)contactsForExport{
    NSMutableArray *arr = [NSMutableArray new];
    NSMutableSet *arrForCheck = [NSMutableSet new];//检验重复的人
    NSDictionary *(^contactFromData)(NSDictionary *,NSString *)=^(NSDictionary *contactDic,NSString *groupName){
        return @{
          @"group_title":groupName,
          @"family_name":!contactDic?@"":contactDic[kContactServiceFamilyName],
          @"given_name":!contactDic?@"":contactDic[kContactServiceGivenName],
          @"middle_name":!contactDic?@"":contactDic[kContactServiceMiddleName],
          @"name_prefix":!contactDic?@"":contactDic[kContactServiceNamePrefix],
          @"previous_family_name":!contactDic?@"":contactDic[kContactServicePreviousFamilyName],
          @"suffix_name":!contactDic?@"":contactDic[kContactServiceSuffixName],
          @"nick_name":!contactDic?@"":contactDic[kContactServiceNickName],
          @"phonetic_given_name":!contactDic?@"":contactDic[kContactServicePhoneticGivenName],
          @"phonetic_middle_name":!contactDic?@"":contactDic[kContactServicePhoneticMiddleName],
          @"phonetic_family_name":!contactDic?@"":contactDic[kContactServicePhoneticFamilyName],
          @"type":!contactDic?@"":contactDic[kContactServiceType],
          @"tels":!contactDic?@"":contactDic[kServiceTels],
          @"photo":!contactDic?@"":contactDic[kServiceContactPhoto]?contactDic[kServiceContactPhoto]:[NSNull null],
          @"department":!contactDic?@"":contactDic[kServiceDepartment],
          @"company":!contactDic?@"":contactDic[kServiceCompany],
          @"job":!contactDic?@"":contactDic[kServiceJob],
          @"birthday":!contactDic?@"":contactDic[kServiceBirthday],
          @"nonGregorianBirthday":!contactDic?@"":contactDic[kServiceNonGregorianBirthday],
          @"note":!contactDic?@"":contactDic[kServiceNote],
          @"emails":!contactDic?@"":contactDic[kServiceEmails],
          @"postals":!contactDic?@"":contactDic[kServicePostals],
          @"dates":!contactDic?@"":contactDic[kServiceDates],
          @"urls":!contactDic?@"":contactDic[kServiceUrls],
          @"relations":!contactDic?@"":contactDic[kServiceRelations],
          @"profiles":!contactDic?@"":contactDic[kServiceProfiles],
          @"ims":!contactDic?@"":contactDic[kServiceIMs],
          };
    };
    //通过分组得到人
    for (NSDictionary *groupDic in self.groups) {
        if ([groupDic[@"data"] count]>0) {
            //该组有人
            for (NSDictionary *contactDic in groupDic[@"data"]) {
                [arr addObject:contactFromData(contactDic,groupDic[kGroupServiceName])];
                [arrForCheck addObject:contactDic[kContactServiceId]];
            }
        }else{
            //改组没人
            [arr addObject:contactFromData(nil,groupDic[kGroupServiceName])];
        }
    }
    //没有分组的，孤单的人
    for (NSDictionary *contactDic in self.contacts) {
        NSInteger originCount = arrForCheck.count;
        [arrForCheck addObject:contactDic[kContactServiceId]];
        if (originCount < arrForCheck.count) {
//            没有重复的(属于没分组的)，添加
            [arr addObject:contactFromData(contactDic,@"")];
        }
        
    }
    return arr;
}
-(BOOL)saveWithContacts:(NSArray *)__contacts{
    
    NSDictionary *(^contactFromData)(NSDictionary *,NSString *) = ^(NSDictionary *dic,NSString *idx){
        NSMutableDictionary *_dic = [NSMutableDictionary new];
        _dic[kContactServiceFamilyName] = dic[@"family_name"],
        _dic[kContactServiceGivenName] = dic[@"given_name"],
        _dic[kContactServiceMiddleName] = dic[@"middle_name"],
        _dic[kContactServiceNamePrefix] = dic[@"name_prefix"],
        _dic[kContactServicePreviousFamilyName] = dic[@"previous_family_name"],
        _dic[kContactServiceSuffixName] = dic[@"suffix_name"],
        _dic[kContactServiceNickName] = dic[@"nick_name"],
        _dic[kContactServicePhoneticGivenName] = dic[@"phonetic_given_name"],
        _dic[kContactServicePhoneticMiddleName] = dic[@"phonetic_middle_name"],
        _dic[kContactServicePhoneticFamilyName] = dic[@"phonetic_family_name"],
        _dic[kContactServiceType] = dic[@"type"],
        _dic[kServiceTels] = dic[@"tels"];
        _dic[kServiceContactPhoto] = dic[@"photo"];
        _dic[kServiceCompany] = dic[@"company"];
        _dic[kServiceDepartment] = dic[@"department"];
        _dic[kServiceJob] = dic[@"job"];
        _dic[kServiceBirthday] = dic[@"birthday"];
        _dic[kServiceNonGregorianBirthday] = dic[@"nonGregorianBirthday"];
        _dic[kServiceNote] = dic[@"note"];
        _dic[kServiceEmails] = dic[@"emails"];
        _dic[kServicePostals] = dic[@"postals"];
        _dic[kServiceDates] = dic[@"dates"];
        _dic[kServiceUrls] = dic[@"urls"];
        _dic[kServiceRelations] = dic[@"relations"];
        _dic[kServiceIMs] = dic[@"ims"];
        _dic[kServicePinyin] = [_dic[kContactServiceName] pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]];
        _dic[kContactServiceId] = idx;
        return _dic;
    };
    NSMutableDictionary *allGroups = [NSMutableDictionary new];
    NSMutableArray *allContacts = [NSMutableArray new];
    NSInteger idx_contact = 0;
    NSInteger idx_group = 0;
    for (NSDictionary *contacts in __contacts) {
        if (allGroups[contacts[@"group_title"]]) {
            [allGroups[contacts[@"group_title"]][@"data"] addObject:contactFromData(contacts,[NSString stringWithFormat:@"%ld",(long)idx_contact])];
        }else{
            NSMutableDictionary *groupDic = [NSMutableDictionary new];
            groupDic[kGroupServiceName] = contacts[@"group_title"];
            groupDic[kGroupServiceId] = [NSString stringWithFormat:@"%ld",(long)idx_group];
            groupDic[@"data"] = [NSMutableArray new];
            [groupDic[@"data"] addObject:contactFromData(contacts,[NSString stringWithFormat:@"%ld",(long)idx_contact])];
            allGroups[contacts[@"group_title"]] = groupDic;
            idx_group++;
        }
        [allContacts addObject:contacts];
        idx_contact++;
    }
    self.contacts = allContacts;
    self.groups = allGroups.allValues;
    
    [self saveData];
    return YES;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@\n%@",self.contacts,self.groups];
}
#pragma mark - you should request power for it
-(void)allgroupsFor9MinusChecked:(void(^)(ABAddressBookRef addressBook))action{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, nil);
    if (ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusAuthorized) {
        CFRetain(addressBook);
        action(addressBook);
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
                dispatch_semaphore_signal(sema);
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CFRetain(addressBook);
                        action(addressBook);
                    });
                }
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        });
    }
}
-(void)allgroupsFor9Checked:(void(^)(CNContactStore *))action{
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]==CNAuthorizationStatusAuthorized) {
        CNContactStore *store = [[CNContactStore alloc]init];
        action(store);
    }else{
        CNContactStore *store = [[CNContactStore alloc]init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                action(store);
            }
        }];
    }
}
#pragma mark - ###### GET groups and contacts
-(void)requestData{
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=9) {
        [self allgroupsFor9Checked:^(CNContactStore *store) {
            self.groups = [self allgroupsFor9WithStore:store];
            self.contacts = [self allContactsFor9WithStore:store];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContactUpdated object:self];
        }];
    }else{
        [self allgroupsFor9MinusChecked:^(ABAddressBookRef addressBook) {
            self.contacts = [self allContactsFor9MinusWithAddress:addressBook];
            self.groups = [self allgroupsFor9MinusWithAddress:addressBook];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContactUpdated object:self];
        }];
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
// MARK:: cell for get data
-(NSDictionary *)contactFromCNRecode:(CNContact *)contact{
    NSString *identifier = contact.identifier;
    NSString *contactName = [NSString stringWithFormat:@"%@%@%@",contact.familyName,contact.middleName,contact.givenName];
    UIImage *contactPhotoImage = contact.imageDataAvailable?[UIImage imageWithData:contact.imageData]:[UIImage new];
    
    NSArray *telArr = [self formattedArrayFromArray:contact.phoneNumbers];
    NSArray *emailArr = [self formattedArrayFromArray:contact.emailAddresses];
    NSArray *postalArr = [self formattedArrayFromArray:contact.postalAddresses];
    NSArray *dateArr = [self formattedArrayFromArray:contact.dates];
    NSArray *urlArr = [self formattedArrayFromArray:contact.urlAddresses];
    NSArray *relationArr = [self formattedArrayFromArray:contact.contactRelations];
    NSArray *profileArr = [self formattedArrayFromArray:contact.socialProfiles];
    NSArray *imArr = [self formattedArrayFromArray:contact.instantMessageAddresses];
    return @{kContactServiceName:contactName,kContactServiceFamilyName:contact.familyName,kContactServiceGivenName:contact.givenName,kContactServiceMiddleName:contact.middleName,kContactServiceNamePrefix:contact.namePrefix,kContactServicePreviousFamilyName:contact.previousFamilyName,kContactServiceSuffixName:contact.nameSuffix,kContactServiceNickName:contact.nickname,kContactServicePhoneticGivenName:contact.phoneticGivenName,kContactServicePhoneticMiddleName:contact.phoneticMiddleName,kContactServicePhoneticFamilyName:contact.phoneticFamilyName,kContactServiceType:@(contact.contactType),kServiceTels:telArr,kServicePinyin:[contactName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],kContactServiceId:identifier,kServiceContactPhoto:contactPhotoImage,kServiceDepartment:contact.departmentName,
             kServiceJob:contact.jobTitle,kServiceBirthday:contact.birthday?[formatter stringFromDate:contact.birthday.date]:@"",kServiceNonGregorianBirthday:[self formattedDateComponentFromComponent:contact.nonGregorianBirthday],kServiceNote:contact.note,kServiceEmails:emailArr,kServicePostals:postalArr,kServiceDates:dateArr,kServiceUrls:urlArr,kServiceRelations:relationArr,kServiceProfiles:profileArr,kServiceIMs:imArr,kServiceCompany:contact.organizationName};
}

-(NSDictionary *)groupFromCNRecode:(CNGroup *)group{
    
    NSMutableArray *arr = [NSMutableArray new];
    NSArray * contactsInGroup = [self contactsInGroup9:group];
    for (int i=0; i<contactsInGroup.count; i++) {
        NSDictionary *c = [self contactFromCNRecode:contactsInGroup[i]];
        if([self isContactValable:c])[arr addObject:c];
    }
    return @{kGroupServiceName:group.name,kServicePinyin:[group.name pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],@"data":arr,kGroupServiceId:group.identifier};
}
-(NSDictionary *)contactFromRecordId:(ABRecordRef)contact{
    CFDataRef contactPhoto = ABPersonCopyImageDataWithFormat(contact, kABPersonImageFormatOriginalSize);
    UIImage *contactPhotoImage = [UIImage imageWithData:(__bridge NSData * _Nonnull)(contactPhoto)];
    if (contactPhotoImage) {
        
    }
    CFTypeRef contactFirstName              = ABRecordCopyValue(contact, kABPersonFirstNameProperty);
    CFTypeRef contactMiddleName             = ABRecordCopyValue(contact, kABPersonMiddleNameProperty);
    CFTypeRef contactFamilyName             = ABRecordCopyValue(contact, kABPersonLastNameProperty);
    CFTypeRef contactNamePrefix             = ABRecordCopyValue(contact, kABPersonPrefixProperty);
    CFTypeRef contactPreviousFamilyName     = NULL;
    CFTypeRef contactNameSuffix             = ABRecordCopyValue(contact, kABPersonSuffixProperty);
    CFTypeRef contactNickName               = ABRecordCopyValue(contact, kABPersonNicknameProperty);
    CFTypeRef contactPhoneticFamilyName               = ABRecordCopyValue(contact, kABPersonLastNamePhoneticProperty);
    CFTypeRef contactPhoneticMiddleName               = ABRecordCopyValue(contact, kABPersonMiddleNamePhoneticProperty);
    CFTypeRef contactPhoneticFirstName               = ABRecordCopyValue(contact, kABPersonFirstNamePhoneticProperty);
    CFTypeRef contactType                   = ABRecordCopyValue(contact, kABPersonKindProperty);
    CFTypeRef contactCompany                = ABRecordCopyValue(contact, kABPersonOrganizationProperty);
    CFTypeRef contactDepartmentName         = ABRecordCopyValue(contact, kABPersonDepartmentProperty);
    CFTypeRef contactJob                    = ABRecordCopyValue(contact, kABPersonJobTitleProperty);
    CFTypeRef contactBirthday               = ABRecordCopyValue(contact, kABPersonBirthdayProperty);
    CFTypeRef contactNonGregorianBirthday   = ABRecordCopyValue(contact, kABPersonAlternateBirthdayProperty);
    CFTypeRef contactNote                   = ABRecordCopyValue(contact, kABPersonNoteProperty);
    NSString *identifier        = [NSString stringWithFormat:@"%d",ABRecordGetRecordID(contact)];
    ABMultiValueRef tels        = ABRecordCopyValue(contact, kABPersonPhoneProperty);
    ABMultiValueRef emails      = ABRecordCopyValue(contact, kABPersonEmailProperty);
    ABMultiValueRef postals     = ABRecordCopyValue(contact, kABPersonAddressProperty);
    ABMultiValueRef dates       = ABRecordCopyValue(contact, kABPersonDateProperty);
    ABMultiValueRef urls        = ABRecordCopyValue(contact, kABPersonURLProperty);
    ABMultiValueRef relations   = ABRecordCopyValue(contact, kABPersonRelatedNamesProperty);
    ABMultiValueRef profiles    = ABRecordCopyValue(contact, kABPersonSocialProfileProperty);
    ABMultiValueRef ims         = ABRecordCopyValue(contact, kABPersonInstantMessageProperty);
    
    
    if(!contactFirstName)contactFirstName = @"";
    if(!contactMiddleName)contactMiddleName = @"";
    if(!contactFamilyName)contactFamilyName = @"";
    if(!contactNamePrefix)contactNamePrefix = @"";
    if(!contactNameSuffix)contactNameSuffix = @"";
    if(!contactPreviousFamilyName)contactPreviousFamilyName = @"";
    if(!contactNickName)contactNickName = @"";
    if(!contactPhoneticFamilyName)contactPhoneticFamilyName = @"";
    if(!contactPhoneticMiddleName)contactPhoneticMiddleName = @"";
    if(!contactPhoneticFirstName)contactPhoneticFirstName = @"";
    if(!contactType)contactType = @"";
    if(!contactDepartmentName)contactDepartmentName = @"";
    if(!contactCompany)contactCompany = @"";
    if(!contactJob)contactJob = @"";
    if(!contactBirthday)contactBirthday = @"";
    if(!contactNonGregorianBirthday)contactNonGregorianBirthday = @"";
    if(!contactNote)contactNote = @"";
    if(!contactPhotoImage)contactPhotoImage = [UIImage new];
    
    NSString *finalName         = [NSString stringWithFormat:@"%@%@%@",(__bridge NSString *)contactFamilyName,(__bridge NSString *)contactMiddleName,(__bridge NSString *)contactFirstName];
    NSString *finalFirstName = [NSString stringWithFormat:@"%@",contactFirstName];
    NSString *finalFamilyName = [NSString stringWithFormat:@"%@",contactFamilyName];
    NSString *finalMiddleName = [NSString stringWithFormat:@"%@",contactMiddleName];
    NSString *finalNamePrefix = [NSString stringWithFormat:@"%@",contactNamePrefix];
    NSString *finalNameSuffix = [NSString stringWithFormat:@"%@",contactNameSuffix];
    NSString *finalPreviousFamilyName = [NSString stringWithFormat:@"%@",contactPreviousFamilyName];
    NSString *finalNickName = [NSString stringWithFormat:@"%@",contactNickName];
    NSString *finalPhoneticFamilyName = [NSString stringWithFormat:@"%@",contactPhoneticFamilyName];
    NSString *finalPhoneticMiddleName = [NSString stringWithFormat:@"%@",contactPhoneticMiddleName];
    NSString *finalPhoneticFirstName = [NSString stringWithFormat:@"%@",contactPhoneticFirstName];
    NSString *finalType = [NSString stringWithFormat:@"%@",contactType];
    NSString *finalCompany      = [NSString stringWithFormat:@"%@",contactCompany];
    NSString *finalDepartment   = [NSString stringWithFormat:@"%@",contactDepartmentName];
    NSString *finalJob          = [NSString stringWithFormat:@"%@",contactJob];
    NSString *finalBirthday     = [(__bridge NSDate *)contactBirthday isKindOfClass:[NSDate class]]?[formatter stringFromDate:(__bridge NSDate *)contactBirthday]:@"";
    NSDictionary *finalNonGregorianBirthday = [(__bridge NSDictionary *)contactNonGregorianBirthday isKindOfClass:[NSDictionary class]]?(__bridge NSDictionary *)contactNonGregorianBirthday:@{};
    NSString *finalNote         = [NSString stringWithFormat:@"%@",contactNote];
    //    NSArray *targetArr          = tels&&ABMultiValueGetCount(tels)>0?(__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(tels):@[];
    NSArray *targetTelArr = [self formattedArrayFromMultiValue:tels property:kABPersonPhoneProperty];
    NSArray *targetEmailArr = [self formattedArrayFromMultiValue:emails property:kABPersonEmailProperty];
    NSArray *targetPostalArr = [self formattedArrayFromMultiValue:postals property:kABPersonAddressProperty];
    NSArray *dateArr = [self formattedArrayFromMultiValue:dates property:kABPersonDateProperty];
    NSArray *urlArr = [self formattedArrayFromMultiValue:urls property:kABPersonURLProperty];
    NSArray *relationArr = [self formattedArrayFromMultiValue:relations property:kABPersonRelatedNamesProperty];
    NSArray *profileArr = [self formattedArrayFromMultiValue:profiles property:kABPersonSocialProfileProperty];
    NSArray *imArr = [self formattedArrayFromMultiValue:ims property:kABPersonInstantMessageProperty];
    
    return @{kContactServiceName:finalName,kContactServiceFamilyName:finalFamilyName,kContactServiceGivenName:finalFirstName,kContactServiceMiddleName:finalMiddleName,kContactServiceNamePrefix:finalNamePrefix,kContactServicePreviousFamilyName:finalPreviousFamilyName,kContactServiceSuffixName:finalNameSuffix,kContactServiceNickName:finalNickName,kContactServicePhoneticGivenName:finalPhoneticFirstName,kContactServicePhoneticMiddleName:finalPhoneticMiddleName,kContactServicePhoneticFamilyName:finalPhoneticFamilyName,kContactServiceType:finalType,kServiceTels:targetTelArr,kServicePinyin:[finalName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],kContactServiceId:identifier,kServiceContactPhoto:contactPhotoImage,kServiceDepartment:finalDepartment,kServiceJob:finalJob,kServiceBirthday:finalBirthday,kServiceNonGregorianBirthday:finalNonGregorianBirthday,kServiceNote:finalNote,kServiceEmails:targetEmailArr,kServicePostals:targetPostalArr,kServiceDates:dateArr,kServiceUrls:urlArr,kServiceRelations:relationArr,kServiceProfiles:profileArr,kServiceIMs:imArr,kServiceCompany:finalCompany};
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
    NSString *identifier        = [NSString stringWithFormat:@"%d",ABRecordGetRecordID(group)];
    if (!groupName)groupName = @"";
    return  @{kGroupServiceName:(__bridge NSString *)groupName,kServicePinyin:[(__bridge NSString *)groupName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],@"data":arr,kGroupServiceId:identifier};
}
#pragma mark - ###### WRITE contacts and groups
-(void)saveData{
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=9) {
        [self allgroupsFor9Checked:^(CNContactStore *store) {
//            [self cleanAllDataFor9FromStore:store];
            for (NSDictionary *group in self.groups) {
                CNGroup *savedGroup = [self writeGroupsFor9:group toStore:store];
                for (NSDictionary *contact in group[@"data"]) {
                    CNContact *savedContact = [self writeContactsFor9:contact inStore:store];
                    [self moveContactFor9:savedContact toGroup:savedGroup inStore:store];
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContactSaved object:self];
        }];
    }else{
        [self allgroupsFor9MinusChecked:^(ABAddressBookRef addressBook) {
//            [self cleanAllDataFor9MinusFromAddress:addressBook];
            for (NSDictionary *group in self.groups) {
                ABRecordRef savedGroup = [self writeGroupsFor9Minus:group toAddress:addressBook];
                for (NSDictionary *contact in group[@"data"]) {
                    ABRecordRef savedContact = [self writeContactsFor9Minus:contact toAddress:addressBook];
                    [self moveContactFor9Minus:savedContact toGroup:savedGroup];
                }
            }
            ABAddressBookSave(addressBook, nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContactSaved object:self];
        }];
    }
}
-(BOOL)moveContactFor9:(CNContact *)contact toGroup:(CNGroup *)group inStore:(CNContactStore *)store{
    CNSaveRequest *request = [[CNSaveRequest  alloc] init];
    [request addMember:contact toGroup:group];
    return [store executeSaveRequest:request error:nil];
}
-(bool)moveContactFor9Minus:(ABRecordRef)contact toGroup:(ABRecordRef)group{
    return ABGroupAddMember(group, contact, NULL);
}
-(void)cleanAllDataFor9FromStore:(CNContactStore *)store{
    for (CNGroup *group in [store groupsMatchingPredicate:nil error:nil]) {
        CNSaveRequest *request = [[CNSaveRequest  alloc] init];
        [request deleteGroup:group];
        [store executeSaveRequest:request error:nil];
    }
    [store enumerateContactsWithFetchRequest:[[CNContactFetchRequest alloc] initWithKeysToFetch:kFetchedField] error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        CNSaveRequest *request = [[CNSaveRequest  alloc] init];
        [request deleteContact:contact];
        [store executeSaveRequest:request error:nil];
    }];
}
-(void)cleanAllDataFor9MinusFromAddress:(ABAddressBookRef)address{
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(address);
    CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(
                                                               kCFAllocatorDefault,
                                                               CFArrayGetCount(people),
                                                               people
                                                               );
    NSMutableArray *translateArr = (__bridge NSMutableArray *)(peopleMutable);
    for (int i=0; i<translateArr.count; i++) {
        ABAddressBookRemoveRecord(address, (__bridge ABRecordRef)[translateArr objectAtIndex:i], nil);
    }
    CFRelease(people);
    CFRelease(peopleMutable);
    
    CFArrayRef group = ABAddressBookCopyArrayOfAllGroups(address);
    CFMutableArrayRef groupMutable = CFArrayCreateMutableCopy(
                                                              kCFAllocatorDefault,
                                                              CFArrayGetCount(group),
                                                              group
                                                              );
    
    
    NSMutableArray *translateGroupArr = (__bridge NSMutableArray *)(groupMutable);
    for (int i=0; i<translateGroupArr.count; i++) {
        ABAddressBookRemoveRecord(address, (__bridge ABRecordRef)[translateGroupArr objectAtIndex:i], nil);
    }
    CFRelease(group);
    CFRelease(groupMutable);
}
// MARK:: cell for write data
-(CNContact *)writeContactsFor9:(NSDictionary *)dic inStore:(CNContactStore *)store{
    CNSaveRequest *request = [[CNSaveRequest  alloc] init];
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    contact.familyName = dic[kContactServiceFamilyName];
    contact.givenName = dic[kContactServiceGivenName];
    contact.middleName = dic[kContactServiceMiddleName];
    contact.namePrefix = dic[kContactServiceNamePrefix];
    contact.previousFamilyName = dic[kContactServicePreviousFamilyName];
    contact.nameSuffix = dic[kContactServiceSuffixName];
    contact.nickname = dic[kContactServiceNickName];
    contact.phoneticGivenName = dic[kContactServicePhoneticGivenName];
    contact.phoneticMiddleName = dic[kContactServicePhoneticMiddleName];
    contact.phoneticFamilyName = dic[kContactServicePhoneticFamilyName];
    contact.contactType = [dic[kContactServiceType] integerValue];
    [request addContact:contact toContainerWithIdentifier:nil];
    BOOL isSuccessed = [store executeSaveRequest:request error:nil];
    return isSuccessed?contact:nil;
}
-(CNGroup *)writeGroupsFor9:(NSDictionary *)dic toStore:(CNContactStore *)store{
    CNSaveRequest *request = [[CNSaveRequest  alloc] init];
    CNMutableGroup *group = [[CNMutableGroup alloc] init];
    group.name = dic[kGroupServiceName];
    [request addGroup:group toContainerWithIdentifier:nil];
    BOOL isSuccessed = [store executeSaveRequest:request error:nil];
    return isSuccessed?group:nil;
}
-(ABRecordRef)writeContactsFor9Minus:(NSDictionary *)dic toAddress:(ABAddressBookRef)address{
    ABRecordRef contact = ABPersonCreate();
    {
        if([dic[kServiceContactPhoto] isKindOfClass:[UIImage class]])ABPersonSetImageData(contact, (__bridge CFDataRef)(UIImagePNGRepresentation(dic[kServiceContactPhoto])), nil);
        
        ABRecordSetValue(contact, kABPersonFirstNameProperty, (__bridge CFTypeRef)(dic[kContactServiceGivenName]), nil);
        ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFTypeRef)(dic[kContactServiceFamilyName]), nil);
        ABRecordSetValue(contact, kABPersonMiddleNameProperty, (__bridge CFTypeRef)(dic[kContactServiceMiddleName]), nil);
        ABRecordSetValue(contact, kABPersonLastNamePhoneticProperty, (__bridge CFTypeRef)(dic[kContactServicePhoneticFamilyName]), nil);
        ABRecordSetValue(contact, kABPersonFirstNamePhoneticProperty, (__bridge CFTypeRef)(dic[kContactServicePhoneticGivenName]), nil);
        ABRecordSetValue(contact, kABPersonMiddleNamePhoneticProperty, (__bridge CFTypeRef)(dic[kContactServicePhoneticMiddleName]), nil);
        ABRecordSetValue(contact, kABPersonPrefixProperty, (__bridge CFTypeRef)(dic[kContactServiceNamePrefix]), nil);
        ABRecordSetValue(contact, kABPersonSuffixProperty, (__bridge CFTypeRef)(dic[kContactServiceSuffixName]), nil);
        ABRecordSetValue(contact, kABPersonKindProperty, (__bridge CFTypeRef)(@([dic[kContactServiceType] integerValue])), nil);
        ABRecordSetValue(contact, kABPersonOrganizationProperty, (__bridge CFTypeRef)(dic[kServiceCompany]), nil);
        ABRecordSetValue(contact, kABPersonDepartmentProperty, (__bridge CFTypeRef)(dic[kServiceDepartment]), nil);
        ABRecordSetValue(contact, kABPersonJobTitleProperty, (__bridge CFTypeRef)(dic[kServiceJob]), nil);
        ABRecordSetValue(contact, kABPersonBirthdayProperty, (__bridge CFTypeRef)(dic[kServiceBirthday]), nil);
        ABRecordSetValue(contact, kABPersonAlternateBirthdayProperty, (__bridge CFTypeRef)(dic[kServiceNonGregorianBirthday]), nil);
        ABRecordSetValue(contact, kABPersonNoteProperty, (__bridge CFTypeRef)(dic[kServiceNote]), nil);
        ABRecordSetValue(contact, kABPersonPhoneProperty, [self deFormattedArrayFromMultiValue:dic[kServiceTels] property:kABPersonPhoneProperty], nil);
        ABRecordSetValue(contact, kABPersonAddressProperty, [self deFormattedArrayFromMultiValue:dic[kServicePostals] property:kABPersonAddressProperty], nil);
        
//        ABMultiValueRef emails      = ABRecordCopyValue(contact, kABPersonEmailProperty);
//        ABMultiValueRef postals     = ABRecordCopyValue(contact, kABPersonAddressProperty);
//        ABMultiValueRef dates       = ABRecordCopyValue(contact, kABPersonDateProperty);
//        ABMultiValueRef urls        = ABRecordCopyValue(contact, kABPersonURLProperty);
//        ABMultiValueRef relations   = ABRecordCopyValue(contact, kABPersonRelatedNamesProperty);
//        ABMultiValueRef profiles    = ABRecordCopyValue(contact, kABPersonSocialProfileProperty);
//        ABMultiValueRef ims         = ABRecordCopyValue(contact, kABPersonInstantMessageProperty);
//        
//        NSArray *targetTelArr = [self formattedArrayFromMultiValue:tels property:kABPersonPhoneProperty];
//        NSArray *targetEmailArr = [self formattedArrayFromMultiValue:emails property:kABPersonEmailProperty];
//        NSArray *targetPostalArr = [self formattedArrayFromMultiValue:postals property:kABPersonAddressProperty];
//        NSArray *dateArr = [self formattedArrayFromMultiValue:dates property:kABPersonDateProperty];
//        NSArray *urlArr = [self formattedArrayFromMultiValue:urls property:kABPersonURLProperty];
//        NSArray *relationArr = [self formattedArrayFromMultiValue:relations property:kABPersonRelatedNamesProperty];
//        NSArray *profileArr = [self formattedArrayFromMultiValue:profiles property:kABPersonSocialProfileProperty];
//        NSArray *imArr = [self formattedArrayFromMultiValue:ims property:kABPersonInstantMessageProperty];
    }
    
    
    
    //    ABRecordSetValue(contact, <#ABPropertyID property#>, <#CFTypeRef value#>, <#CFErrorRef *error#>)
    bool isSuccess = ABAddressBookAddRecord(address, contact, NULL);
    return isSuccess?contact:NULL;
}
-(ABRecordRef)writeGroupsFor9Minus:(NSDictionary *)dic toAddress:(ABAddressBookRef)address{
    ABRecordRef group = ABGroupCreate();
    ABRecordSetValue(group, kABGroupNameProperty, (__bridge CFTypeRef)(dic[kGroupServiceName]), NULL);
    bool isSuccess = ABAddressBookAddRecord(address, group, NULL);
    return isSuccess?group:NULL;
}
#pragma mark - private methods
-(NSDictionary *)formattedDateComponentFromComponent:(NSDateComponents *)comp{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (comp&&[comp isKindOfClass:[NSDateComponents class]]) {
        dic[@"calendarIdentifier"] = comp.calendar.calendarIdentifier;
        dic[@"day"] = @(comp.day);
        dic[@"era"] = @(comp.era);
        dic[@"isLeapMonth"] = @(comp.isLeapMonth);
        dic[@"month"] = @(comp.month);
        dic[@"year"] = @(comp.year);
    }
    return dic;
}
-(NSDateComponents *)deFormattedDateComponentFromDictionary:(NSDictionary *)dic{
    NSDateComponents *component = [[NSDateComponents alloc]init];
    if (dic&&[dic isKindOfClass:[NSDictionary class]]&&dic[@"calendarIdentifier"]) {
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:dic[@"calendarIdentifier"]];
        component.calendar = gregorian;
        component.day = [dic[@"day"] intValue];
        component.era = [dic[@"era"] intValue];
        component.month = [dic[@"month"] intValue];
        component.year = [dic[@"year"] intValue];
    }
    return component;
}
-(NSArray <NSDictionary<NSString *,NSString *>*>*)formattedArrayFromArray:(NSArray<CNLabeledValue*>*)arr{
    NSMutableArray *_arr = [NSMutableArray new];
    for (CNLabeledValue *v in arr) {
        if ([v.value isKindOfClass:[NSString class]]) {
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:v.value}];
        }else if ([v.value isKindOfClass:[CNPostalAddress class]]){
            CNPostalAddress *_v = (CNPostalAddress *)v.value;
            
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:
                                  @{
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressStreetKey]:_v.street,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressCityKey]:_v.city,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressStateKey]:_v.state,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressPostalCodeKey]:_v.postalCode,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressCountryKey]:_v.country,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressISOCountryCodeKey]:_v.ISOCountryCode,
                                      @"Street":_v.street,
                                      @"City":_v.city,
                                      @"State":_v.state,
                                      @"ZIP":_v.postalCode,
                                      @"Country":_v.country,
                                      @"CountryCode":_v.ISOCountryCode,
                                      }}];
        }else if ([v.value isKindOfClass:[CNPhoneNumber class]]){
            CNPhoneNumber *_v = (CNPhoneNumber *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:_v.stringValue}];
        }else if ([v.value isKindOfClass:[CNContactRelation class]]){
            CNContactRelation *_v = (CNContactRelation *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:_v.name}];
        }else if ([v.value isKindOfClass:[CNSocialProfile class]]){
            CNSocialProfile *_v = (CNSocialProfile *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:
                                  @{
                                      //                                      [CNSocialProfile localizedStringForKey:CNSocialProfileURLStringKey]:_v.urlString,
                                      //                                      [CNSocialProfile localizedStringForKey:CNSocialProfileUsernameKey]:_v.username,
                                      //                                      [CNSocialProfile localizedStringForKey:CNSocialProfileUserIdentifierKey]:_v.userIdentifier?_v.userIdentifier:@"",
                                      //                                      [CNSocialProfile localizedStringForKey:CNSocialProfileServiceKey]:[CNSocialProfile localizedStringForService:_v.service],
                                      @"url":_v.urlString,
                                      @"username":_v.username,
                                      @"userIdentifier":_v.userIdentifier?_v.userIdentifier:@"",
                                      @"service":_v.service,
                                      }}];
            
        }else if ([v.value isKindOfClass:[CNInstantMessageAddress class]]){
            CNInstantMessageAddress *_v = (CNInstantMessageAddress *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:
                                  @{
                                      [CNInstantMessageAddress localizedStringForKey:CNInstantMessageAddressUsernameKey]:_v.username,
                                      [CNInstantMessageAddress localizedStringForKey:CNInstantMessageAddressServiceKey]:_v.service,
                                      }}];
        }else if ([v.value isKindOfClass:[NSDateComponents class]]){
            NSDateComponents *_v = (NSDateComponents *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:[formatter stringFromDate:_v.date]}];
        }
        
    }
    return _arr;
}
-(NSArray<CNLabeledValue*>*)deFormattedArrayFromArray:(NSArray <NSDictionary<NSString *,NSString *>*>*)arr{
    NSMutableArray *_arr = [NSMutableArray new];
    for (CNLabeledValue *v in arr) {
        if ([v.value isKindOfClass:[NSString class]]) {
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:v.value}];
        }else if ([v.value isKindOfClass:[CNPostalAddress class]]){
            CNPostalAddress *_v = (CNPostalAddress *)v.value;
            
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:
                                  @{
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressStreetKey]:_v.street,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressCityKey]:_v.city,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressStateKey]:_v.state,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressPostalCodeKey]:_v.postalCode,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressCountryKey]:_v.country,
                                      //                                      [CNPostalAddress localizedStringForKey:CNPostalAddressISOCountryCodeKey]:_v.ISOCountryCode,
                                      @"Street":_v.street,
                                      @"City":_v.city,
                                      @"State":_v.state,
                                      @"ZIP":_v.postalCode,
                                      @"Country":_v.country,
                                      @"CountryCode":_v.ISOCountryCode,
                                      }}];
        }else if ([v.value isKindOfClass:[CNPhoneNumber class]]){
            CNPhoneNumber *_v = (CNPhoneNumber *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:_v.stringValue}];
        }else if ([v.value isKindOfClass:[CNContactRelation class]]){
            CNContactRelation *_v = (CNContactRelation *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:_v.name}];
        }else if ([v.value isKindOfClass:[CNSocialProfile class]]){
            CNSocialProfile *_v = (CNSocialProfile *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:
                                  @{
                                      //                                      [CNSocialProfile localizedStringForKey:CNSocialProfileURLStringKey]:_v.urlString,
                                      //                                      [CNSocialProfile localizedStringForKey:CNSocialProfileUsernameKey]:_v.username,
                                      //                                      [CNSocialProfile localizedStringForKey:CNSocialProfileUserIdentifierKey]:_v.userIdentifier?_v.userIdentifier:@"",
                                      //                                      [CNSocialProfile localizedStringForKey:CNSocialProfileServiceKey]:[CNSocialProfile localizedStringForService:_v.service],
                                      @"url":_v.urlString,
                                      @"username":_v.username,
                                      @"userIdentifier":_v.userIdentifier?_v.userIdentifier:@"",
                                      @"service":_v.service,
                                      }}];
            
        }else if ([v.value isKindOfClass:[CNInstantMessageAddress class]]){
            CNInstantMessageAddress *_v = (CNInstantMessageAddress *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:
                                  @{
                                      [CNInstantMessageAddress localizedStringForKey:CNInstantMessageAddressUsernameKey]:_v.username,
                                      [CNInstantMessageAddress localizedStringForKey:CNInstantMessageAddressServiceKey]:_v.service,
                                      }}];
        }else if ([v.value isKindOfClass:[NSDateComponents class]]){
            NSDateComponents *_v = (NSDateComponents *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label]:[formatter stringFromDate:_v.date]}];
        }
        
    }
    return _arr;
}
-(NSArray <NSDictionary<NSString *,NSString *>*>*)formattedArrayFromMultiValue:(ABMultiValueRef)value property:(ABPropertyID) property{
    NSMutableArray *_arr = [NSMutableArray new];
    if(value&&ABMultiValueGetCount(value)>0){
        for (int i=0; i<ABMultiValueGetCount(value); i++) {
            if ([(__bridge id)ABMultiValueCopyValueAtIndex(value, i) isKindOfClass:[NSDate class]]) {
                [_arr addObject:@{(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(value, i)):[formatter stringFromDate:(__bridge NSDate *)ABMultiValueCopyValueAtIndex(value, i)]}];
            }else if([(__bridge id)ABMultiValueCopyValueAtIndex(value, i) isKindOfClass:[NSDictionary class]]){
                [_arr addObject:@{(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(value, i)):(__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(value, i)}];
            }else if([(__bridge id)ABMultiValueCopyValueAtIndex(value, i) isKindOfClass:[NSString class]]){
                [_arr addObject:@{(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(value, i)):(__bridge NSString *)ABMultiValueCopyValueAtIndex(value, i)}];
            }else{
                [_arr addObject:@{(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(value, i)):(__bridge NSString *)ABMultiValueCopyValueAtIndex(value, i)}];
            }
            
        }
    }
    return _arr;
}
-(ABMultiValueRef)deFormattedArrayFromMultiValue:(NSArray <NSDictionary<NSString *,NSString *>*>*)value property:(ABPropertyID) property{
    if (property==kABPersonPhoneProperty) {
        ABMultiValueRef arr = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSDictionary *dic in value) {
            for (NSString *s in @[(__bridge NSString *)kABPersonPhoneMobileLabel,(__bridge NSString *)kABPersonPhoneIPhoneLabel,(__bridge NSString *)kABPersonPhoneMainLabel,(__bridge NSString *)kABPersonPhoneHomeFAXLabel,(__bridge NSString *)kABPersonPhoneWorkFAXLabel,(__bridge NSString *)kABPersonPhoneOtherFAXLabel,(__bridge NSString *)kABPersonPhonePagerLabel]) {
                if (CFStringCompare(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(s)), (__bridge CFStringRef)dic.allKeys.firstObject, kCFCompareLocalized)==kCFCompareEqualTo) {
                    ABMultiValueAddValueAndLabel(arr, (__bridge CFStringRef)dic.allValues.firstObject, (__bridge CFStringRef)(s), NULL);
                }
            }
        }
        return arr;
    }else if (property==kABPersonAddressProperty){
        ABMultiValueRef arr = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSDictionary *dic in value) {
            ABMultiValueAddValueAndLabel(arr, (__bridge CFDictionaryRef)dic.allValues.firstObject, (__bridge CFStringRef)dic.allValues.firstObject, NULL);
        }
        return arr;
    }
    return NULL;
//    if(value&&ABMultiValueGetCount(value)>0){
//        for (int i=0; i<ABMultiValueGetCount(value); i++) {
//            if ([(__bridge id)ABMultiValueCopyValueAtIndex(value, i) isKindOfClass:[NSDate class]]) {
//                [_arr addObject:@{(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(value, i)):[formatter stringFromDate:(__bridge NSDate *)ABMultiValueCopyValueAtIndex(value, i)]}];
//            }else if([(__bridge id)ABMultiValueCopyValueAtIndex(value, i) isKindOfClass:[NSDictionary class]]){
//                [_arr addObject:@{(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(value, i)):(__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(value, i)}];
//            }else if([(__bridge id)ABMultiValueCopyValueAtIndex(value, i) isKindOfClass:[NSString class]]){
//                [_arr addObject:@{(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(value, i)):(__bridge NSString *)ABMultiValueCopyValueAtIndex(value, i)}];
//            }else{
//                [_arr addObject:@{(__bridge NSString *)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(value, i)):(__bridge NSString *)ABMultiValueCopyValueAtIndex(value, i)}];
//            }
//            
//        }
//    }
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
