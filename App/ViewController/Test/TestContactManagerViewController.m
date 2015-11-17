//
//  TestContactManagerViewController.m
//  base
//
//  Created by wsg on 15/9/7.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "TestContactManagerViewController.h"
@import AddressBook;

@interface TestContactManagerViewController ()

@end

@implementation TestContactManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self deleteContacts];
    [self createContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deleteContacts{
    ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
    CFErrorRef error = NULL;
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    //通讯录中人数
    for (int i=0; i<nPeople; i++) {
        ABRecordRef oldPeople = CFArrayGetValueAtIndex(allPeople, i);
        if (!oldPeople) {
            return;
        }
        NSLog(@"%f",i/(float)nPeople);
        ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRemoveRecord(iPhoneAddressBook, oldPeople, &error);
        ABAddressBookSave(iPhoneAddressBook, &error);
        CFRelease(iPhoneAddressBook);
        CFRelease(oldPeople);
    }
    CFRelease(addressBooks);
    

}
-(void)createContacts{
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"twelve-thousand-contact" ofType:@""] encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [str componentsSeparatedByString:@"\n"];
    
    
    
    ABAddressBookRef addressBooks = nil;
    addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
    //获取通讯录权限
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSInteger index=0;
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    for (NSString *contactString in arr) {
        DDLogInfo(@"%ld",(long)index++);
        if(index<=4356)continue;
        NSArray *arrOfField = [contactString componentsSeparatedByString:@","];
        ABRecordRef newPerson = ABPersonCreate();
        CFErrorRef error = NULL;
        ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)((NSString *)arrOfField[0]), &error);
        ABRecordSetValue(newPerson, kABPersonLastNameProperty, @"", &error);
        ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"", &error);
        ABRecordSetValue(newPerson, kABPersonFirstNamePhoneticProperty, @"", &error);
        ABRecordSetValue(newPerson, kABPersonLastNamePhoneticProperty, @"", &error);
        //phone number
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)((NSString *)arrOfField[2]), kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
        CFRelease(multiPhone);
        //picture
        ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
        ABAddressBookSave(iPhoneAddressBook, &error);
        CFRelease(newPerson);
    }
    CFRelease(iPhoneAddressBook);
}
@end
