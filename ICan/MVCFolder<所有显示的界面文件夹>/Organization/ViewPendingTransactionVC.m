//
//  ViewPendingTransactionVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ViewPendingTransactionVC.h"
#import "PayManager.h"
#import "SettingPaymentPasswordViewController.h"
#import "ConfirmPopUp.h"
#import "EmailBindingViewController.h"

@interface ViewPendingTransactionVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIStackView *btnStack;
@property (weak, nonatomic) IBOutlet UIStackView *addNoteStack;
@property (nonatomic,weak) UIViewController * showViewController;
@end

@implementation ViewPendingTransactionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.remarkText.delegate = self;
    UIColor *color = [UIColor grayColor];
    self.remarkText.placeholderColor = color;
    [self addLocalization];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    [self.bgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
}

- (void)hideKeyboard {
    [self.remarkText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)addLocalization{
    self.titleLbl.text = @"orgPendingTransaction".icanlocalized;
    self.fromTypeLbl.text = @"From".icanlocalized;
    self.amtTypeLbl.text = @"Amount".icanlocalized;
    self.toTypeLbl.text = @"To".icanlocalized;
    self.transTypeLbl.text = @"Type".icanlocalized;
    self.dateTypelbl.text = @"Date & Time".icanlocalized;
    self.noteTypeLbl.text = @"Add a note".icanlocalized;
    self.remarkText.placeholder = @"Add a note".icanlocalized;
    self.desctypeLbl.text = @"Please verify currency ,amount and counterparty. After approval, transactions cannot be recalled.".icanlocalized;
    [self.rejectBtn setTitle:@"Reject".icanlocalized forState:UIControlStateNormal];
    [self.approveBtn setTitle:@"Approve".icanlocalized forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSArray *userPermissionList = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPermissions"];
    BOOL APR_TRANSACTION_Level = [userPermissionList containsObject:@"APR_TRANSACTION"];
    if(APR_TRANSACTION_Level){
        self.btnStack.hidden = NO;
        self.addNoteStack.hidden = NO;
    }else{
        self.btnStack.hidden = YES;
        self.addNoteStack.hidden = YES;
    }
    [self setData];
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>100) {
        return;
    }
    if (textView == self.remarkText) {
        self.characterCountLabel.text = [NSString stringWithFormat:@"%lu/100",textView.text.length];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Calculate the new text after the replacement
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    // Check if the new text exceeds the character limit
    if (newText.length > 100) {
        // If it does, don't allow the change
        return NO;
    }
    // Allow the change
    return YES;
}


-(void)setData{
    [self.remarkText layerWithCornerRadius:5 borderWidth:0.5 borderColor:UIColor.grayColor];
    [self.approveBtn layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    [self.rejectBtn layerWithCornerRadius:5 borderWidth:1 borderColor:UIColor.clearColor];
    self.fromLbl.text = self.model.nickName;
    self.toLbl.text = self.model.to;
    self.typeLbl.text = [self getTransaferType:self.model.transactionType];
    self.dateLbl.text = [GetTime convertDateWithString:[NSString stringWithFormat:@"%zd",self.model.time] dateFormmate:@"dd/MM/yyyy HH:mm:ss"];
    NSString *originalString = [NSString stringWithFormat:@"%@ %@", [self getConvertedBalance:self.model.amount],self.model.unit];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:originalString];
    NSString *substring = [self getConvertedBalance:self.model.amount];
    NSRange boldRange = [originalString rangeOfString:substring];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:14.0]
                             range:boldRange];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor systemBlueColor]
                             range:boldRange];
    self.amtLbl.attributedText = attributedString;
}

- (IBAction)didRejectTransaction:(id)sender {
    ConfirmPopUp *vc = [[ConfirmPopUp alloc] init];
    vc.type = 1;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5]; // Adjust alpha as needed
    vc.noBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    vc.sureBlock = ^{
        [self rejectTransactionNetworkRequest:self.model];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)didApproveTransaction:(id)sender {
    [self acceptTransactionNetworkRequest:self.model];
}

-(NSString *)getConvertedBalance:(double)amt{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:8];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *formattedString = [numberFormatter stringFromNumber:@(amt)];
    return formattedString;
}

-(void)acceptTransactionNetworkRequest:(TransactionDataContentResponse *) model{
    if ([UserInfoManager sharedManager].tradePswdSet) {
        [[PayManager sharedManager]checkPaymentPasswordWithOther: @"Password".icanlocalized needSub: @"Enter the payment password".icanlocalized successBlock:^(NSString * _Nonnull password) {
            ApproveOrRejectTransaction *request = [ApproveOrRejectTransaction request];
            request.isApproved = TRUE;
            request.payPassword = password;
            request.transactionId = model.transactionId;
            if(![self.remarkText.text isEqualToString:@""] && self.remarkText.text != nil){
                request.remarks = self.remarkText.text;
            }
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response) {
                [QMUITips hideAllTips];
                [UserInfoManager sharedManager].attemptCount = nil;
                [UserInfoManager sharedManager].isPayBlocked = NO;
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                if ([info.code isEqual:@"pay.password.error"]) {
                    if (info.extra.isBlocked) {
                        [UserInfoManager sharedManager].isPayBlocked = YES;
                        [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                        [self acceptTransactionNetworkRequest:model];
                    } else if (info.extra.remainingCount != 0) {
                        [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                        [self acceptTransactionNetworkRequest:model];
                    } else {
                        [UserInfoManager sharedManager].attemptCount = nil;
                    }
                } else {
                    [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                }
            }];
        }];
    }else {
        [UIAlertController alertControllerWithTitle:@"Proceed to set up payment password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized,@"UIAlertController.cancel.title".icanlocalized] handler:^(int index) {
            if (index == 0) {
                if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                    EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                    if (self.showViewController) {
                        [self.showViewController.navigationController pushViewController:vc animated:YES];
                    }else{
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFromEmailBinding"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                    if (self.showViewController) {
                        [self.showViewController.navigationController pushViewController:vc animated:YES];
                    }else{
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }
            }
        }];
    }
}

-(void)rejectTransactionNetworkRequest:(TransactionDataContentResponse *) model{
    ApproveOrRejectTransaction *request = [ApproveOrRejectTransaction request];
    request.isApproved = FALSE;
    request.transactionId = model.transactionId;
    if(![self.remarkText.text isEqualToString:@""] && self.remarkText.text != nil){
        request.remarks = self.remarkText.text;
    }
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse *response) {
        [QMUITips hideAllTips];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

-(NSString *)getTransaferType:(NSString *)val{
    if([val isEqualToString:@"RED_PACKET"]){
        return @"chatView.function.redPacket".icanlocalized;
    }else if([val isEqualToString:@"TRANSFER"]){
        return @"Transfer".icanlocalized;
    }else if([val isEqualToString:@"WITHDRAWAL"]){
        return @"Withdrawal".icanlocalized;
    }else if([val isEqualToString:@"UTIL_PAY"]){
        return @"Utility payments".icanlocalized;
    }else if([val isEqualToString:@"C2C_TRANSFER"]){
        return @"Transfer".icanlocalized;
    }else if([val isEqualToString:@"C2C_WITHDRAWAL"]){
        return @"Withdrawal".icanlocalized;
    }else if([val isEqualToString:@"C2C_UTIL_PAY"]){
        return @"Utility payments".icanlocalized;
    }else if([val isEqualToString:@"P2P"]){
        return @"C2CTransaction".icanlocalized;
    }else{
        return @"";
    }
}
@end
