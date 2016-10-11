//
//  LicenseViewController.m
//  MyCardApp
//
//  Created by William-Weng on 2016/8/20.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import "LicenseViewController.h"
#import <WebKit/WebKit.h>

@interface LicenseViewController ()
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end

@implementation LicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.baseView.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    [self.baseView addSubview:webView];
    
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"License" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
