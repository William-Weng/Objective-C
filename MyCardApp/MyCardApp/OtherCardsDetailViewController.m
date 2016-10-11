//
//  OtherCardsDetailViewController.m
//  MyCardApp
//
//  Created by William-Weng on 2016/7/31.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import "OtherCardsDetailViewController.h"
#import "OSTools.h"
#import "Toast/UIView+Toast.h"
#import "MyConst.h"

@interface OtherCardsDetailViewController () {

    NSInteger lineCount, lineHeight;
    CGSize mainScreenSize;
    UIColor *keyColor, *keyTextColor;
    UIColor *valueColor, *valueTextColor;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation OtherCardsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConst];
    [self initCardLabel];
    self.scrollView.contentSize = CGSizeMake(mainScreenSize.width, lineCount * lineHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CustomFunction

- (UILabel*)labelFactory:(CGRect)rect content:(NSString*)content bgColor:(UIColor*)color textColor:(UIColor*)textColor{
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    UILongPressGestureRecognizer *myLongTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(labelLongPressed:)];
    
    label.text = content;
    label.textColor = textColor;
    label.backgroundColor = color;
    label.userInteractionEnabled = YES; // 開啟使用者互動(觸碰)

    label.font = [UIFont boldSystemFontOfSize:lineHeight / 2]; // 文字大小、粗細
    label.textAlignment = NSTextAlignmentCenter; // 文字置中
    label.clipsToBounds = YES;
    [label layer].cornerRadius = 10; // 設定圓角
    [label layer].borderWidth = 1.0;
    [label addGestureRecognizer:myLongTapGesture];
    
    return label;
}

- (void)toastMessage:(NSString*)content { // https://cocoapods.org/pods/Toast
    
    NSValue *toastValue = [NSValue valueWithCGSize:[OSTools getToastSize]];
    [self.view makeToast:content duration:TOAST_LENGTH_SHORT position:toastValue style:nil];
}

#pragma mark - initialize

- (void)initConst {
    
    keyColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.5 alpha:1.0];
    keyTextColor = [UIColor whiteColor];
    valueColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    valueTextColor = [UIColor blackColor];
    mainScreenSize = [OSTools getMainScreenSize];
    lineHeight = 40;
}

- (void)initCardLabel {
    
    NSArray *cardDetail = [self.cardDetail.mainInfo arrayByAddingObjectsFromArray:self.cardDetail.othersInfo];
    
    for (int n=0; n<cardDetail.count; n++) {
        
        CGRect keyRect = CGRectMake(0, lineHeight*(2*n), mainScreenSize.width, lineHeight);
        NSString *keyContent = cardDetail[n][@"key"];
        
        UILabel *keyLabel = [self labelFactory:keyRect content:keyContent bgColor:keyColor textColor:keyTextColor];
        
        CGRect valueRect = CGRectMake(0, lineHeight*(2*n+1), mainScreenSize.width, lineHeight);
        NSString *valueContent = cardDetail[n][@"value"];
        UILabel *valueLabel = [self labelFactory:valueRect content:valueContent bgColor:valueColor textColor:valueTextColor];

        [self.scrollView addSubview:keyLabel];
        [self.scrollView addSubview:valueLabel];
        
        lineCount += 2;
    }
}

#pragma mark - IBAction

- (void)labelLongPressed:(UILongPressGestureRecognizer*)gesture { // http://www.it610.com/article/4963483.htm
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UILabel* label = (UILabel*)[gesture view]; // 取得所點到位置的UILabel
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard]; // 取得系統剪貼簿
        NSString *toastString = @"複製成功 -> [%@]";
        
        pasteboard.string = label.text;
        
        if (!pasteboard.string) {
            toastString = @"複製失敗 -> [%@]";
        }
        
        [self toastMessage:[NSString stringWithFormat:toastString, pasteboard.string]];
    }
}

@end
