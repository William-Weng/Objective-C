//
//  ScanQRCodeViewController.h
//  MyCardApp
//
//  Created by William-Weng on 2016/7/30.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardsViewControlerDelegate.h"

@interface ScanQRCodeViewController : UIViewController

@property (nonatomic) id<CardsViewControllerDelegate> delegate;

@end
