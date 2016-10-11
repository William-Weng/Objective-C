//
//  TextTools.m
//  MyCardApp
//
//  Created by William-Weng on 2016/7/27.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import "TextTools.h"
#import "MyConst.h"

@implementation TextTools

+ (NSString *)getHomePath {
    
    NSString *homePath = NSHomeDirectory();
    return homePath;
}

+ (NSString *)getDocumentsPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

+ (NSString *)getDocumentsOtherCardsPlistPath{
    
    NSString* path = [[self getDocumentsPath] stringByAppendingPathComponent:OTHERCARDS_PLISTNAME];
    return path;
}

+ (NSString *)getDocumentsMyCardsPlistPath{
    
    NSString* path = [[self getDocumentsPath] stringByAppendingPathComponent:MYCARDS_PLISTNAME];
    return path;
}

+ (NSString *)getDocumentsBaseCardPlistPath{
    
    NSString* path = [[self getDocumentsPath] stringByAppendingPathComponent:MYCARDS_PLISTNAME];
    return path;
}

- (NSString *)getFileContentFromMainBundle:(NSString*)filename {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil inDirectory:nil];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return content;
}

- (NSMutableDictionary *)getDictionaryFromJSONString:(NSString*)json {
    
    if (json == nil) {
        return nil;
    }
    
    NSError *jsonError;
    NSData *objectData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:objectData options:0 error:&jsonError];
    return [jsonDic mutableCopy];
}

- (NSString *)getUTF8SiteFromGoogleChartAPI:(NSString*)barCodeType content:(NSString*)content imageSize:(NSString*)imageSize{
    
    NSString *contentUTF8 = [[NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=%@&chl=%@&chs=%@", barCodeType, content, imageSize] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return contentUTF8;
}

- (NSString *)removeSpaceAndNewline:(NSString *)content {

    NSString *string = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return string;
}

@end
