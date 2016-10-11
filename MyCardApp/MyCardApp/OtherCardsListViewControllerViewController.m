//
//  OtherCardsListViewControllerViewController.m
//  MyCardApp
//
//  Created by William-Weng on 2016/8/1.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import "OtherCardsListViewControllerViewController.h"
#import "Card.h"
#import "TextTools.h"
#import "UIImageView+WebCache.h"
#import "CardsViewControlerDelegate.h"
#import "ScanQRCodeViewController.h"
#import "OtherCardsDetailViewController.h"
#import "MyConst.h"

@interface OtherCardsListViewControllerViewController () <UITableViewDelegate, UITableViewDataSource, CardsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *cards;

@end

@implementation OtherCardsListViewControllerViewController

#pragma mark - initialize

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    
    if (self) {
        self.cards = [NSMutableArray array];
        [self initCards];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.leftBarButtonItem = self.editButtonItem; // 開啟editButtonItem
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCardCell" forIndexPath:indexPath];
    UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
    
    Card* card = self.cards[indexPath.row];
    
    cell.imageView.userInteractionEnabled = YES; // 讓imageView觸碰有反應
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = card.mainInfo[0][VALUE];
    cell.detailTextLabel.text = card.mainInfo[1][VALUE];
    
    [cell.imageView addGestureRecognizer:myTapGesture];
    
    return cell;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated { // 設定editButtonItem的動畫
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath { // 開啟cell移動的功能，移動 = 暫存 -> 刪除 -> 新增
    
    Card* card = self.cards[sourceIndexPath.row];
    [self.cards removeObjectAtIndex:sourceIndexPath.row];
    [self.cards insertObject:card atIndex:destinationIndexPath.row];
    
    [self saveToPlist];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { // 按下cell上按鍵所做的事，移除資料，刪除畫面

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.cards removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        [self saveToPlist];
    }
}

#pragma mark - CustomFunction
- (IBAction)callBack:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageViewPressed:(UITapGestureRecognizer*)gesture { // 手勢參數 ==> UITapGestureRecognizer
    
    CGPoint touchLocation = [gesture locationInView:self.tableView]; // 取得點擊的位置
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:touchLocation]; // 點擊位置 ==> indexPath
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] animated:NO scrollPosition:0]; // 讓table上的row被選到
    [self showBarCode:@"qr" content:self.cards[indexPath.row] imageSize:@"240x240"];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"QRCodeSegue"]) {
        ScanQRCodeViewController* scanQRCodeViewController = segue.destinationViewController;
        
        scanQRCodeViewController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"OtherCardsDetailSegue"]) {
        OtherCardsDetailViewController* otherCardsDetailViewController = segue.destinationViewController;
        
        NSIndexPath* indexPath = self.tableView.indexPathForSelectedRow;
        otherCardsDetailViewController.cardDetail = self.cards[indexPath.row];
    }
}

#pragma mark - CustomFunction

- (void)initCards {
    
    NSString *plistFullPath = [TextTools getDocumentsOtherCardsPlistPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistFullPath]) {
        return;
    }
    
    [self loadFromPlist:plistFullPath];
}

- (void)showBarCode:(NSString*)barCodeType content:(Card*)card imageSize:(NSString*)imageSize {
    
    TextTools *textTools = [[TextTools alloc] init];
    NSString *qrcodeSite = [textTools getUTF8SiteFromGoogleChartAPI:barCodeType content:[card toJSON] imageSize:imageSize];
    NSURL *qrcodeURL = [NSURL URLWithString:qrcodeSite];
    UIImageView* ivMyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[card mainInfo][0][@"value"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"YES", nil];
    
    ivMyImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [ivMyImageView sd_setImageWithURL:qrcodeURL placeholderImage:[UIImage imageNamed:@"Waiting"]];
    [alert setValue:ivMyImageView forKey:@"accessoryView"];
    [alert show];
}

#pragma mark - CardsViewControlerDelegate

- (void)updateCards:(Card*)card { // 更新cards，同時將資料寫入plist檔案
    
    NSLog(@"updateCards == > %@", card.toJSON);
    
    [self.cards addObject:card];
    [self saveToPlist];
    [self.tableView reloadData];
}

- (void)saveToPlist { // cards ==> NSDictionary ==> plist
    
    NSMutableDictionary* cardsDictionary = [NSMutableDictionary new];
    NSMutableArray* cardsArray = [NSMutableArray new];
    
    for (Card *card in self.cards) {
        [cardsArray addObject:[card toDictionary]];
    }
    
    [cardsDictionary setValue:@([self.cards count]) forKey:@"count"];
    [cardsDictionary setValue:[self.cards valueForKey:@"sid"] forKey:@"cardIDs"];
    [cardsDictionary setValue:cardsArray forKey:@"cards"];
    
    [cardsDictionary writeToFile:[TextTools getDocumentsOtherCardsPlistPath] atomically:YES];
}

- (void)loadFromPlist:(NSString*)path {
    NSDictionary *jsonDic = [NSDictionary dictionaryWithContentsOfFile:path]; // 讀取plist ==> NSDictionary
    NSArray *cards = jsonDic[@"cards"]; // 取得資料的名片部份
    
    for (NSDictionary *card in cards) { // cards ==> card
        
        Card *newCard = [Card new];
        [newCard setPropertiesFromDictionary:card];
        [self.cards addObject:newCard];
    }
}

@end
