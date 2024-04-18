//
//  TranferViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/8.
//  Copyright © 2019 dzl. All rights reserved.
//
#import "TransferViewController.h"
#import "ChatUtil.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatModel.h"
#import "PayManager.h"
#import "IcanWalletTransferSuccessViewController.h"
#import "DZUITextField.h"
#import "DecimalKeyboard.h"
#import <QuartzCore/QuartzCore.h>

@interface TransferViewController ()<QMUITextViewDelegate,DZUITextFieldDelegate>
@property(nonatomic, strong) UserBalanceInfo *banlanceInfo;
@property(nonatomic, strong) PayManager *payManager;
@property (weak, nonatomic) IBOutlet UIView *avatarBgView;
@property (weak, nonatomic) IBOutlet UILabel *yourBalance;
@property(nonatomic, copy)   NSString *amount;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferAmtLbl;
@property (weak, nonatomic) IBOutlet DZUITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *balanceTotLbl;
@property (weak, nonatomic) IBOutlet UILabel *addANoteLbl;
@property (weak, nonatomic) IBOutlet UILabel *idLbl;
@property (weak, nonatomic) IBOutlet DZUITextField *currencySymbolLbl;
@property (weak, nonatomic) IBOutlet UILabel *realNameLbl;
@property (nonatomic,assign) BOOL isHaveDian;
@property(nonatomic, strong) UserBalanceInfo *balanceInfo;
@property(nonatomic, strong) NSArray<C2CBalanceListInfo*> *currencyBalanceListItems;
@property(nonatomic, strong) C2CBalanceListInfo *currentBalanceInfo;
@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isUsdTransfer == YES){
        [self fetchWallet];
        self.moneyTextField.floatLenth = 8;
        self.currencySymbolLbl.text = @"₮";
    }else{
        [self fetchBalance];
        self.moneyTextField.floatLenth = 2;
        self.currencySymbolLbl.text = @"￥";
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.iconImgView.bounds byRoundingCorners:( UIRectEdgeAll) cornerRadii:CGSizeMake(100, 100)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path  = maskPath.CGPath;
    self.iconImgView.layer.mask = maskLayer;
    self.avatarBgView.layer.cornerRadius = self.avatarBgView.frame.size.height/2;
    self.avatarBgView.clipsToBounds = YES;
    self.title = NSLocalizedString(@"Transfer",转账);
    self.view.backgroundColor = UIColorBg243Color;
    if (self.tranferType==TranfetFrom_chatView) {
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"UIAlertController.cancel.title".icanlocalized target:self action:@selector(cancel)];
    }
    self.payManager=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        self.balanceInfo = balance;
    }];
    [self.iconImgView setDZIconImageViewWithUrl:self.userMessageInfo.headImgUrl gender:self.userMessageInfo.gender];
    self.idLbl.text = [NSString stringWithFormat:@"iCan ID :%@",self.userMessageInfo.numberId];
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.textView.delegate=self;
    self.moneyTextField.delegate=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledDidChange:) name:UITextFieldTextDidChangeNotification object:self.moneyTextField];
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.moneyTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.moneyTextField.inputView = decimalKeyboard;
    self.yourBalance.text = @"AvailableBalance".icanlocalized;
    self.transferAmtLbl.text = @"TransferAmount".icanlocalized;
    self.addANoteLbl.text = @"AddNote.chat.function".icanlocalized;
    self.textView.placeholder = @"AddNote".icanlocalized;
    [self.sureButton setTitle:@"Transfer".icanlocalized forState:UIControlStateNormal];
    [self getUserInfo];
}

-(void)getUserInfo{
    GetUserMessageRequest*request = [GetUserMessageRequest request];
    request.userId = self.userMessageInfo.userId;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        NSString *firstName = response.firstName;
        if(firstName != nil && ![firstName  isEqual: @""]){
            for (int i = firstName.length / 2; i < firstName.length ; i++) {
                if (![[firstName substringWithRange:NSMakeRange(i, 1)] isEqual:@" "]) {
                    NSRange range = NSMakeRange(i, 1);
                    firstName = [firstName stringByReplacingCharactersInRange:range withString:@"*"];
                }
            }
            self.nameLabel.text = [NSString stringWithFormat:@"%@",self.userMessageInfo.nickname];
            self.realNameLbl.text = [NSString stringWithFormat:@"(%@)",firstName];
        }else{
            self.nameLabel.text = [NSString stringWithFormat:@"%@",self.userMessageInfo.nickname];
            self.realNameLbl.hidden = YES;
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        NSLog(@"Error");
    }];
}

- (void)fetchBalance {
    UserBalanceRequest*request=[UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
        self.balanceInfo = response;
        self.balanceTotLbl.text = [NSString stringWithFormat:@"￥ %@",[response.balance calculateByNSRoundDownScale:2].currencyString];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}

-(void)fetchWallet{
    __block BOOL isExist = NO;
    [C2CUserManager.shared getC2CBalanceRequest:^(NSArray * _Nonnull response) {
        self.currencyBalanceListItems = response;
        for (C2CBalanceListInfo*info in C2CUserManager.shared.c2cBalanceListItems) {
            if ([info.code isEqualToString:@"USDT"]) {
                isExist = YES;
                self.currentBalanceInfo = info;
                self.balanceTotLbl.text = [NSString stringWithFormat:@"₮ %@",[self.currentBalanceInfo.money calculateByNSRoundDownScale:8].currencyString];
                break;
            }
        }
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        self.balanceTotLbl.text = [NSString stringWithFormat:@"₮ %@",@"0.00"];
    }];
    if (isExist == NO) {
        self.balanceTotLbl.text = [NSString stringWithFormat:@"₮ %@",@"0.00"];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)textFiledDidChange:(NSNotification*)noti{
    if (self.moneyTextField.text.length>0&&!self.moneyTextField.markedTextRange) {//如果输入的是小数点 那么变成0.
        NSString*fitst=[self.moneyTextField.text substringWithRange:NSMakeRange(0, 1)];
        if ([fitst isEqualToString:@"."]) {
            self.moneyTextField.text=@"0.";
        }
    }
}
- (IBAction)sureButtonAction:(id)sender {
    [self sureTranferAction];
}

-(void)cancel{
    self.backAction();
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)sureTranferAction{
    self.amount = self.moneyTextField.text;
    if ([[NSDecimalNumber decimalNumberWithString:self.amount]compare:[NSDecimalNumber decimalNumberWithString:@"0.00"]] == NSOrderedDescending) {
        if (self.balanceInfo) {
            [self showSurePayView];
        }else{
            [UserInfoManager.sharedManager fetchUserBalanceRequest:^(UserBalanceInfo * _Nonnull balance) {
                self.balanceInfo = balance;
                [self showSurePayView];
            }];
        }
    }
    
}
-(void)showSurePayView{
    NSDecimalNumber * total = [NSDecimalNumber decimalNumberWithString:self.amount];
    if (self.isUsdTransfer == YES){
        if ([total compare:self.currentBalanceInfo.money] == NSOrderedAscending || total.doubleValue == self.currentBalanceInfo.money.doubleValue) {
            if (BaseSettingManager.isChinaLanguages) {
                if (self.isUsdTransfer == YES){
                    NSString * totalBal = [NSString stringWithFormat:@"%@",[self.currentBalanceInfo.money calculateByNSRoundDownScale:8].currencyString];
                    [self.payManager showWalletTransfer:totalBal amount:self.amount isCalled:YES successBlock:^(NSString * _Nonnull password) {
                        if(self.isUsdTransfer == YES){
                            [self transferUsdtRequest:password];
                        }else{
                            [self transferRequest:password];
                        }
                    }];
                }else{
                    [self.payManager showPayViewWithAmount:self.amount typeTitleStr:[NSString stringWithFormat:@"向（%@）转账",self.userMessageInfo.remarkName?:self.userMessageInfo.nickname] SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
                        if(self.isUsdTransfer == YES){
                            [self transferUsdtRequest:password];
                        }else{
                            [self transferRequest:password];
                        }
                    }];
                }
                
            }else{
                if (self.isUsdTransfer == YES){
                    NSString * totalBal = [NSString stringWithFormat:@"%@",[self.currentBalanceInfo.money calculateByNSRoundDownScale:8].currencyString];
                    [self.payManager showWalletTransfer:totalBal amount:self.amount isCalled:YES successBlock:^(NSString * _Nonnull password) {
                        if(self.isUsdTransfer == YES){
                            [self transferUsdtRequest:password];
                        }else{
                            [self transferRequest:password];
                        }
                    }];
                }else{
                    [self.payManager showPayViewWithAmount:self.amount typeTitleStr:[NSString stringWithFormat:@"Transfer to（%@）",self.userMessageInfo.remarkName?:self.userMessageInfo.nickname] SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
                        if(self.isUsdTransfer == YES){
                            [self transferUsdtRequest:password];
                        }else{
                            [self transferRequest:password];
                        }
                    }];
                }
            }
        }else{
            [QMUITipsTool showOnlyTextWithMessage:@"Insufficient Balance".icanlocalized inView:self.view];
        }
    }else{
        if ([total compare:self.balanceInfo.balance] == NSOrderedSame || [total compare:self.balanceInfo.balance] == NSOrderedAscending) {
            if (BaseSettingManager.isChinaLanguages) {
                [self.payManager showPayViewWithAmount:self.amount typeTitleStr:[NSString stringWithFormat:@"向（%@）转账",self.userMessageInfo.remarkName?:self.userMessageInfo.nickname] SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
                    if(self.isUsdTransfer == YES){
                        [self transferUsdtRequest:password];
                    }else{
                        [self transferRequest:password];
                    }
                }];
            }else{
                [self.payManager showPayViewWithAmount:self.amount typeTitleStr:[NSString stringWithFormat:@"Transfer to（%@）",self.userMessageInfo.remarkName?:self.userMessageInfo.nickname] SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
                    if(self.isUsdTransfer == YES){
                        [self transferUsdtRequest:password];
                    }else{
                        [self transferRequest:password];
                    }
                }];
            }
        }else{
            [QMUITipsTool showOnlyTextWithMessage:@"Insufficient Balance".icanlocalized inView:self.view];
        }
    }
}

-(void)transferRequest:(NSString*)password{
    TransferRequest * request = [TransferRequest request];
    NSInteger to = [self.userMessageInfo.userId integerValue];
    request.to = @(to);
    request.money= @([self.amount doubleValue]);
    if (self.currencyBalanceListInfo) {
        request.currencyCode = self.currencyBalanceListInfo.code;
    }else{
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            request.currencyCode = @"CNY";
        }
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            request.currencyCode = @"CNT";
        }
    }
    if ([self.textView.text isEqualToString:@""]) {
        request.reason = @"chatView.function.transfer".icanlocalized;
    }else{
        request.reason = self.textView.text;
    }
    request.password=password;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class ] contentClass:[NSString class] success:^(NSString* response) {
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
               NSError *error;
               NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
               NSNumber *statusValue = jsonDictionary[@"status"];
               NSInteger intValue = [statusValue integerValue];
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        if(intValue == 3 || intValue == 2){
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Successfultransfer", 转账成功) inView:self.view];
            if (self.tranferType==TranfetFrom_wallet) {
                [self sendTranferMsgWithMoney:self.moneyTextField.text reason:request.reason messageId:response];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        if ([info.code isEqual:@"pay.password.error"]) {
            if (info.extra.isBlocked) {
                [UserInfoManager sharedManager].isPayBlocked = YES;
                [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                [self showSurePayView];
            } else if (info.extra.remainingCount != 0) {
                [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                [self showSurePayView];
            } else {
                [UserInfoManager sharedManager].attemptCount = nil;
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
            }
        } else {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }
    }];
}

-(void)transferUsdtRequest:(NSString*)password{
    C2CTransferRequest * request = [C2CTransferRequest request];
    NSDecimalNumber *amountVal = [NSDecimalNumber decimalNumberWithString:self.amount];
    request.amount = amountVal;
    request.currencyCode = @"USDT";
    request.payPassword = password;
    request.operationSource = @"2";
    request.toUserId = self.userMessageInfo.userId;
    if ([self.textView.text isEqualToString:@""]) {
        request.remark = @"chatView.function.transfer".icanlocalized;
    }else{
        request.remark = self.textView.text;
    }
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSNumber *statusValue = jsonDictionary[@"status"];
        NSInteger intValue = [statusValue integerValue];
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        if(intValue == 3 || intValue == 2){
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Successfultransfer", 转账成功) inView:self.view];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        if (info.extra.isBlocked) {
            [UserInfoManager sharedManager].isPayBlocked = YES;
            [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
            [self showSurePayView];
        } else if (info.extra.remainingCount != 0) {
            [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
            [self showSurePayView];
        } else {
            [UserInfoManager sharedManager].attemptCount = nil;
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }
    }];
}

-(void)sendAndSaveMessageWithChatModel:(ChatModel*)chatModel{
}

#pragma mark 本地缓存转账消息
-(void)sendTranferMsgWithMoney:(NSString *)money reason:(NSString *)reason messageId:(NSString*)messageId{
    ChatModel * config = [[ChatModel alloc]init];
    config.chatID = self.userMessageInfo.userId;
    config.authorityType = self.authorityType;
    config.chatType = UserChat;
    ChatModel *model =[ChatUtil creatTransferMessageInfoWithChatModel:config];
    TranferMessageInfo * tranferMessageInfo = [[TranferMessageInfo alloc]init];
    tranferMessageInfo.money = money;
    tranferMessageInfo.content= reason.length>0?reason:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Transferto", 转账给),self.userMessageInfo.remarkName?:self.userMessageInfo.nickname];
    model.messageContent = [tranferMessageInfo mj_JSONString];
    model.showMessage=reason;
    model.authorityType=self.authorityType;
    model.sendState=1;
    [self.navigationController popToRootViewControllerAnimated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:KTransferSucessNotification object:nil userInfo:@{@"chatModel":model}];
        
    });
}

@synthesize floatLenth;

@end
