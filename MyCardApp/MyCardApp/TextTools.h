//
//  TextTools.h
//  MyCardApp
//
//  Created by William-Weng on 2016/7/27.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextTools : NSObject

+ (NSString *)getHomePath;
+ (NSString *)getDocumentsPath;
+ (NSString *)getDocumentsOtherCardsPlistPath;
+ (NSString *)getDocumentsMyCardsPlistPath;
+ (NSString *)getDocumentsBaseCardPlistPath;

- (NSString *)getFileContentFromMainBundle:(NSString*)filename;
- (NSDictionary *)getDictionaryFromJSONString:(NSString*)json;
- (NSString *)getUTF8SiteFromGoogleChartAPI:(NSString*)barCodeType content:(NSString*)content imageSize:(NSString*)imageSize;
- (NSString *)removeSpaceAndNewline:(NSString *)content;

@end
