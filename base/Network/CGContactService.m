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
NSString *const kServiceCompany = @"kServiceCompany";
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
#define kFetchedField @[CNContactFamilyNameKey,CNContactGivenNameKey,CNContactMiddleNameKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactImageDataKey,CNContactDepartmentNameKey,CNContactJobTitleKey,CNContactBirthdayKey,CNContactNonGregorianBirthdayKey,CNContactNoteKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactDatesKey,CNContactUrlAddressesKey,CNContactRelationsKey,CNContactSocialProfilesKey,CNContactInstantMessageAddressesKey,CNContactOrganizationNameKey]
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
          @"name":[contactDic[kContactServiceName] length]>0?contactDic[kContactServiceName]:[contactDic[kServiceTels] firstObject],
          @"tels":contactDic[kServiceTels],
          @"photo":contactDic[kServiceContactPhoto]?contactDic[kServiceContactPhoto]:[NSNull null],
          @"department":contactDic[kServiceDepartment],
          @"company":contactDic[kServiceCompany],
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
          };
    };
    //通过分组得到人
    for (NSDictionary *groupDic in self.groups) {
        if ([groupDic[@"data"] count]>0) {
            //该组有人
            for (NSDictionary *contactDic in groupDic[@"data"]) {
                [arr addObject:contactFromData(contactDic,groupDic[kGroupServiceName])];
                [arrForCheck addObject:contactDic[kServiceContactId]];
            }
        }else{
            //改组没人
            [arr addObject:@{
                             @"group_title":groupDic[kGroupServiceName],
                             @"name":@"",
                             @"tel":@"",
                             @"photo":@"",
                             @"contact_other":@""}
             ];
        }
    }
    //没有分组的，孤单的人
    for (NSDictionary *contactDic in self.contacts) {
        NSInteger originCount = arrForCheck.count;
        [arrForCheck addObject:contactDic[kServiceContactId]];
        if (originCount < arrForCheck.count) {
//            没有重复的(属于没分组的)，添加
            [arr addObject:contactFromData(contactDic,@"")];
        }
        
    }
    return arr;
}
-(BOOL)saveWithContacts:(NSArray *)__contacts{
    NSDictionary *(^contactFromData)(NSDictionary *)=^(NSDictionary *dic){
        NSMutableDictionary *_dic = [NSMutableDictionary new];
        _dic[kContactServiceName] = dic[@"name"];
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
        return _dic;
    };
    NSMutableDictionary *allGroups = [NSMutableDictionary new];
    NSMutableArray *allContacts = [NSMutableArray new];
    for (NSDictionary *contacts in __contacts) {
        if (allGroups[contacts[@"group_title"]]) {
            [allGroups[contacts[@"group_title"]][@"data"] addObject:contactFromData(contacts)];
        }else{
            NSMutableDictionary *groupDic = [NSMutableDictionary new];
            groupDic[kGroupServiceName] = contacts[@"group_title"];
            groupDic[@"data"] = [NSMutableArray new];
            [groupDic[@"data"] addObject:contactFromData(contacts)];
            allGroups[contacts[@"group_title"]] = groupDic;
        }
        [allContacts addObject:contacts];
    }
    self.contacts = allContacts;
    self.groups = allGroups.allValues;
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
#pragma mark - get groups and contacts
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
#pragma mark -  cell methods
-(NSDictionary *)contactFromCNRecode:(CNContact *)contact{
    NSString *identifier = contact.identifier;
    NSString *contactName = [NSString stringWithFormat:@"%@%@%@",contact.familyName,contact.middleName,contact.givenName];
    UIImage *contactPhotoImage = contact.imageDataAvailable?[UIImage imageWithData:contact.imageData]:[UIImage new];
    
//    NSMutableArray *telArr = [NSMutableArray new];
//    for (CNLabeledValue *v in contact.phoneNumbers) {
//        [telArr addObject:[(CNPhoneNumber *)v.value stringValue]];
//    }
    NSArray *telArr = [self formattedArrayFromArray:contact.phoneNumbers];
    NSArray *emailArr = [self formattedArrayFromArray:contact.emailAddresses];
    NSArray *postalArr = [self formattedArrayFromArray:contact.postalAddresses];
    NSArray *dateArr = [self formattedArrayFromArray:contact.dates];
    NSArray *urlArr = [self formattedArrayFromArray:contact.urlAddresses];
    NSArray *relationArr = [self formattedArrayFromArray:contact.contactRelations];
    NSArray *profileArr = [self formattedArrayFromArray:contact.socialProfiles];
    NSArray *imArr = [self formattedArrayFromArray:contact.instantMessageAddresses];
    
    return @{kContactServiceName:contactName,kServiceTels:telArr,kServicePinyin:[contactName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],kServiceContactId:identifier,kServiceContactPhoto:contactPhotoImage,kServiceDepartment:contact.departmentName,
             kServiceJob:contact.jobTitle,kServiceBirthday:contact.birthday?[formatter stringFromDate:contact.birthday.date]:@"",kServiceNonGregorianBirthday:[self formattedDateComponentFromComponent:contact.nonGregorianBirthday],kServiceNote:contact.note,kServiceEmails:emailArr,kServicePostals:postalArr,kServiceDates:dateArr,kServiceUrls:urlArr,kServiceRelations:relationArr,kServiceProfiles:profileArr,kServiceIMs:imArr,kServiceCompany:contact.organizationName};
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
    CFTypeRef contactName                   = ABRecordCopyValue(contact, kABPersonFirstNameProperty);
    CFTypeRef contactMiddleName             = ABRecordCopyValue(contact, kABPersonMiddleNameProperty);
    CFTypeRef contactFamilyName             = ABRecordCopyValue(contact, kABPersonLastNameProperty);
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
    

    if(!contactName)contactName = @"";
    if(!contactMiddleName)contactMiddleName = @"";
    if(!contactFamilyName)contactFamilyName = @"";
    if(!contactDepartmentName)contactDepartmentName = @"";
    if(!contactCompany)contactCompany = @"";
    if(!contactJob)contactJob = @"";
    if(!contactBirthday)contactBirthday = @"";
    if(!contactNonGregorianBirthday)contactNonGregorianBirthday = @"";
    if(!contactNote)contactNote = @"";
    if(!contactPhotoImage)contactPhotoImage = [UIImage new];
    
    NSString *finalName         = [NSString stringWithFormat:@"%@%@%@",(__bridge NSString *)contactFamilyName,(__bridge NSString *)contactMiddleName,(__bridge NSString *)contactName];
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
    
    return @{kContactServiceName:finalName,kServiceTels:targetTelArr,kServicePinyin:[finalName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],kServiceContactId:identifier,kServiceContactPhoto:contactPhotoImage,kServiceDepartment:finalDepartment,kServiceJob:finalJob,kServiceBirthday:finalBirthday,kServiceNonGregorianBirthday:finalNonGregorianBirthday,kServiceNote:finalNote,kServiceEmails:targetEmailArr,kServicePostals:targetPostalArr,kServiceDates:dateArr,kServiceUrls:urlArr,kServiceRelations:relationArr,kServiceProfiles:profileArr,kServiceIMs:imArr,kServiceCompany:finalCompany};
}
#pragma mark - private methods
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
-(NSArray <NSDictionary<NSString *,NSString *>*>*)formattedArrayFromMultiValue:(ABMultiValueRef)value property:(ABPropertyID) property{
    //    ABPersonCopyLocalizedPropertyName
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
-(BOOL)isContactValable:(NSDictionary *)dic{
    return (dic[kContactServiceName]&&dic[kServiceTels])&&([dic[kContactServiceName] length]>0||[dic[kServiceTels] count]>0);
}
-(NSArray *)withoutFirstObjectFromData:(NSArray *)arr{
    NSMutableArray *arrNew = [[NSMutableArray alloc] initWithArray:arr];
    if(arrNew.count>0)[arrNew removeObjectAtIndex:0];
    return arrNew;
}
@end
