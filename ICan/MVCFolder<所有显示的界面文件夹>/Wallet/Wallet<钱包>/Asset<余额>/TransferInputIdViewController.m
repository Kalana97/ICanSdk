//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 28/9/2021
- File name:  TransferInputIdViewController.m
- Description:
- Function List:
*/
        

#import "TransferInputIdViewController.h"
#import "TranferAllFriendsViewController.h"
#import "TransferViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface TransferInputIdViewController ()<QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *itemBgView;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet QMUITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipsTwoLab;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, strong) UserMessageInfo *messageInfo;
@end

@implementation TransferInputIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    "ReciprocalAccount"="对方账户";
//    "icanaccount/mobilenumber"="ican账户/手机号码";
//    "Themoneywillbetransferred"="钱将实时转入账号，无法退款";
//    "userdoesnotexist"="该用户不存在";
    self.textField.placeholder = @"icanaccount/mobilenumber".icanlocalized;
    self.tipsTwoLab.text = @"Themoneywillbetransferred".icanlocalized;
    self.tipLab.text = @"ReciprocalAccount".icanlocalized;
    self.title = @"Transfer".icanlocalized;
    self.view.backgroundColor = UIColorBg243Color;
    self.tipLab.textColor = UIColorThemeMainTitleColor;
    self.textField.textColor = UIColorThemeMainTitleColor;
    self.tipsTwoLab.textColor = UIColorThemeMainSubTitleColor;
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.nextBtn setTitle:@"NextStep".icanlocalized forState:UIControlStateNormal];
    [self.nextBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    RAC(self.nextBtn,enabled)=[RACSignal combineLatest:@[
        self.textField.rac_textSignal]reduce:^(NSString *oringPassword) {
        return @(oringPassword.length>0);
    }];
    [RACObserve(self, self.nextBtn.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.nextBtn.backgroundColor=UIColorThemeMainColor;
        }else{
            self.nextBtn.backgroundColor=UIColorMakeWithRGBA(29, 129, 245, 0.5);
        }
    }];
}
- (IBAction)selectFriendBtn:(id)sender {
    TranferAllFriendsViewController *vc = [[TranferAllFriendsViewController alloc]init];
    vc.selectBlock = ^(UserMessageInfo * _Nonnull info) {
        self.messageInfo = info;
        self.textField.text = info.numberId;
        [self nextAction];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)nextAction {
    /**
     1. 根据ID或者手机号码请求数据 获取用户详情
     */
    if ([UserInfoManager.sharedManager.numberId isEqualToString:self.textField.text]) {
        [QMUITipsTool showOnlyTextWithMessage:@"CannotTransferMyself".icanlocalized inView:self.view];
    }else{
        SearchUserRequest * request = [SearchUserRequest request];
        request.username = self.textField.text;
        request.parameters = [request mj_JSONObject];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray* response) {
            if (response.count>0) {
                TransferViewController * vc =[TransferViewController new];
                vc.tranferType = TranfetFrom_wallet;
                vc.currencyBalanceListInfo = self.currencyBalanceListInfo;
                vc.userMessageInfo = response.firstObject;
                vc.isCNY = self.isCNY;
                vc.authorityType = AuthorityType_friend;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [QMUITipsTool showOnlyTextWithMessage:@"userdoesnotexist".icanlocalized inView:self.view];
            }
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
    
   
    
}


@end
