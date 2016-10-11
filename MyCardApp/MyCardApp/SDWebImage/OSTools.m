//
//  OSTools.m
//  MyCardApp
//
//  Created by William-Weng on 2016/8/3.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import "OSTools.h"

@implementation OSTools

+ (CGRect)getMainScreenBounds {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect;
}

+ (CGSize)getMainScreenSize {

    CGSize screenSize = [self getMainScreenBounds].size;
    return screenSize;
}

+ (CGSize)getToastSize {
    
    CGSize mainScreenSize = [self getMainScreenSize];
    CGSize toastSize = CGSizeMake(mainScreenSize.width / 2, mainScreenSize.height - 44.0 * 2);
    
    return toastSize;
}
@end
