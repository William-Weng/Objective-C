//
//  OSTools.h
//  MyCardApp
//
//  Created by William-Weng on 2016/8/3.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface OSTools : NSObject

+ (CGRect)getMainScreenBounds;
+ (CGSize)getMainScreenSize;
+ (CGSize)getToastSize;
@end