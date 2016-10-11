//
//  Card.m
//  MyCardApp
//
//  Created by William-Weng on 2016/7/27.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import "Card.h"
#import "TextTools.h"
#import "MyConst.h"

@import ObjectiveC;

@implementation Card

- (Card*)initWithBase {
    
    TextTools *tools = [TextTools new];
    
    NSString *json = [tools getFileContentFromMainBundle:BASECARD_JSON];
    NSDictionary *dictionary = [tools getDictionaryFromJSONString:json];
    [self setPropertiesFromDictionary:dictionary];
    
    return self;
}

- (NSDictionary*)toDictionary { // 利用KVO把屬性 ==> NSDictionary
    
    NSArray *propertyNames = [self getPropertyNames];
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    for (NSString *propertyName in propertyNames) {
        [dictionary setValue:[self valueForKey:propertyName] forKey:propertyName];
    }

    return dictionary;
}

- (void)setPropertiesFromDictionary:(NSDictionary*)jsonDictionary { // 利用KVO把Dictionary ==> 屬性

    NSArray *propertyNames = [self getPropertyNames];

    for (NSString *propertyName in propertyNames) {
        [self setValue:jsonDictionary[propertyName] forKey:propertyName];
    }
}

- (NSData *)toJSONData { // NSDictionary ==> NSData
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self toDictionary] options:NSJSONWritingPrettyPrinted error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    } else {
        return nil;
    }
}

- (NSString*)toJSON { // NSData ==> NSString
    
    NSData *jsonData = [self toJSONData];
    
    if (jsonData == nil) {
        return nil;
    }
    
    TextTools *textTools = [TextTools new];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return [textTools removeSpaceAndNewline:jsonString];
}

- (BOOL)isCard {
    
    NSArray *propertyNames = [self getPropertyNames];
    
    for (NSString *propertyName in propertyNames) {
        if ([self valueForKey:propertyName] == nil) {
            return NO;
        };
    }
    
    return YES;
}

#pragma mark - StackOverflow

- (NSArray*)getPropertyNames { // 取得class上的屬性 ==> http://goo.gl/D5JhwW
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    NSMutableArray *propertyNames = [NSMutableArray array];
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    
    free(properties);
    
    return propertyNames;
}

@end
