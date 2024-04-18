//
//  NewWalletViewController.m
//  ICan
//
//  Created by Kalana Rathnayaka on 01/03/2024.
//  Copyright © 2024 dzl. All rights reserved.
//

#import "NewWalletViewController.h"

@interface NewWalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *trc20Lab;
@property (weak, nonatomic) IBOutlet UILabel *erc20Lab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@end

@implementation NewWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"Create New Wallet".icanlocalized;
    self.descLab.text = @"Fast, secure, and easy-to-use wallet to manage your cryptocurrency assets.".icanlocalized;
    self.trc20Lab.text = @"Create TRC20 Wallet".icanlocalized;
    self.erc20Lab.text = @"Create ERC20 Wallet".icanlocalized;
}

- (IBAction)trc20Action:(id)sender {
    C2CCreateNewWalletRequest *request = [C2CCreateNewWalletRequest request];
    request.channelCode = @"TRC20";
    request.numberId = [UserInfoManager sharedManager].numberId;
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  _Nonnull response) {
        self.titleLab.text = @"Creating Your Secure Wallet...".icanlocalized;
        self.coverImg.image = [UIImage imageNamed:@"creating_wallet_icon"];
        self.descLab.text = @"Please wait while we set up your wallet. This ensures the security of your funds and protects your assets.".icanlocalized;
        self.trcBtn.hidden = YES;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}

- (IBAction)erc20Action:(id)sender {
    C2CCreateNewWalletRequest *request = [C2CCreateNewWalletRequest request];
    request.channelCode = @"ERC20";
    request.numberId = [UserInfoManager sharedManager].numberId;
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  _Nonnull response) {
        self.titleLab.text = @"Creating Your Secure Wallet...".icanlocalized;
        self.coverImg.image = [UIImage imageNamed:@"creating_wallet_icon"];
        self.descLab.text = @"Please wait while we set up your wallet. This ensures the security of your funds and protects your assets.".icanlocalized;
        self.ercBtn.hidden = YES;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0, StatusBarHeight+78, ScreenWidth, ScreenHeight-78-StatusBarHeight);
}

@end
