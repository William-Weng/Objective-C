//
//  ScanQRCodeViewController.m
//  MyCardApp
//
//  Created by William-Weng on 2016/7/30.
//  Copyright © 2016年 William-Weng. All rights reserved.
//
// http://www.appcoda.com/qr-code-ios-programming-tutorial/

#import "ScanQRCodeViewController.h"
#import "Card.h"
#import "TextTools.h"
#import "Toast/UIView+Toast.h"
#import "MyConst.h"
#import "OSTools.h"

@import AVFoundation;

@interface ScanQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    NSString *qrcode;
}

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;

@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (BOOL)startReading;
- (void)stopReading;
- (void)loadBeepSound:(NSString*)sound;
@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isReading = NO;
    _captureSession = nil;
    qrcode = nil;
    
    [self loadBeepSound:@"Beep.wav"];
    [self startReading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startStopReading:(UIBarButtonItem *)sender {
    
    if (!_isReading) {
        if ([self startReading]) {
            [_bbitemStart setTitle:@"Stop"];
        }
    }
    else {
        [self stopReading];
        [_bbitemStart setTitle:@"Start!"];
    }
    
    _isReading = !_isReading;
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        // NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];

    return YES;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            // [_textField performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            qrcode = [metadataObj stringValue];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            _isReading = NO;
            
//            if (_audioPlayer) {
//                [_audioPlayer play];
//            }

            [self loadBeepSound:@"Shutter.wav"];
        }
    }
}

- (void)loadBeepSound:(NSString*)sound{
    
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:sound ofType:nil];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // NSLog(@"Could not play beep file.");
        // NSLog(@"%@", [error localizedDescription]);
    }
    else {
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
    }
}

- (void)toastMessage:(NSString*)content { // https://cocoapods.org/pods/Toast
    
    NSValue *toastValue = [NSValue valueWithCGSize:[OSTools getToastSize]];
    [self.view makeToast:content duration:TOAST_LENGTH_SHORT position:toastValue style:nil];
}

- (IBAction)saveCard:(UIBarButtonItem *)sender {
    
    Card *card = [Card new];
    TextTools *tools = [TextTools new];
    
    NSDictionary *cardDictionary = [tools getDictionaryFromJSONString:qrcode];
    
    [card setPropertiesFromDictionary:cardDictionary];
    
    if (![card isCard]) {
        
        [self loadBeepSound:@"Error.wav"];
        [self toastMessage:@"格式錯誤"];
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
        
        return;
    }
    
    [self loadBeepSound:@"OK.wav"];
    [self toastMessage:@"新增成功"];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    [self.delegate updateCards:card];
    
    qrcode = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goBackListView:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

