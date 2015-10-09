//
//  NSString+Pinyin.m
//  base
//
//  Created by wangshuguan on 15/6/13.
//  Copyright (c) 2015年 wsg. All rights reserved.
//

#import "NSString+Pinyin.h"
#define wordStart 19968
#define wordCount 20931
inline NSString* doubleNumberCovertToString(double number){
    return [NSString stringWithFormat:((long long)(number*1000000))%1000000==0?@"%.0f":((long long)(number*1000000))%100000==0?@"%.1f":((long long)(number*1000000))%10000==0?@"%.2f":((long long)(number*1000000))%1000==0?@"%.3f":((long long)(number*1000000))%100==0?@"%.4f":((long long)(number*1000000))%10==0?@"%.5f":((long long)(number*1000000))%1==0?@"%.6f":@"%f",number];
}
@implementation NSString(Pinyin)
- (NSString *)pinyinFromSource:(NSDictionary *)sourceDictionary{
    NSMutableString *str = [[NSMutableString alloc]init];
    NSString *target = self;
    for (int i=0; i<target.length; i++) {
        NSString *subStr = [target substringWithRange:NSMakeRange(i, 1)];
        int j = [subStr characterAtIndex:0];
        if (j>=wordStart&&j<=wordStart+wordCount) {
            [str appendString:sourceDictionary[[NSString stringWithFormat:@"%d",j]]];
        }else{
            [str appendString:subStr];
        }
    }
    return str;
}

-(NSString *)pinyin{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, 0, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, 0, kCFStringTransformStripDiacritics, NO);
    [str setString:[str stringByReplacingOccurrencesOfString:@" " withString:@""]];
    return str;
}
-(NSString *)pinyinFirstLettersWithSource:(NSDictionary *)sourceDictionary{
    NSMutableString *str = [NSMutableString new];
    for (int i=0; i<self.length; i++) {
        [str appendString:[[[self stringAtIndex:i].stringFromUnicode pinyinFromSource:sourceDictionary] stringAtIndex:0].stringFromUnicode];
    }
    return str;
}
-(NSString *)stringAtIndex:(NSUInteger)index{
    unichar uchar = [self characterAtIndex:index];
    NSString *str = (uchar <= '9' && uchar >= '0')||(uchar >= 'a' && uchar <= 'z')?[self substringWithRange:NSMakeRange(index, 1)]:[NSString stringWithFormat:@"\\u%hx",[self characterAtIndex:index]];
    return str;
}
-(NSString *)stringFromUnicode{
    NSData *temp = [[[@"\""stringByAppendingString:[[self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]] stringByAppendingString:@"\""] dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSPropertyListSerialization propertyListWithData:temp options:NSPropertyListImmutable format:NULL error:nil] stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
- (NSString *) capitalizedFirstCharacterString
{
    if ([self length] > 0)
    {
        NSString *firstChar = [[self substringToIndex:1] capitalizedString];
        return [firstChar stringByAppendingString:[self substringFromIndex:1]];
    }
    return self;
}
@end
