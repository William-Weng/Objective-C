//
//  CardsViewControlerDelegate.h
//  MyCardApp
//
//  Created by William-Weng on 2016/7/31.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@protocol CardsViewControllerDelegate <NSObject>

- (void)updateCards:(Card*)card;

@end
