//
//  MyCardsDetailViewController.h
//  MyCardApp
//
//  Created by William-Weng on 2016/8/5.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "CardsViewControlerDelegate.h"

@interface MyCardsDetailViewController : UIViewController

@property (nonatomic) Card* cardDetail;
@property (nonatomic) id<CardsViewControllerDelegate> delegate;

@end
