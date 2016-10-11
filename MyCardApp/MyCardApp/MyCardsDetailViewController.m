//
//  MyCardsDetailViewController.m
//  MyCardApp
//
//  Created by William-Weng on 2016/8/5.
//  Copyright © 2016年 William-Weng. All rights reserved.
//

#import "MyCardsDetailViewController.h"
#import "MyTableViewCell.h"
#import "MyConst.h"
#import "Toast/UIView+Toast.h"
#import "OSTools.h"

@interface MyCardsDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    
    NSArray *myCardDetail;
    NSMutableArray *mainInfo, *othersInfo;
    NSIndexPath *nowSelectedIndexPath;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation MyCardsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    [self initConst];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - KeyboardHeight

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.keyboardHeight.constant = self.view.frame.size.height-self.toolbar.frame.size.height;
    [self.tableView setNeedsUpdateConstraints];
    [self.toolbar setNeedsUpdateConstraints];
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
}

#pragma mark - UITableViewDelegate

- (void)setEditing:(BOOL)editing animated:(BOOL)animated { // 設定editButtonItem的動畫
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return myCardDetail.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCardCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < self.cardDetail.mainInfo.count) {
        cell.keyTextField.enabled = NO;
    }
    
    cell.keyTextField.delegate = self;
    cell.keyTextField.text = myCardDetail[indexPath.row][KEY];

    cell.valueTextField.delegate = self;
    cell.valueTextField.text = myCardDetail[indexPath.row][VALUE];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { // 按下cell上按鍵所做的事，移除資料，刪除畫面
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [othersInfo removeObjectAtIndex:indexPath.row - mainInfo.count];
        myCardDetail = [mainInfo arrayByAddingObjectsFromArray:othersInfo];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (indexPath.row < mainInfo.count) ? NO : YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.valueTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField*)textField { // 開始進入編輯狀態
    
    CGPoint touchLocation = [textField convertPoint:textField.bounds.origin toView:self.tableView]; // http://stackoverflow.com/questions/9581648/get-the-position-of-an-element
    nowSelectedIndexPath = [self.tableView indexPathForRowAtPoint:touchLocation]; // 點擊位置 ==> indexPath
    
    [self.tableView selectRowAtIndexPath:nowSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)textFieldDidEndEditing:(UITextField *)textField { // 結束編輯狀態(意指完成輸入或離開焦點)
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField { // 利用此方式讓按下Return後會Toogle 鍵盤讓它消失
    
    [textField resignFirstResponder];
    return false;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField { // 可能進入結束編輯狀態
    return YES;
}

#pragma mark - IBAction

- (IBAction)saveCard:(UIBarButtonItem *)sender {

    [self.delegate updateCards:self.cardDetail];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addField:(UIBarButtonItem *)sender {
    
    if (myCardDetail.count >= 20) {
        [self toastMessage:@"最多20筆資料"];
        return;
    }
    
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:myCardDetail.count inSection:0];
    NSDictionary *defaultDictionary = @{KEY:@"欄位", VALUE:@"請更改數值"};
    
    [othersInfo addObject:[defaultDictionary mutableCopy]]; // 轉成NSMutableDictionary才可以修改
    
    myCardDetail = [mainInfo arrayByAddingObjectsFromArray:othersInfo];
    
    [self.tableView insertRowsAtIndexPaths:@[lastIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self toastMessage:@"新增欄位成功"];
}

- (IBAction)textFieldOfKeyDidChange:(UITextField *)sender {
    
    if (nowSelectedIndexPath.row >= mainInfo.count) {
        othersInfo[nowSelectedIndexPath.row - mainInfo.count][KEY] = sender.text;
        return;
    }
}

- (IBAction)textFieldOfValueDidChange:(UITextField *)sender {
    
    if (nowSelectedIndexPath.row >= mainInfo.count) {
        
        othersInfo[nowSelectedIndexPath.row - mainInfo.count][VALUE] = sender.text;
        return;
    }
    
    mainInfo[nowSelectedIndexPath.row][VALUE] = sender.text;
}

#pragma mark - NSNotification for Keyboard

- (void)keyboardWillShow:(NSNotification*)notification { // http://blog.airweb.tw/2015/08/ios-nsnotificationcenter.html
    
    NSDictionary *info = notification.userInfo;
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    double keyboardHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    self.keyboardHeight.constant = self.view.frame.size.height - keyboardHeight - self.toolbar.frame.size.height;
    
    [self.tableView setNeedsUpdateConstraints];
    [self.toolbar setNeedsUpdateConstraints];
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationOptions)curve animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)notification {

    NSDictionary *info = notification.userInfo;
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    self.keyboardHeight.constant = self.view.frame.size.height - self.toolbar.frame.size.height;
    
    [self.view setNeedsUpdateConstraints];
    [self.tableView setNeedsUpdateConstraints];
    [self.toolbar setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationOptions)curve animations:^{
        [self.view layoutIfNeeded];
        
    } completion:nil];
}

#pragma mark - CustomFunction

- (void)initConst {
    
    if (self.cardDetail.othersInfo.count == 0) {
        self.cardDetail.othersInfo = [NSMutableArray array];
    }
    
    nowSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    mainInfo = self.cardDetail.mainInfo;
    othersInfo = self.cardDetail.othersInfo;
    
    myCardDetail = [mainInfo arrayByAddingObjectsFromArray:othersInfo];
}

- (void)initView {

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"MyTableViewCell"];
    [self.tableView selectRowAtIndexPath:nowSelectedIndexPath animated:YES  scrollPosition:UITableViewScrollPositionTop];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem; // 開啟editButtonItem
}

- (void)toastMessage:(NSString*)content { // https://cocoapods.org/pods/Toast
    
    NSValue *toastValue = [NSValue valueWithCGSize:[OSTools getToastSize]];
    
    [self.view makeToast:content duration:TOAST_LENGTH_SHORT position:toastValue style:nil];
}

@end
