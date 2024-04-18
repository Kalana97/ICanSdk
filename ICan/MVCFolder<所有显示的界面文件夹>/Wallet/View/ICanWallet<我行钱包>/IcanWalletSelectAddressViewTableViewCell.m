//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 14/1/2022
 - File name:  IcanWalletSelectAddressViewTableViewCell.m
 - Description:
 - Function List:
 */


#import "IcanWalletSelectAddressViewTableViewCell.h"
@interface IcanWalletSelectAddressViewTableViewCell()
@property (weak, nonatomic) IBOutlet UIControl *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIControl *bgView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *btnTitleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContrainst;
@property(nonatomic, strong) ExternalWalletsInfo *walletsInfo;
@end

@implementation IcanWalletSelectAddressViewTableViewCell
- (IBAction)tap {
    !self.didSelectBlock?:self.didSelectBlock();
}

-(void)setMainNetworkInfo:(ICanWalletMainNetworkInfo *)mainNetworkInfo{
    _mainNetworkInfo = mainNetworkInfo;
        self.titleLabel.text = mainNetworkInfo.channelName;
        self.deleteBtn.hidden = YES;
        self.rightContrainst.constant = 0;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channelCode contains [cd] %@ ",self.mainNetworkInfo.channelCode];
        self.walletsInfo = [C2CUserManager.shared.userInfo.externalWallets filteredArrayUsingPredicate:predicate].firstObject;
        if(self.walletsInfo.walletAddress == nil && self.walletsInfo.externalWalletId == 0) {
            self.addBtn.hidden = NO;
            self.mainView.hidden = YES;
        }else {
            self.addBtn.hidden = YES;
        }
        if ([mainNetworkInfo.channelCode isEqual:@"TRC20"]){
            self.btnTitleLab.text = @"Create TRC20 Wallet".icanlocalized;
            self.imgView.image = [UIImage imageNamed:@"trc20_icon"];
        }else {
            self.btnTitleLab.text = @"Create ERC20 Wallet".icanlocalized;
            self.imgView.image = [UIImage imageNamed:@"erc20_icon"];
        }
        if ([self.typeDirected  isEqual: @"ShouldColor"]){
            if (self.mainNetworkInfo.isSelected == YES){
                [self.bgView.layer setCornerRadius:8.0f];
                self.bgView.layer.borderColor = [UIColor systemBlueColor].CGColor;
                self.bgView.layer.borderWidth = 1.0f;
                [self.bgView.layer setMasksToBounds:YES];
            }else{
                [self.bgView.layer setCornerRadius:8.0f];
                self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
                self.bgView.layer.borderWidth = 1.0f;
                [self.bgView.layer setMasksToBounds:YES];
            }
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGesture.numberOfTapsRequired = 1;

        [self.addBtn addGestureRecognizer:tapGesture];
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"View tapped");
    C2CCreateNewWalletRequest * request = [C2CCreateNewWalletRequest request];
    request.channelCode = self.mainNetworkInfo.channelCode;
    request.numberId = [UserInfoManager sharedManager].numberId;
    request.parameters = [request mj_JSONObject];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  _Nonnull response) {
        !self.didSelectBlock?:self.didSelectBlock();
        self.addBtn.hidden = YES;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
    
}
- (IBAction)addWalletAction:(id)sender {
    !self.didSelectBlock?:self.didSelectBlock();
}
-(void)setWalletAddressInfo:(ExternalWalletsInfo *)walletAddressInfo{
    _walletAddressInfo = walletAddressInfo;
    self.titleLabel.text = walletAddressInfo.walletAddress;
}
-(void)setAddressInfo:(ICanWalletAddressInfo *)addressInfo{
    _addressInfo = addressInfo;
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",addressInfo.tag,addressInfo.address.encryptBankCardNum];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.bgView addGestureRecognizer:tap];
}
- (IBAction)deleteAction:(id)sender {
    !self.deleteBlock?:self.deleteBlock();
}

@end
