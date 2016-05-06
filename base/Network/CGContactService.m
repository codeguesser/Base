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



NSString *const kNotificationCGContactServiceDidLoad = @"kNotificationCGContactServiceDidLoad";
NSString *const kNotificationCGContactServiceSaved = @"kNotificationCGContactServiceSaved";
NSString *const kNotificationCGContactServiceSavedPercent = @"kNotificationCGContactServiceSavedPercent";
NSString *const kNotificationCGContactServiceOutsideContactChanged = @"kNotificationCGContactServiceOutsideContactChanged";
#define kFetchedField @[CNContactFamilyNameKey,CNContactGivenNameKey,CNContactMiddleNameKey,CNContactPhoneNumbersKey,CNContactImageDataAvailableKey,CNContactImageDataKey,CNContactThumbnailImageDataKey,CNContactDepartmentNameKey,CNContactJobTitleKey,CNContactBirthdayKey,CNContactNonGregorianBirthdayKey,CNContactNoteKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactDatesKey,CNContactUrlAddressesKey,CNContactRelationsKey,CNContactSocialProfilesKey,CNContactInstantMessageAddressesKey,CNContactOrganizationNameKey,CNContactNamePrefixKey,CNContactPreviousFamilyNameKey,CNContactNameSuffixKey,CNContactNicknameKey,CNContactPhoneticGivenNameKey,CNContactPhoneticMiddleNameKey,CNContactPhoneticFamilyNameKey,CNContactTypeKey]
#define checkMultiableValue(arr,kABPersonPhoneProperty,record) [arr count]>0&&ABRecordCopyValue(record, kABPersonPhoneProperty)&&ABMultiValueGetCount(ABRecordCopyValue(record, kABPersonPhoneProperty))>0
@implementation UIImage(CGContactService)
- (UIImage*)scaleToSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
@end
@interface CGContactService(){
    NSDateFormatter *formatter;
    BOOL _isCancelSaving;
    BOOL _isListenChangeing;
    ABAddressBookRef _addressBook;
    int _completeCount;
}
-(void)allgroupsFor9MinusChecked:(void(^)(ABAddressBookRef addressBook))action;
@end
void callback(){
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCGContactServiceOutsideContactChanged object:nil];
}
@implementation CGContactService
#pragma mark - system methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        formatter = [NSDateFormatter dateFormatterWithFormat:@"yyyyMMdd"];
        _isListenChangeing = NO;
    }
    return self;
}
-(void)dealloc{
    if (_isListenChangeing) {
        if ([[[UIDevice currentDevice]systemVersion] floatValue]>=9) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
        }else{
            ABAddressBookUnregisterExternalChangeCallback(_addressBook, callback, NULL);
        }
    }
}
+ (id)service{
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sthComming:) name:kNotificationCGContactServiceDidLoad object:nil];
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
        NSData *imageData;
        if (contactDic&&contactDic[kServiceContactPhoto]&&[contactDic[kServiceContactPhoto] isKindOfClass:[UIImage class]]) {
            UIImage * img = contactDic[kServiceContactPhoto];
            if([img isKindOfClass:[UIImage class]]&&!CGSizeEqualToSize(img.size, CGSizeZero)){
                imageData = UIImageJPEGRepresentation(img, 0);
            }
        }
        if (!imageData) {
            imageData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        }
        NSDictionary *createdDic = @{
                                     @"group_title":@[groupName],
                                     @"name":!contactDic?@"":contactDic[kContactServiceName],
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
                                     @"photo":!contactDic?@"":[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed],
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
        NSMutableDictionary *dic = [createdDic mutableCopy];
        for (NSString *key in createdDic.allKeys) {
            if (([dic[key] isKindOfClass:[NSString class]]&&[dic[key] isEqualToString:@""])||([dic[key] isKindOfClass:[NSArray class]]&&[dic[key] count]==0)) {
                [dic removeObjectForKey:key];
            }
        }
        return dic;
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
    BOOL status = [self initWithContacts:__contacts];
    [self saveData];
    return status;
}
-(BOOL)initWithContacts:(NSArray *)__contacts{
    NSDictionary *(^contactFromData)(NSDictionary *,NSString *) = ^(NSDictionary *dic,NSString *idx){
        id image = @"";
        if (dic[@"photo"]&&[dic[@"photo"] length]>0) {
            NSData *imgData = [[NSData alloc] initWithBase64EncodedString:dic[@"photo"] options:0];
            image = [UIImage imageWithData:imgData];
        }
        NSMutableDictionary *_dic = [NSMutableDictionary new];
        _dic[kContactServiceName] = dic[@"name"]?dic[@"name"]:@"",
        _dic[kContactServiceFamilyName] = dic[@"family_name"]?dic[@"family_name"]:@"",
        _dic[kContactServiceGivenName] = dic[@"given_name"]?dic[@"given_name"]:@"",
        _dic[kContactServiceMiddleName] = dic[@"middle_name"]?dic[@"middle_name"]:@"",
        _dic[kContactServiceNamePrefix] = dic[@"name_prefix"]?dic[@"name_prefix"]:@"",
        _dic[kContactServicePreviousFamilyName] = dic[@"previous_family_name"]?dic[@"previous_family_name"]:@"",
        _dic[kContactServiceSuffixName] = dic[@"suffix_name"]?dic[@"suffix_name"]:@"",
        _dic[kContactServiceNickName] = dic[@"nick_name"]?dic[@"nick_name"]:@"",
        _dic[kContactServicePhoneticGivenName] = dic[@"phonetic_given_name"]?dic[@"phonetic_given_name"]:@"",
        _dic[kContactServicePhoneticMiddleName] = dic[@"phonetic_middle_name"]?dic[@"phonetic_middle_name"]:@"",
        _dic[kContactServicePhoneticFamilyName] = dic[@"phonetic_family_name"]?dic[@"phonetic_family_name"]:@"",
        _dic[kContactServiceType] = dic[@"type"]?dic[@"type"]:@"",
        _dic[kServiceTels] = dic[@"tels"]?dic[@"tels"]:@[];
        _dic[kServiceContactPhoto] = image;
        _dic[kServiceCompany] = dic[@"company"]?dic[@"company"]:@"";
        _dic[kServiceDepartment] = dic[@"department"]?dic[@"department"]:@"";
        _dic[kServiceJob] = dic[@"job"]?dic[@"job"]:@"";
        _dic[kServiceBirthday] = dic[@"birthday"]?dic[@"birthday"]:@"";
        _dic[kServiceNonGregorianBirthday] = dic[@"nonGregorianBirthday"]&&[dic[@"nonGregorianBirthday"] isKindOfClass:[NSDictionary class]]?dic[@"nonGregorianBirthday"]:@{};
        _dic[kServiceNote] = dic[@"note"]?dic[@"note"]:@"";
        _dic[kServiceEmails] = dic[@"emails"]?dic[@"emails"]:@[];
        _dic[kServicePostals] = dic[@"postals"]?dic[@"postals"]:@[];
        _dic[kServiceDates] = dic[@"dates"]?dic[@"dates"]:@[];
        _dic[kServiceUrls] = dic[@"urls"]?dic[@"urls"]:@[];
        _dic[kServiceRelations] = dic[@"relations"]?dic[@"relations"]:@[];
        _dic[kServiceProfiles] = dic[@"profiles"]?dic[@"profiles"]:@[];
        _dic[kServiceIMs] = dic[@"ims"]?dic[@"ims"]:@[];
        _dic[kServicePinyin] = [_dic[kContactServiceName] pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]];
        _dic[kContactServiceId] = idx;
        return _dic;
    };
    NSMutableDictionary *allGroups = [NSMutableDictionary new];
    NSMutableArray *allContacts = [NSMutableArray new];
    NSInteger idx_contact = 0;
    NSInteger idx_group = 0;
    for (NSDictionary *contacts in __contacts) {
        NSDictionary *targetContact = contactFromData(contacts,[NSString stringWithFormat:@"%ld",(long)idx_contact]);
        if ([contacts[@"group_title"] isKindOfClass:[NSArray class]]) {
            for (NSString *groupName in contacts[@"group_title"]) {
                if (allGroups[groupName]) {
                    if([self isContactValable:targetContact]){
                        [allGroups[groupName][@"data"] addObject:targetContact];
                        [allContacts addObject:targetContact];
                    }
                }else{
                    NSMutableDictionary *groupDic = [NSMutableDictionary new];
                    groupDic[kGroupServiceName] = groupName;
                    groupDic[kGroupServiceId] = [NSString stringWithFormat:@"%ld",(long)idx_group];
                    groupDic[@"data"] = [NSMutableArray new];
                    if([self isContactValable:targetContact]){
                        [groupDic[@"data"] addObject:targetContact];
                        [allContacts addObject:targetContact];
                    }
                    allGroups[groupName] = groupDic;
                    idx_group++;
                }
                
                idx_contact++;
            }
        }else if([contacts[@"group_title"] isKindOfClass:[NSString class]]){
            NSString *groupName = contacts[@"group_title"];
            if (allGroups[groupName]) {
                if([self isContactValable:targetContact]){
                    [allGroups[groupName][@"data"] addObject:targetContact];
                    [allContacts addObject:targetContact];
                }
            }else{
                NSMutableDictionary *groupDic = [NSMutableDictionary new];
                groupDic[kGroupServiceName] = groupName;
                groupDic[kGroupServiceId] = [NSString stringWithFormat:@"%ld",(long)idx_group];
                groupDic[@"data"] = [NSMutableArray new];
                if([self isContactValable:targetContact]){
                    [groupDic[@"data"] addObject:targetContact];
                    [allContacts addObject:targetContact];
                }
                allGroups[groupName] = groupDic;
                idx_group++;
            }
            idx_contact++;
        }else if(!contacts[@"group_title"]){
            NSString *groupName = @"";
            if (allGroups[groupName]) {
                if([self isContactValable:targetContact]){
                    [allGroups[groupName][@"data"] addObject:targetContact];
                    [allContacts addObject:targetContact];
                }
            }else{
                NSMutableDictionary *groupDic = [NSMutableDictionary new];
                groupDic[kGroupServiceName] = groupName;
                groupDic[kGroupServiceId] = [NSString stringWithFormat:@"%ld",(long)idx_group];
                groupDic[@"data"] = [NSMutableArray new];
                if([self isContactValable:targetContact]){
                    [groupDic[@"data"] addObject:targetContact];
                    [allContacts addObject:targetContact];
                }
                allGroups[groupName] = groupDic;
                idx_group++;
            }
            idx_contact++;
        }
    }
    self.contacts = allContacts;
    self.groups = allGroups.allValues;
    return YES;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@\n%@",self.contacts,self.groups];
}
-(void)saveContact:(NSDictionary *)contact merge:(BOOL)isMerge{
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=9) {
        [self allgroupsFor9Checked:^(CNContactStore *store) {
            if(isMerge){
                NSString *identifier = @"";
                for (NSDictionary *dic in [self allContactsFor9WithStore:store]) {
                    if ([dic[kContactServiceName] isEqualToString:dic[kContactServiceName]]) {
                        identifier = dic[kContactServiceId];
                    }
                }
                CNContact *__contact = [store unifiedContactWithIdentifier:identifier keysToFetch:kFetchedField error:nil];
                if (contact) {
                    [self updateContactFor9WithDic:contact contact:[__contact mutableCopy] fromStore:store];
                }
            }else{
                //新建一个新的联系人
                [self writeContactsFor9:contact inStore:store];
            }
            
        }];
    }else{
        [self allgroupsFor9MinusChecked:^(ABAddressBookRef addressBook) {
            if(isMerge){
                NSString *identifier = @"";
                for (NSDictionary *dic in [self allContactsFor9MinusWithAddress:addressBook]) {
                    if ([dic[kContactServiceName] isEqualToString:dic[kContactServiceName]]) {
                        identifier = dic[kContactServiceId];
                    }
                }
                ABRecordRef record =  ABAddressBookGetPersonWithRecordID(addressBook, (ABRecordID)[identifier intValue]);
                if (record) {
                    [self updateContactFor9MinusWithDic:contact record:record fromAddress:addressBook];
                }
            }else{
                //新建一个新的联系人
                [self writeContactsFor9Minus:contact toAddress:addressBook];
                ABAddressBookSave(addressBook, NULL);
            }
        }];
    }
}
-(void)cancelAllSaveing{
    _isCancelSaving = YES;
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
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取通讯录权限" message:@"请在iPhone \"设置-隐私-通讯录\" 中允许动本使用定位服务" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
                            [alert show];
//                            if (buttonIndex!=alert.cancelButtonIndex) {
//                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                            }
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取通讯录权限" message:@"请在iPhone \"设置-隐私-通讯录\" 中允许动本使用定位服务" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                            [alert show];
                        }
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
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取通讯录权限" message:@"请在iPhone \"设置-隐私-通讯录\" 中允许动本使用定位服务" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
                        [alert show];
//                        if (buttonIndex!=alert.cancelButtonIndex) {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                        }
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法获取通讯录权限" message:@"请在iPhone \"设置-隐私-通讯录\" 中允许动本使用定位服务" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                });
            }
        }];
    }
}
-(void)listenSomeContactsChanged{
    callback();
}
#pragma mark - ###### GET groups and contacts
-(void)requestData{
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=9) {
        [self allgroupsFor9Checked:^(CNContactStore *store) {
            if (_isListenChangeing) {
                //                _isListenChangeing = YES;
                //                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenSomeContactsChanged) name:CNContactStoreDidChangeNotification object:nil];
            }
            self.groups = [self allgroupsFor9WithStore:store];
            self.contacts = [self allContactsFor9WithStore:store];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCGContactServiceDidLoad object:self];
        }];
    }else{
        [self allgroupsFor9MinusChecked:^(ABAddressBookRef addressBook) {
            if (_isListenChangeing) {
                //                _isListenChangeing = YES;
                //                _addressBook = addressBook;
                //                ABAddressBookRegisterExternalChangeCallback(_addressBook, callback, NULL);
            }
            self.contacts = [self allContactsFor9MinusWithAddress:addressBook];
            self.groups = [self allgroupsFor9MinusWithAddress:addressBook];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCGContactServiceDidLoad object:self];
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
    UIImage *contactPhotoImage;
    if (contact.thumbnailImageData) {
        contactPhotoImage = [UIImage imageWithData:contact.thumbnailImageData];
    }else{
        if (contact.imageData) {
            contactPhotoImage = [[UIImage imageWithData:contact.imageData] scaleToSize:CGSizeMake(200, 200)];
        }else{
            contactPhotoImage = [UIImage new];
        }
    }
    
    NSArray *telArr = [self formattedArrayFromArray:contact.phoneNumbers];
    NSArray *emailArr = [self formattedArrayFromArray:contact.emailAddresses];
    NSArray *postalArr = [self formattedArrayFromArray:contact.postalAddresses];
    NSArray *dateArr = [self formattedArrayFromArray:contact.dates];
    NSArray *urlArr = [self formattedArrayFromArray:contact.urlAddresses];
    NSArray *relationArr = [self formattedArrayFromArray:contact.contactRelations];
    NSArray *profileArr = [self formattedArrayFromArray:contact.socialProfiles];
    NSArray *imArr = [self formattedArrayFromArray:contact.instantMessageAddresses];
    return @{kContactServiceName:contactName,kContactServiceFamilyName:contact.familyName,kContactServiceGivenName:contact.givenName,kContactServiceMiddleName:contact.middleName,kContactServiceNamePrefix:contact.namePrefix,kContactServicePreviousFamilyName:contact.previousFamilyName,kContactServiceSuffixName:contact.nameSuffix,kContactServiceNickName:contact.nickname,kContactServicePhoneticGivenName:contact.phoneticGivenName,kContactServicePhoneticMiddleName:contact.phoneticMiddleName,kContactServicePhoneticFamilyName:contact.phoneticFamilyName,kContactServiceType:[@(contact.contactType) stringValue],kServiceTels:telArr,kServicePinyin:[contactName pinyinFromSource:[[ShareHandle shareHandle] pinyinSourceDic]],kContactServiceId:identifier,kServiceContactPhoto:contactPhotoImage,kServiceDepartment:contact.departmentName,
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
    CFDataRef contactPhoto = ABPersonCopyImageDataWithFormat(contact, kABPersonImageFormatThumbnail);
    UIImage *contactPhotoImage ;
    if (contactPhoto) {
        contactPhotoImage = [UIImage imageWithData:(__bridge NSData * _Nonnull)(contactPhoto)];
    }else{
        contactPhoto = ABPersonCopyImageDataWithFormat(contact, kABPersonImageFormatOriginalSize);
        if (!contactPhoto) {
            contactPhotoImage = [[UIImage imageWithData:(__bridge NSData * _Nonnull)(contactPhoto)] scaleToSize:CGSizeMake(200, 200)];
        }else{
            contactPhotoImage = [UIImage new];
        }
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
    _isCancelSaving = NO;
    _completeCount = 0;
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=9) {
        [self allgroupsFor9Checked:^(CNContactStore *store) {
            if(!_isCancelSaving)[self cleanAllDataFor9FromStore:store];
            for (NSDictionary *group in self.groups) {
                if(!_isCancelSaving) {
                    CNGroup *savedGroup;
                    if([group[kGroupServiceName] length]>0)savedGroup = [self writeGroupsFor9:group toStore:store];
                    for (NSDictionary *contact in group[@"data"]) {
                        if(!_isCancelSaving){
                            CNContact *savedContact = [self writeContactsFor9:contact inStore:store];
                            if(savedGroup)[self moveContactFor9:savedContact toGroup:savedGroup inStore:store];
                            _completeCount++;
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCGContactServiceSavedPercent object:@(_completeCount)];
                        }
                    }
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCGContactServiceSaved object:self];
        }];
    }else{
        [self allgroupsFor9MinusChecked:^(ABAddressBookRef addressBook) {
            if(!_isCancelSaving)[self cleanAllDataFor9MinusFromAddress:addressBook];
            CFErrorRef error;
            ABAddressBookSave(addressBook, &error);
            for (NSDictionary *group in self.groups) {
                if(!_isCancelSaving){
                    ABRecordRef savedGroup = NULL;
                    if([group[kGroupServiceName] length]>0)savedGroup = [self writeGroupsFor9Minus:group toAddress:addressBook];
                    for (NSDictionary *contact in group[@"data"]) {
                        if(!_isCancelSaving){
                            ABRecordRef savedContact = [self writeContactsFor9Minus:contact toAddress:addressBook];
                            ABAddressBookSave(addressBook, NULL);
                            if(savedGroup)[self moveContactFor9Minus:savedContact toGroup:savedGroup];
                            _completeCount++;
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCGContactServiceSavedPercent object:@(_completeCount)];
                        }
                    }
                }
                
            }
            if (!_isCancelSaving) {
                CFErrorRef error;
                ABAddressBookSave(addressBook, &error);
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCGContactServiceSaved object:self];
            }
        }];
    }
}
-(BOOL)moveContactFor9:(CNContact *)contact toGroup:(CNGroup *)group inStore:(CNContactStore *)store{
    CNSaveRequest *request = [[CNSaveRequest  alloc] init];
    [request addMember:contact toGroup:group];
    return [store executeSaveRequest:request error:nil];
}
-(CFErrorRef)moveContactFor9Minus:(ABRecordRef)contact toGroup:(ABRecordRef)group{
    CFErrorRef error;
    ABGroupAddMember(group, contact, &error);
    return error;
}
-(void)cleanAllDataFor9FromStore:(CNContactStore *)store{
    CNSaveRequest *request = [[CNSaveRequest  alloc] init];
    for (CNGroup *group in [store groupsMatchingPredicate:nil error:nil]) {
        [request deleteGroup:[group mutableCopy]];
    }
    [store enumerateContactsWithFetchRequest:[[CNContactFetchRequest alloc] initWithKeysToFetch:@[]] error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [request deleteContact:[contact mutableCopy]];
    }];
    [store executeSaveRequest:request error:nil];
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
    if([dic[kServiceContactPhoto] isKindOfClass:[UIImage class]]){
        contact.imageData = UIImagePNGRepresentation(dic[kServiceContactPhoto]);
    }
    if([dic[kContactServiceFamilyName] length]>0)contact.familyName = dic[kContactServiceFamilyName];
    if([dic[kContactServiceGivenName] length]>0)contact.givenName = dic[kContactServiceGivenName];
    if([dic[kContactServiceMiddleName] length]>0)contact.middleName = dic[kContactServiceMiddleName];
    if([dic[kContactServiceNamePrefix] length]>0)contact.namePrefix = dic[kContactServiceNamePrefix];
    if([dic[kContactServicePreviousFamilyName] length]>0)contact.previousFamilyName = dic[kContactServicePreviousFamilyName];
    if([dic[kContactServiceSuffixName] length]>0)contact.nameSuffix = dic[kContactServiceSuffixName];
    if([dic[kContactServiceNickName] length]>0)contact.nickname = dic[kContactServiceNickName];
    if([dic[kContactServicePhoneticGivenName] length]>0)contact.phoneticGivenName = dic[kContactServicePhoneticGivenName];
    if([dic[kContactServicePhoneticMiddleName] length]>0)contact.phoneticMiddleName = dic[kContactServicePhoneticMiddleName];
    if([dic[kContactServicePhoneticFamilyName] length]>0)contact.phoneticFamilyName = dic[kContactServicePhoneticFamilyName];
    if([dic[kContactServiceType] length]>0)contact.contactType = [dic[kContactServiceType] integerValue];
    if([dic[kServiceCompany] length]>0)contact.organizationName = dic[kServiceCompany];
    if([dic[kServiceDepartment] length]>0)contact.departmentName = dic[kServiceDepartment];
    if([dic[kServiceJob] length]>0)contact.jobTitle = dic[kServiceJob];
    if([dic[kServiceNote] length]>0)contact.note = dic[kServiceNote];
    if(dic[kServiceBirthday]&&[dic[kServiceBirthday] length]>0){
        NSDate *birthDay = [formatter dateFromString:dic[kServiceBirthday]];
        NSDateComponents *component = [[NSDateComponents alloc]init];
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        component.calendar = gregorian;
        component.day = [birthDay day];
        component.month = [birthDay month];
        component.year = [birthDay year];
        contact.birthday = component;
    }
    if([dic[kServiceNonGregorianBirthday] allKeys].count>0)contact.nonGregorianBirthday = [self deFormattedDateComponentFromDictionary:dic[kServiceNonGregorianBirthday]];
    if([dic[kServiceTels] count]>0)contact.phoneNumbers = [self deFormattedArrayFromArray:dic[kServiceTels] class:@"CNPhoneNumber"];
    if([dic[kServiceDates] count]>0)contact.dates = [self deFormattedArrayFromArray:dic[kServiceDates] class:@"NSDateComponents"];
    if([dic[kServicePostals] count]>0)contact.postalAddresses = [self deFormattedArrayFromArray:dic[kServicePostals] class:@"CNPostalAddress"];
    if([dic[kServiceUrls] count]>0)contact.urlAddresses = [self deFormattedArrayFromArray:dic[kServiceUrls] class:@"NSString"];
    if([dic[kServiceRelations] count]>0)contact.contactRelations = [self deFormattedArrayFromArray:dic[kServiceRelations] class:@"CNContactRelation"];
    if([dic[kServiceProfiles] count]>0)contact.socialProfiles = [self deFormattedArrayFromArray:dic[kServiceProfiles] class:@"CNSocialProfile"];
    if([dic[kServiceIMs] count]>0)contact.instantMessageAddresses = [self deFormattedArrayFromArray:dic[kServiceIMs] class:@"CNInstantMessageAddress"];
    if([dic[kServiceEmails] count]>0)contact.emailAddresses = [self deFormattedArrayFromArray:dic[kServiceEmails] class:@"NSString"];
    NSError *error;
    [request addContact:contact toContainerWithIdentifier:nil];
    BOOL isSuccessed = [store executeSaveRequest:request error:&error];
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
        if([dic[kServiceContactPhoto] isKindOfClass:[UIImage class]]){
            ABPersonSetImageData(contact, (__bridge CFDataRef)(UIImagePNGRepresentation(dic[kServiceContactPhoto])), nil);
        }
        
        if([dic[kContactServiceGivenName] length]>0)ABRecordSetValue(contact, kABPersonFirstNameProperty, (__bridge CFTypeRef)(dic[kContactServiceGivenName]), nil);
        if([dic[kContactServiceFamilyName] length]>0)ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFTypeRef)(dic[kContactServiceFamilyName]), nil);
        if([dic[kContactServiceMiddleName] length]>0)ABRecordSetValue(contact, kABPersonMiddleNameProperty, (__bridge CFTypeRef)(dic[kContactServiceMiddleName]), nil);
        if([dic[kContactServicePhoneticFamilyName] length]>0)ABRecordSetValue(contact, kABPersonLastNamePhoneticProperty, (__bridge CFTypeRef)(dic[kContactServicePhoneticFamilyName]), nil);
        if([dic[kContactServicePhoneticGivenName] length]>0)ABRecordSetValue(contact, kABPersonFirstNamePhoneticProperty, (__bridge CFTypeRef)(dic[kContactServicePhoneticGivenName]), nil);
        if([dic[kContactServicePhoneticMiddleName] length]>0)ABRecordSetValue(contact, kABPersonMiddleNamePhoneticProperty, (__bridge CFTypeRef)(dic[kContactServicePhoneticMiddleName]), nil);
        if(dic[kContactServiceNickName])ABRecordSetValue(contact, kABPersonNicknameProperty, (__bridge CFTypeRef)(dic[kContactServiceNickName]), nil);
        if([dic[kContactServiceNamePrefix] length]>0)ABRecordSetValue(contact, kABPersonPrefixProperty, (__bridge CFTypeRef)(dic[kContactServiceNamePrefix]), nil);
        if([dic[kContactServiceSuffixName] length]>0)ABRecordSetValue(contact, kABPersonSuffixProperty, (__bridge CFTypeRef)(dic[kContactServiceSuffixName]), nil);
        if([dic[kContactServiceType] length]>0)ABRecordSetValue(contact, kABPersonKindProperty, (__bridge CFTypeRef)(@([dic[kContactServiceType] integerValue])), nil);
        if([dic[kServiceCompany] length]>0)ABRecordSetValue(contact, kABPersonOrganizationProperty, (__bridge CFTypeRef)(dic[kServiceCompany]), nil);
        if([dic[kServiceDepartment] length]>0)ABRecordSetValue(contact, kABPersonDepartmentProperty, (__bridge CFTypeRef)(dic[kServiceDepartment]), nil);
        if([dic[kServiceJob] length]>0)ABRecordSetValue(contact, kABPersonJobTitleProperty, (__bridge CFTypeRef)(dic[kServiceJob]), nil);
        if([dic[kServiceBirthday] isKindOfClass:[NSString class]]&&[dic[kServiceBirthday] length]>0)ABRecordSetValue(contact, kABPersonBirthdayProperty, (__bridge CFTypeRef)([formatter dateFromString:dic[kServiceBirthday]]), nil);
        if([[dic[kServiceNonGregorianBirthday] allKeys]count]>0)ABRecordSetValue(contact, kABPersonAlternateBirthdayProperty, (__bridge CFTypeRef)(dic[kServiceNonGregorianBirthday]), nil);
        if([dic[kServiceNote] length]>0)ABRecordSetValue(contact, kABPersonNoteProperty, (__bridge CFTypeRef)(dic[kServiceNote]), nil);
        CFErrorRef error = NULL;
        if([dic[kServiceTels] count]>0)ABRecordSetValue(contact, kABPersonPhoneProperty, [self deFormattedArrayFromMultiValue:dic[kServiceTels] property:kABPersonPhoneProperty], &error);
        if([dic[kServiceDates] count]>0)ABRecordSetValue(contact, kABPersonDateProperty, [self deFormattedArrayFromMultiValue:dic[kServiceDates] property:kABPersonDateProperty], &error);
        if([dic[kServicePostals] count]>0)ABRecordSetValue(contact, kABPersonAddressProperty, [self deFormattedArrayFromMultiValue:dic[kServicePostals] property:kABPersonAddressProperty], &error);
        if([dic[kServiceUrls] count]>0)ABRecordSetValue(contact, kABPersonURLProperty, [self deFormattedArrayFromMultiValue:dic[kServiceUrls] property:kABPersonURLProperty], &error);
        if([dic[kServiceRelations] count]>0)ABRecordSetValue(contact, kABPersonRelatedNamesProperty, [self deFormattedArrayFromMultiValue:dic[kServiceRelations] property:kABPersonRelatedNamesProperty], &error);
        if([dic[kServiceProfiles] count]>0)ABRecordSetValue(contact, kABPersonSocialProfileProperty, [self deFormattedArrayFromMultiValue:dic[kServiceProfiles] property:kABPersonSocialProfileProperty], &error);
        if([dic[kServiceIMs] count]>0)ABRecordSetValue(contact, kABPersonInstantMessageProperty, [self deFormattedArrayFromMultiValue:dic[kServiceIMs] property:kABPersonInstantMessageProperty], &error);
        if([dic[kServiceEmails] count]>0)ABRecordSetValue(contact, kABPersonEmailProperty, [self deFormattedArrayFromMultiValue:dic[kServiceEmails] property:kABPersonEmailProperty], &error);
        
    }
    bool isSuccess = ABAddressBookAddRecord(address, contact, NULL);
    return isSuccess?contact:NULL;
}
-(ABRecordRef)writeGroupsFor9Minus:(NSDictionary *)dic toAddress:(ABAddressBookRef)address{
    ABRecordRef group = ABGroupCreate();
    ABRecordSetValue(group, kABGroupNameProperty, (__bridge CFTypeRef)(dic[kGroupServiceName]), NULL);
    bool isSuccess = ABAddressBookAddRecord(address, group, NULL);
    return isSuccess?group:NULL;
}
#pragma mark - ###### UPDATE contacts
-(void)updateContactFor9MinusWithDic:(NSDictionary *)dic record:(ABRecordRef)record fromAddress:(ABAddressBookRef)address{
    if([dic[kServiceContactPhoto] isKindOfClass:[UIImage class]]&&!ABPersonHasImageData(record))ABPersonSetImageData(record, (__bridge CFDataRef)(UIImagePNGRepresentation(dic[kServiceContactPhoto])), nil);
    if([dic[kContactServiceGivenName] length]>0&&!ABRecordCopyValue(record, kABPersonFirstNameProperty))ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)(dic[kContactServiceGivenName]), nil);
    
    if([dic[kContactServiceFamilyName] length]>0&&!ABRecordCopyValue(record, kABPersonLastNameProperty))ABRecordSetValue(record, kABPersonLastNameProperty, (__bridge CFTypeRef)(dic[kContactServiceFamilyName]), nil);
    if([dic[kContactServiceMiddleName] length]>0&&!ABRecordCopyValue(record, kABPersonMiddleNameProperty))ABRecordSetValue(record, kABPersonMiddleNameProperty, (__bridge CFTypeRef)(dic[kContactServiceMiddleName]), nil);
    if([dic[kContactServicePhoneticFamilyName] length]>0&&!ABRecordCopyValue(record, kABPersonLastNamePhoneticProperty))ABRecordSetValue(record, kABPersonLastNamePhoneticProperty, (__bridge CFTypeRef)(dic[kContactServicePhoneticFamilyName]), nil);
    if([dic[kContactServicePhoneticGivenName] length]>0&&!ABRecordCopyValue(record, kABPersonFirstNamePhoneticProperty))ABRecordSetValue(record, kABPersonFirstNamePhoneticProperty, (__bridge CFTypeRef)(dic[kContactServicePhoneticGivenName]), nil);
    if([dic[kContactServicePhoneticMiddleName] length]>0&&!ABRecordCopyValue(record, kABPersonMiddleNamePhoneticProperty))ABRecordSetValue(record, kABPersonMiddleNamePhoneticProperty, (__bridge CFTypeRef)(dic[kContactServicePhoneticMiddleName]), nil);
    if([dic[kContactServiceNickName] length]>0&&!ABRecordCopyValue(record, kABPersonNicknameProperty))ABRecordSetValue(record, kABPersonNicknameProperty, (__bridge CFTypeRef)(dic[kContactServiceNickName]), nil);
    if([dic[kContactServiceNamePrefix] length]>0&&!ABRecordCopyValue(record, kABPersonPrefixProperty))ABRecordSetValue(record, kABPersonPrefixProperty, (__bridge CFTypeRef)(dic[kContactServiceNamePrefix]), nil);
    if([dic[kContactServiceSuffixName] length]>0&&!ABRecordCopyValue(record, kABPersonSuffixProperty))ABRecordSetValue(record, kABPersonSuffixProperty, (__bridge CFTypeRef)(dic[kContactServiceSuffixName]), nil);
    if([dic[kContactServiceType] length]>0&&!ABRecordCopyValue(record, kABPersonKindProperty))ABRecordSetValue(record, kABPersonKindProperty, (__bridge CFTypeRef)(@([dic[kContactServiceType] integerValue])), nil);
    if([dic[kServiceCompany] length]>0&&!ABRecordCopyValue(record, kABPersonOrganizationProperty))ABRecordSetValue(record, kABPersonOrganizationProperty, (__bridge CFTypeRef)(dic[kServiceCompany]), nil);
    if([dic[kServiceDepartment] length]>0&&!ABRecordCopyValue(record, kABPersonDepartmentProperty))ABRecordSetValue(record, kABPersonDepartmentProperty, (__bridge CFTypeRef)(dic[kServiceDepartment]), nil);
    if([dic[kServiceJob] length]>0&&!ABRecordCopyValue(record, kABPersonJobTitleProperty))ABRecordSetValue(record, kABPersonJobTitleProperty, (__bridge CFTypeRef)(dic[kServiceJob]), nil);
    if([dic[kServiceBirthday] isKindOfClass:[NSString class]]&&[dic[kServiceBirthday] length]>0&&!ABRecordCopyValue(record, kABPersonBirthdayProperty))ABRecordSetValue(record, kABPersonBirthdayProperty, (__bridge CFTypeRef)([formatter dateFromString:dic[kServiceBirthday]]), nil);
    if(dic[kServiceNonGregorianBirthday]&&!ABRecordCopyValue(record, kABPersonAlternateBirthdayProperty))ABRecordSetValue(record, kABPersonAlternateBirthdayProperty, (__bridge CFTypeRef)(dic[kServiceNonGregorianBirthday]), nil);
    if([dic[kServiceNote] length]>0&&!ABRecordCopyValue(record, kABPersonNoteProperty))ABRecordSetValue(record, kABPersonNoteProperty, (__bridge CFTypeRef)(dic[kServiceNote]), nil);
    CFErrorRef error = NULL;
    if(checkMultiableValue(dic[kServiceTels],kABPersonPhoneProperty,record))ABRecordSetValue(record, kABPersonPhoneProperty, [self deFormattedArrayFromMultiValue:dic[kServiceTels] property:kABPersonPhoneProperty], &error);
    if(checkMultiableValue(dic[kServiceDates],kABPersonDateProperty,record))ABRecordSetValue(record, kABPersonDateProperty, [self deFormattedArrayFromMultiValue:dic[kServiceDates] property:kABPersonDateProperty], &error);
    
    if(checkMultiableValue(dic[kServicePostals],kABPersonAddressProperty,record))ABRecordSetValue(record, kABPersonAddressProperty, [self deFormattedArrayFromMultiValue:dic[kServicePostals] property:kABPersonAddressProperty], &error);
    if(checkMultiableValue(dic[kServiceUrls],kABPersonURLProperty,record))ABRecordSetValue(record, kABPersonURLProperty, [self deFormattedArrayFromMultiValue:dic[kServiceUrls] property:kABPersonURLProperty], &error);
    if(checkMultiableValue(dic[kServiceRelations],kABPersonRelatedNamesProperty,record))ABRecordSetValue(record, kABPersonRelatedNamesProperty, [self deFormattedArrayFromMultiValue:dic[kServiceRelations] property:kABPersonRelatedNamesProperty], &error);
    if(checkMultiableValue(dic[kServiceProfiles],kABPersonSocialProfileProperty,record))ABRecordSetValue(record, kABPersonSocialProfileProperty, [self deFormattedArrayFromMultiValue:dic[kServiceProfiles] property:kABPersonSocialProfileProperty], &error);
    if(checkMultiableValue(dic[kServiceIMs],kABPersonInstantMessageProperty,record))ABRecordSetValue(record, kABPersonInstantMessageProperty, [self deFormattedArrayFromMultiValue:dic[kServiceIMs] property:kABPersonInstantMessageProperty], &error);
    if(checkMultiableValue(dic[kServiceEmails],kABPersonEmailProperty,record))ABRecordSetValue(record, kABPersonEmailProperty, [self deFormattedArrayFromMultiValue:dic[kServiceEmails] property:kABPersonEmailProperty], &error);
}
-(void)updateContactFor9WithDic:(NSDictionary *)dic contact:(CNMutableContact *)contact fromStore:(CNContactStore *)store{
    if([dic[kServiceContactPhoto] isKindOfClass:[UIImage class]]&&!contact.imageDataAvailable)contact.imageData = UIImagePNGRepresentation(dic[kServiceContactPhoto]);
    if([dic[kContactServiceFamilyName] length]>0&&!contact.familyName)contact.familyName = dic[kContactServiceFamilyName];
    if([dic[kContactServiceGivenName] length]>0&&!contact.givenName)contact.givenName = dic[kContactServiceGivenName];
    if([dic[kContactServiceMiddleName] length]>0&&!contact.middleName)contact.middleName = dic[kContactServiceMiddleName];
    if([dic[kContactServiceNamePrefix] length]>0&&!contact.namePrefix)contact.namePrefix = dic[kContactServiceNamePrefix];
    if([dic[kContactServicePreviousFamilyName] length]>0&&!contact.previousFamilyName)contact.previousFamilyName = dic[kContactServicePreviousFamilyName];
    if([dic[kContactServiceSuffixName] length]>0&&!contact.nameSuffix)contact.nameSuffix = dic[kContactServiceSuffixName];
    if([dic[kContactServiceNickName] length]>0&&!contact.nickname)contact.nickname = dic[kContactServiceNickName];
    if([dic[kContactServicePhoneticGivenName] length]>0&&!contact.phoneticGivenName)contact.phoneticGivenName = dic[kContactServicePhoneticGivenName];
    if([dic[kContactServicePhoneticMiddleName] length]>0&&!contact.phoneticMiddleName)contact.phoneticMiddleName = dic[kContactServicePhoneticMiddleName];
    if([dic[kContactServicePhoneticFamilyName] length]>0&&!contact.phoneticFamilyName)contact.phoneticFamilyName = dic[kContactServicePhoneticFamilyName];
    if([dic[kContactServiceType] length]>0&&!contact.contactType)contact.contactType = [dic[kContactServiceType] integerValue];
    if([dic[kServiceCompany] length]>0&&!contact.organizationName)contact.organizationName = dic[kServiceCompany];
    if([dic[kServiceDepartment] length]>0&&!contact.departmentName)contact.departmentName = dic[kServiceDepartment];
    if([dic[kServiceJob] length]>0&&!contact.jobTitle)contact.jobTitle = dic[kServiceJob];
    if([dic[kServiceNote] length]>0&&!contact.note)contact.note = dic[kServiceNote];
    if(dic[kServiceBirthday]&&[dic[kServiceBirthday] length]>0&&!contact.birthday){
        NSDate *birthDay = [formatter dateFromString:dic[kServiceBirthday]];
        NSDateComponents *component = [[NSDateComponents alloc]init];
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        component.calendar = gregorian;
        component.day = [birthDay day];
        component.month = [birthDay month];
        component.year = [birthDay year];
        contact.birthday = component;
    }
    if(dic[kServiceNonGregorianBirthday]&&!contact.nonGregorianBirthday)contact.nonGregorianBirthday = [self deFormattedDateComponentFromDictionary:dic[kServiceNonGregorianBirthday]];
    if([dic[kServiceTels] count]>0)contact.phoneNumbers = [self deFormattedArrayFromArray:dic[kServiceTels] class:@"CNPhoneNumber"];
    if([dic[kServiceDates] count]>0)contact.dates = [self deFormattedArrayFromArray:dic[kServiceDates] class:@"NSDateComponents"];
    if([dic[kServicePostals] count]>0)contact.postalAddresses = [self deFormattedArrayFromArray:dic[kServicePostals] class:@"CNPostalAddress"];
    if([dic[kServiceUrls] count]>0)contact.urlAddresses = [self deFormattedArrayFromArray:dic[kServiceUrls] class:@"NSString"];
    if([dic[kServiceRelations] count]>0)contact.contactRelations = [self deFormattedArrayFromArray:dic[kServiceRelations] class:@"CNContactRelation"];
    if([dic[kServiceProfiles] count]>0)contact.socialProfiles = [self deFormattedArrayFromArray:dic[kServiceProfiles] class:@"CNSocialProfile"];
    if([dic[kServiceIMs] count]>0)contact.instantMessageAddresses = [self deFormattedArrayFromArray:dic[kServiceIMs] class:@"CNInstantMessageAddress"];
    if([dic[kServiceEmails] count]>0)contact.emailAddresses = [self deFormattedArrayFromArray:dic[kServiceEmails] class:@"NSString"];
    
    CNSaveRequest *request = [[CNSaveRequest alloc]init];
    [request updateContact:contact];
    [store executeSaveRequest:request error:nil];
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
    }else{
        return nil;
    }
    return component;
}
-(NSArray <NSDictionary<NSString *,NSString *>*>*)formattedArrayFromArray:(NSArray<CNLabeledValue*>*)arr{
    NSMutableArray *_arr = [NSMutableArray new];
    for (CNLabeledValue *v in arr) {
        if ([v.value isKindOfClass:[NSString class]]) {
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label?v.label:@""]:v.value}];
        }else if ([v.value isKindOfClass:[CNPostalAddress class]]){
            CNPostalAddress *_v = (CNPostalAddress *)v.value;
            
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label?v.label:@""]:
                                  @{
                                      @"Street":_v.street,
                                      @"City":_v.city,
                                      @"State":_v.state,
                                      @"ZIP":_v.postalCode,
                                      @"Country":_v.country,
                                      @"CountryCode":_v.ISOCountryCode,
                                      }}];
        }else if ([v.value isKindOfClass:[CNPhoneNumber class]]){
            CNPhoneNumber *_v = (CNPhoneNumber *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label?v.label:@""]:_v.stringValue}];
        }else if ([v.value isKindOfClass:[CNContactRelation class]]){
            CNContactRelation *_v = (CNContactRelation *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label?v.label:@""]:_v.name}];
        }else if ([v.value isKindOfClass:[CNSocialProfile class]]){
            CNSocialProfile *_v = (CNSocialProfile *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label?v.label:@""]:
                                  @{
                                      @"url":_v.urlString,
                                      @"username":_v.username,
                                      @"userIdentifier":_v.userIdentifier?_v.userIdentifier:@"",
                                      @"service":_v.service,
                                      }}];
            
        }else if ([v.value isKindOfClass:[CNInstantMessageAddress class]]){
            CNInstantMessageAddress *_v = (CNInstantMessageAddress *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label?v.label:@""]:
                                  @{
                                      [CNInstantMessageAddress localizedStringForKey:CNInstantMessageAddressUsernameKey]:_v.username,
                                      [CNInstantMessageAddress localizedStringForKey:CNInstantMessageAddressServiceKey]:_v.service,
                                      }}];
        }else if ([v.value isKindOfClass:[NSDateComponents class]]){
            NSDateComponents *_v = (NSDateComponents *)v.value;
            [_arr addObject:@{[CNLabeledValue localizedStringForLabel:v.label?v.label:@""]:[formatter stringFromDate:_v.date]}];
        }
        
    }
    return _arr;
}
-(NSArray<CNLabeledValue*>*)deFormattedArrayFromArray:(NSArray <NSDictionary<NSString *,NSString *>*>*)arr class:(NSString *)className{
    NSMutableArray *_arr = [NSMutableArray new];
    if ([className isEqualToString:@"CNPhoneNumber"]) {
        for (NSDictionary *dic in arr) {
            CNPhoneNumber *_v = [[CNPhoneNumber alloc]initWithStringValue:dic.allValues.firstObject];
            NSString *label = [CNLabeledValue localizedStringForLabel:dic.allKeys.firstObject];
            for (NSString *s in @[CNLabelHome,CNLabelWork,CNLabelOther,CNLabelPhoneNumberiPhone,CNLabelPhoneNumberMobile,CNLabelPhoneNumberMain,CNLabelPhoneNumberHomeFax,CNLabelPhoneNumberWorkFax,CNLabelPhoneNumberOtherFax,CNLabelPhoneNumberPager]) {
                if ([[CNLabeledValue localizedStringForLabel:s] isEqualToString:dic.allKeys.firstObject]) {
                    label = s;
                }
            }
            [_arr addObject:[CNLabeledValue labeledValueWithLabel:label value:_v]];
            
        }
    }else if ([className isEqualToString:@"NSDateComponents"]) {
        for (NSDictionary *dic in arr) {
            NSDate *date = [formatter dateFromString:dic.allValues.firstObject];
            NSDateComponents *component = [[NSDateComponents alloc]init];
            NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            component.calendar = gregorian;
            component.day = [date day];
            component.month = [date month];
            component.year = [date year];
            NSString *label = [CNLabeledValue localizedStringForLabel:dic.allKeys.firstObject];
            for (NSString *s in @[CNLabelHome,CNLabelWork,CNLabelOther,CNLabelDateAnniversary]) {
                if ([[CNLabeledValue localizedStringForLabel:s] isEqualToString:dic.allKeys.firstObject]) {
                    label = s;
                }
            }
            [_arr addObject:[CNLabeledValue labeledValueWithLabel:label value:component]];
        }
    }else if ([className isEqualToString:@"CNPostalAddress"]) {
        for (NSDictionary *dic in arr) {
            CNMutablePostalAddress *_v = [[CNMutablePostalAddress alloc] init];
            _v.street = dic.allValues.firstObject[@"Street"];
            _v.city = dic.allValues.firstObject[@"City"];
            _v.state = dic.allValues.firstObject[@"State"];
            _v.postalCode = dic.allValues.firstObject[@"Country"];
            _v.ISOCountryCode = dic.allValues.firstObject[@"CountryCode"];
            _v.postalCode = dic.allValues.firstObject[@"ZIP"];
            NSString *label = [CNLabeledValue localizedStringForLabel:dic.allKeys.firstObject];
            for (NSString *s in @[CNLabelHome,CNLabelWork,CNLabelOther]) {
                if ([[CNLabeledValue localizedStringForLabel:s] isEqualToString:dic.allKeys.firstObject]) {
                    label = s;
                }
            }
            [_arr addObject:[CNLabeledValue labeledValueWithLabel:label value:_v]];
        }
    }else if ([className isEqualToString:@"NSString"]) {
        for (NSDictionary *dic in arr) {
            NSString *label = [CNLabeledValue localizedStringForLabel:dic.allKeys.firstObject];
            for (NSString *s in @[CNLabelHome,CNLabelWork,CNLabelOther,CNLabelURLAddressHomePage,CNLabelEmailiCloud]) {
                if ([[CNLabeledValue localizedStringForLabel:s] isEqualToString:dic.allKeys.firstObject]) {
                    label = s;
                }
            }
            [_arr addObject:[CNLabeledValue labeledValueWithLabel:label value:dic.allValues.firstObject]];
        }
    }else if ([className isEqualToString:@"CNContactRelation"]) {
        for (NSDictionary *dic in arr) {
            CNContactRelation *relation = [[CNContactRelation alloc] initWithName:dic.allValues.firstObject];
            NSString *label = [CNLabeledValue localizedStringForLabel:dic.allKeys.firstObject];
            for (NSString *s in @[CNLabelHome,CNLabelWork,CNLabelOther,CNLabelContactRelationFather,CNLabelContactRelationMother,CNLabelContactRelationParent,CNLabelContactRelationBrother,CNLabelContactRelationSister,CNLabelContactRelationChild,CNLabelContactRelationFriend,CNLabelContactRelationSpouse,CNLabelContactRelationPartner,CNLabelContactRelationAssistant,CNLabelContactRelationManager]) {
                if ([[CNLabeledValue localizedStringForLabel:s] isEqualToString:dic.allKeys.firstObject]) {
                    label = s;
                }
            }
            [_arr addObject:[CNLabeledValue labeledValueWithLabel:label value:relation]];
        }
    }else if ([className isEqualToString:@"CNSocialProfile"]) {
        for (NSDictionary *dic in arr) {
            CNSocialProfile *relation = [[CNSocialProfile alloc] initWithUrlString:dic.allValues.firstObject[@"url"] username:dic.allValues.firstObject[@"username"] userIdentifier:nil service:dic.allValues.firstObject[@"service"]];
            NSString *label = [CNLabeledValue localizedStringForLabel:dic.allKeys.firstObject];
            for (NSString *s in @[CNLabelHome,CNLabelWork,CNLabelOther,CNSocialProfileServiceFacebook,CNSocialProfileServiceFlickr,CNSocialProfileServiceLinkedIn,CNSocialProfileServiceMySpace,CNSocialProfileServiceSinaWeibo,CNSocialProfileServiceTencentWeibo,CNSocialProfileServiceTwitter,CNSocialProfileServiceYelp,CNSocialProfileServiceGameCenter]) {
                if ([[CNLabeledValue localizedStringForLabel:s] isEqualToString:dic.allKeys.firstObject]) {
                    label = s;
                }
            }
            [_arr addObject:[CNLabeledValue labeledValueWithLabel:label value:relation]];
        }
    }else if ([className isEqualToString:@"CNInstantMessageAddress"]) {
        for (NSDictionary *dic in arr) {
            CNInstantMessageAddress *im = [[CNInstantMessageAddress alloc] initWithUsername:dic.allValues.firstObject[[CNInstantMessageAddress localizedStringForKey:CNInstantMessageAddressUsernameKey]] service:dic.allValues.firstObject[[CNInstantMessageAddress localizedStringForKey:CNInstantMessageAddressServiceKey]]];
            NSString *label = [CNLabeledValue localizedStringForLabel:dic.allKeys.firstObject];
            for (NSString *s in @[CNLabelHome,CNLabelWork,CNLabelOther,CNInstantMessageServiceAIM,CNInstantMessageServiceFacebook,CNInstantMessageServiceGaduGadu,CNInstantMessageServiceGoogleTalk,CNInstantMessageServiceICQ,CNInstantMessageServiceJabber,CNInstantMessageServiceMSN,CNInstantMessageServiceQQ,CNInstantMessageServiceSkype,CNInstantMessageServiceYahoo]) {
                if ([[CNLabeledValue localizedStringForLabel:s] isEqualToString:dic.allKeys.firstObject]) {
                    label = s;
                }
            }
            [_arr addObject:[CNLabeledValue labeledValueWithLabel:label value:im]];
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
            CFStringRef label = (__bridge CFStringRef)dic.allKeys.firstObject;
            for (NSString *s in @[(__bridge NSString *)kABPersonPhoneMobileLabel,(__bridge NSString *)kABPersonPhoneIPhoneLabel,(__bridge NSString *)kABPersonPhoneMainLabel,(__bridge NSString *)kABPersonPhoneHomeFAXLabel,(__bridge NSString *)kABPersonPhoneWorkFAXLabel,(__bridge NSString *)kABPersonPhoneOtherFAXLabel,(__bridge NSString *)kABPersonPhonePagerLabel,(__bridge NSString *)kABWorkLabel,(__bridge NSString *)kABHomeLabel,(__bridge NSString *)kABOtherLabel]) {
                if (CFStringCompare(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(s)), (__bridge CFStringRef)dic.allKeys.firstObject, kCFCompareLocalized)==kCFCompareEqualTo) {
                    label = (__bridge CFStringRef)(s);
                }
            }
            ABMultiValueAddValueAndLabel(arr, (__bridge CFStringRef)dic.allValues.firstObject, label, NULL);
        }
        return arr;
    }else if (property==kABPersonAddressProperty){
        ABMultiValueRef arr = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSDictionary *dic in value) {
            CFStringRef label = (__bridge CFStringRef)dic.allKeys.firstObject;
            for (NSString *s in @[(__bridge NSString *)kABWorkLabel,(__bridge NSString *)kABHomeLabel,(__bridge NSString *)kABOtherLabel]) {
                if (CFStringCompare(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(s)), (__bridge CFStringRef)dic.allKeys.firstObject, kCFCompareLocalized)==kCFCompareEqualTo) {
                    label = (__bridge CFStringRef)(s);
                }
            }
            ABMultiValueAddValueAndLabel(arr, (__bridge CFDictionaryRef)dic.allValues.firstObject, label, NULL);
        }
        return arr;
    }else if (property==kABPersonDateProperty){
        ABMultiValueRef arr = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSDictionary *dic in value) {
            CFStringRef label = (__bridge CFStringRef)dic.allKeys.firstObject;
            
            for (NSString *s in @[(__bridge NSString *)kABWorkLabel,(__bridge NSString *)kABHomeLabel,(__bridge NSString *)kABOtherLabel,(__bridge NSString *)kABPersonAnniversaryLabel]) {
                if (CFStringCompare(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(s)), (__bridge CFStringRef)dic.allKeys.firstObject, kCFCompareLocalized)==kCFCompareEqualTo) {
                    label = (__bridge CFStringRef)(s);
                }
            }
            CFDateRef date = (__bridge CFDateRef)([formatter dateFromString:dic.allValues.firstObject]);
            ABMultiValueAddValueAndLabel(arr, date, label, NULL);
        }
        return arr;
    }else if (property==kABPersonURLProperty){
        ABMultiValueRef arr = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSDictionary *dic in value) {
            CFStringRef label = (__bridge CFStringRef)dic.allKeys.firstObject;
            
            for (NSString *s in @[(__bridge NSString *)kABWorkLabel,(__bridge NSString *)kABHomeLabel,(__bridge NSString *)kABOtherLabel,(__bridge NSString *)kABPersonHomePageLabel]) {
                if (CFStringCompare(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(s)), (__bridge CFStringRef)dic.allKeys.firstObject, kCFCompareLocalized)==kCFCompareEqualTo) {
                    label = (__bridge CFStringRef)(s);
                }
            }
            ABMultiValueAddValueAndLabel(arr, (__bridge CFDictionaryRef)dic.allValues.firstObject, label, NULL);
        }
        return arr;
    }else if (property==kABPersonRelatedNamesProperty){
        ABMultiValueRef arr = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSDictionary *dic in value) {
            CFStringRef label = (__bridge CFStringRef)dic.allKeys.firstObject;
            
            for (NSString *s in @[(__bridge NSString *)kABWorkLabel,(__bridge NSString *)kABHomeLabel,(__bridge NSString *)kABOtherLabel,(__bridge NSString *)kABPersonFatherLabel,(__bridge NSString *)kABPersonMotherLabel,(__bridge NSString *)kABPersonParentLabel,(__bridge NSString *)kABPersonBrotherLabel,(__bridge NSString *)kABPersonSisterLabel,(__bridge NSString *)kABPersonChildLabel,(__bridge NSString *)kABPersonFriendLabel,(__bridge NSString *)kABPersonSpouseLabel,(__bridge NSString *)kABPersonPartnerLabel,(__bridge NSString *)kABPersonAssistantLabel,(__bridge NSString *)kABPersonManagerLabel]) {
                if (CFStringCompare(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(s)), (__bridge CFStringRef)dic.allKeys.firstObject, kCFCompareLocalized)==kCFCompareEqualTo) {
                    label = (__bridge CFStringRef)(s);
                }
            }
            ABMultiValueAddValueAndLabel(arr, (__bridge CFDictionaryRef)dic.allValues.firstObject, label, NULL);
        }
        return arr;
    }else if (property==kABPersonSocialProfileProperty){
        ABMultiValueRef arr = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSDictionary *dic in value) {
            CFStringRef label = (__bridge CFStringRef)dic.allKeys.firstObject;
            
            for (NSString *s in @[(__bridge NSString *)kABWorkLabel,(__bridge NSString *)kABHomeLabel,(__bridge NSString *)kABOtherLabel,(__bridge NSString *)kABPersonFatherLabel,(__bridge NSString *)kABPersonSocialProfileServiceTwitter,(__bridge NSString *)kABPersonSocialProfileServiceSinaWeibo,(__bridge NSString *)kABPersonSocialProfileServiceGameCenter,(__bridge NSString *)kABPersonSocialProfileServiceFacebook,(__bridge NSString *)kABPersonSocialProfileServiceMyspace,(__bridge NSString *)kABPersonSocialProfileServiceLinkedIn,(__bridge NSString *)kABPersonSocialProfileServiceFlickr]) {
                if (CFStringCompare(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(s)), (__bridge CFStringRef)dic.allKeys.firstObject, kCFCompareLocalized)==kCFCompareEqualTo) {
                    label = (__bridge CFStringRef)(s);
                }
            }
            ABMultiValueAddValueAndLabel(arr, (__bridge CFDictionaryRef)dic.allValues.firstObject, label, NULL);
            
        }
        return arr;
    }else if (property==kABPersonInstantMessageProperty){
        ABMultiValueRef arr = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSDictionary *dic in value) {
            CFStringRef label = (__bridge CFStringRef)dic.allKeys.firstObject;
            
            for (NSString *s in @[(__bridge NSString *)kABWorkLabel,(__bridge NSString *)kABHomeLabel,(__bridge NSString *)kABOtherLabel,(__bridge NSString *)kABPersonInstantMessageServiceYahoo,(__bridge NSString *)kABPersonInstantMessageServiceJabber,(__bridge NSString *)kABPersonInstantMessageServiceMSN,(__bridge NSString *)kABPersonInstantMessageServiceICQ,(__bridge NSString *)kABPersonInstantMessageServiceAIM,(__bridge NSString *)kABPersonInstantMessageServiceQQ,(__bridge NSString *)kABPersonInstantMessageServiceGoogleTalk,(__bridge NSString *)kABPersonInstantMessageServiceSkype,(__bridge NSString *)kABPersonInstantMessageServiceFacebook,(__bridge NSString *)kABPersonInstantMessageServiceGaduGadu]) {
                if (CFStringCompare(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(s)), (__bridge CFStringRef)dic.allKeys.firstObject, kCFCompareLocalized)==kCFCompareEqualTo) {
                    label = (__bridge CFStringRef)(s);
                }
            }
            ABMultiValueAddValueAndLabel(arr, (__bridge CFDictionaryRef)dic.allValues.firstObject, label, NULL);
            
        }
        return arr;
    }else if (property==kABPersonEmailProperty){
        ABMultiValueRef arr = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSDictionary *dic in value) {
            CFStringRef label = (__bridge CFStringRef)dic.allKeys.firstObject;
            
            for (NSString *s in @[(__bridge NSString *)kABWorkLabel,(__bridge NSString *)kABHomeLabel,(__bridge NSString *)kABOtherLabel]) {
                if (CFStringCompare(ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)(s)), (__bridge CFStringRef)dic.allKeys.firstObject, kCFCompareLocalized)==kCFCompareEqualTo) {
                    label = (__bridge CFStringRef)(s);
                }
            }
            ABMultiValueAddValueAndLabel(arr, (__bridge CFDictionaryRef)dic.allValues.firstObject, label, NULL);
            
        }
        return arr;
    }
    return NULL;
}
-(BOOL)isContactValable:(NSDictionary *)dic{
    return (dic[kContactServiceName]&&dic[kServiceTels]&&[dic[kServiceTels] isKindOfClass:[NSArray class]])&&([dic[kContactServiceName] length]>0||[dic[kServiceTels] count]>0);
}
-(NSArray *)withoutFirstObjectFromData:(NSArray *)arr{
    NSMutableArray *arrNew = [[NSMutableArray alloc] initWithArray:arr];
    if(arrNew.count>0)[arrNew removeObjectAtIndex:0];
    return arrNew;
}
@end
