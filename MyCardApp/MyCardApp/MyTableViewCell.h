//
//  MyTableViewCell.h
//  MyCardApp
//
//  Created by William-Weng on 2016/8/5.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end
