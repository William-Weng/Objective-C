//
//  MyTableViewCell.m
//  MyCardApp
//
//  Created by William-Weng on 2016/8/5.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.contentView.backgroundColor = selected ? [UIColor blueColor] : [UIColor clearColor];
}

@end
