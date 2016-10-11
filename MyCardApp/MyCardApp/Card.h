//
//  Card.h
//  MyCardApp
//
//  Created by William-Weng on 2016/7/27.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic) NSString *sid;
@property (nonatomic) NSString *imageName;
@property (nonatomic) NSMutableArray *mainInfo;
@property (nonatomic) NSMutableArray *othersInfo;

- (Card*)initWithBase;
- (NSMutableDictionary*)toDictionary;
- (void)setPropertiesFromDictionary:(NSDictionary*)jsonDictionary;
- (NSData *)toJSONData;
- (NSString *)toJSON;
- (BOOL)isCard;
@end
