//
//  WatchList.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "WatchList.h"
#import "WatchWalletCell.h"
#import "ViewWatchWalletDetails.h"
#import "AddWatchWallet.h"

@interface WatchList ()
@property(nonatomic, strong) NSArray<WatchWalletListInfo*> *WalletItemsList;
@property(nonatomic,strong)UIButton * rightBtn;
@end

@implementation WatchList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.titleView.title = @"Watch Only Wallets".icanlocalized;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    [self getWalletList];
}

-(void)goAddVc{
    UIStoryboard *board;
    board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    AddWatchWallet *View = [board instantiateViewControllerWithIdentifier:@"AddWatchWallet"];
    View.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:View animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void)viewWalletInfo:(WatchWalletListInfo *)walletInfo{
    if(self.viewPageBlock){
        self.viewPageBlock(walletInfo);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getWalletList{
    [QMUITips showLoadingInView:self.view];
    GetWatchWalletListRequest *request = [GetWatchWalletListRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[WatchWalletListInfo class] success:^(NSArray<WatchWalletListInfo*>* response) {
        [QMUITips hideAllTips];
        self.WalletItemsList = response;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kWalletWatchCell];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.WalletItemsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *extendAddress = self.WalletItemsList[indexPath.row].extendAddress;
    if ([extendAddress containsString:@","]) {
        return 230;
    }else{
        return 150;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WatchWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:kWalletWatchCell];
    WatchWalletListInfo *model = self.WalletItemsList[indexPath.row];
    if ([model.extendAddress containsString:@","]) {
        model.extendAddress1 = [self seperateComma:model.extendAddress isFirst:YES];
        model.extendAddress2 = [self seperateComma:model.extendAddress isFirst:NO];
        [cell setWatchWalletData:model];
    }else{
        model.extendAddress1 = model.extendAddress;
        [cell setWatchWalletData:model];
    }
    cell.viewPageBlock = ^(WatchWalletListInfo * _Nonnull modelData) {
        [self viewWalletInfo:modelData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton dzButtonWithTitle:nil image:@"Add new" backgroundColor:UIColor.clearColor titleFont:18 titleColor:UIColor153Color target:self action:@selector(goAddVc)];
    }
    return _rightBtn;
}

-(NSArray<WatchWalletListInfo *> *)WalletItemsList{
    if (!_WalletItemsList) {
        _WalletItemsList = [NSArray array];
    }
    return _WalletItemsList;
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
