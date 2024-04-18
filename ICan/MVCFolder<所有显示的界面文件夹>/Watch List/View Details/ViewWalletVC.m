//
//  ViewWalletVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ViewWalletVC.h"
#import "AssetsDataCell.h"
#import "ChatViewHandleTool.h"

@interface ViewWalletVC ()
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *address1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *assetsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgCardView;
@property (weak, nonatomic) IBOutlet UILabel *currencyType1;
@property (weak, nonatomic) IBOutlet UILabel *currencyType2;
@property (weak, nonatomic) IBOutlet UIStackView *mainStack1;
@property (weak, nonatomic) IBOutlet UIStackView *mainStack2;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic, strong) NSArray<C2CWatchWalletInfo*> *WalletItemsList;
@end

@implementation ViewWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataRequest];
    self.title = self.walletModel.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    [self setData];
    [self setAsDefaultWallet:self.walletModel.observeWalletId];
    [self.bgImg layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.bgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
}

-(void)setData{
    self.imgCardView.image = [UIImage imageNamed:[ChatViewHandleTool getImageByChannelCodeWatchWallet:self.walletModel.channelCode]];
    self.assetsLbl.text = @"Assets".icanlocalized;
    self.nameLbl.text = self.walletModel.name;
    NSString *extendAddress = self.walletModel.extendAddress;
    NSString *firstPart = [self seperateComma:extendAddress isFirst:YES];
    NSString *secondPart = [self seperateComma:extendAddress isFirst:NO];
    if([self.walletModel.channelCode isEqualToString:@"ican"]){
        if(firstPart != nil && ![firstPart isEqualToString: @""]){
            if ([firstPart hasPrefix:@"T"]) {
                self.currencyType1.text = @"TRC20";
            } else if ([firstPart hasPrefix:@"0x"]) {
                self.currencyType1.text = @"ERC20";
            }
            self.mainStack1.hidden = NO;
            self.addressLbl.text = firstPart;
        }else{
            self.mainStack1.hidden = YES;
        }
        if(secondPart != nil && ![secondPart  isEqualToString: @""]){
            if ([secondPart hasPrefix:@"T"]) {
                self.currencyType1.text = @"TRC20";
            } else if ([secondPart hasPrefix:@"0x"]) {
                self.currencyType2.text = @"ERC20";
            }
            self.mainStack2.hidden = NO;
            self.address1Lbl.text = secondPart;
        }else{
            self.mainStack2.hidden = YES;
        }
    }else{
        if ([self.walletModel.walletAddress hasPrefix:@"T"]) {
            self.currencyType2.text = @"TRC20";
        } else if ([self.walletModel.walletAddress hasPrefix:@"0x"]) {
            self.currencyType2.text = @"ERC20";
        }
        self.address1Lbl.text = self.walletModel.walletAddress;
        self.mainStack1.hidden = YES;
        self.mainStack2.hidden = NO;
    }
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton dzButtonWithTitle:nil image:@"Delete" backgroundColor:UIColor.clearColor titleFont:18 titleColor:UIColor153Color target:self action:@selector(deleteModel)];
    }
    return _rightBtn;
}

-(void)deleteModel{
    DeleteWalletFromListRequest *request = [DeleteWalletFromListRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/observe/%ld",self.walletModel.observeWalletId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CBaseResponse class] contentClass:[C2CBaseResponse class] success:^(id  _Nonnull response) {
        [QMUITipsTool showOnlyTextWithMessage:@"DeleteSuccess".icanlocalized inView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

-(void)getDataRequest{
    [QMUITips showLoadingInView:self.view];
    C2CGetWalletDetailsRequest *request = [C2CGetWalletDetailsRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/observe/%ld",(long)self.walletModel.observeWalletId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CWatchWalletInfo class] success:^(NSArray* response) {
        [QMUITips hideAllTips];
        self.WalletItemsList = response;
        [self.myTableView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

-(void)setAsDefaultWallet:(NSInteger)walletId{
    [QMUITips showLoadingInView:self.view];
    C2CAddWalletAsDefault *request = [C2CAddWalletAsDefault request];
    request.pathUrlString = [request.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/api/observe/default/%ld",(long)walletId]];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CAddAddressResponse class] contentClass:[C2CAddAddressResponse class] success:^(C2CAddAddressResponse* response) {
        [QMUITips hideAllTips];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

- (IBAction)copyBtn1Action:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *textToCopy = self.addressLbl.text;
    [pasteboard setString:textToCopy];
    if (pasteboard.string != nil) {
        [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
    } else {
        NSLog(@"Error copying address to clipboard.");
    }
}

- (IBAction)copyBtn2Action:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *textToCopy = self.address1Lbl.text;
    [pasteboard setString:textToCopy];
    if (pasteboard.string != nil) {
        [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
    } else {
        NSLog(@"Error copying address to clipboard.");
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.WalletItemsList.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AssetsDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetsDataCell"];
    C2CWatchWalletInfo *model = self.WalletItemsList[indexPath.row];
    if([self.walletModel.channelCode isEqualToString:@"ican"]){
        if(model != nil){
            [cell setAssetDataLogoManual:model];
        }
    }else{
        if(model != nil){
            [cell setAssetData:model];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSString *)seperateComma:(NSString *)data isFirst:(BOOL)isFirst{
    NSString *inputString = data;
    // Find the index of the target character
    NSUInteger targetIndex = [inputString rangeOfString:@","].location;
    if (targetIndex != NSNotFound) {
        // Get the characters before the target character
        NSString *charactersBefore = [inputString substringToIndex:targetIndex];
        NSLog(@"Characters before: %@", charactersBefore);
        // Get the characters after the target character
        NSString *charactersAfter = [inputString substringFromIndex:targetIndex + 1];
        NSLog(@"Characters after: %@", charactersAfter);
        if(isFirst == true){
            if(charactersBefore != nil && ![charactersBefore  isEqual: @""]){
                return charactersBefore;
            }else{
                return nil;
            }
        }else{
            if(charactersAfter != nil && ![charactersAfter  isEqual: @""]){
                return charactersAfter;
            }else{
                return nil;
            }
        }
    }else {
        return nil;
    }
}

@end
