//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 22/4/2021
 - File name:  UtilityPaymentsPayViewController.m
 - Description:
 - Function List:
 */


#import "UtilityPaymentsPayViewController.h"
#import "UtilityPaymentsSuccessViewController.h"
#import "UtilityPaymentsFailViewController.h"
#import "SelectPayWayViewController.h"
#import "DecimalKeyboard.h"
#import "Select43PayWayViewController.h"
@interface UtilityPaymentsPayViewController ()<QMUITextFieldDelegate>
//顶部图标
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
//顶部类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileNumberLab;
@property (weak, nonatomic) IBOutlet QMUITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet QMUITextField *amountTextField;

@property (weak, nonatomic) IBOutlet UIView *noticeBgView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;
@property (weak, nonatomic) IBOutlet QMUITextField *noticeTextField;

@property (weak, nonatomic) IBOutlet UILabel *descriLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *descriTextField;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *currencyCodeLbl;
@property(nonatomic, strong) ExchangeByAmountInfo *currentExchangeByAmountInfo;
@property(nonatomic, strong) NSString *paymentId;
/**
 充值金额
 */
@property(nonatomic, copy) NSString *amount;
@end

@implementation UtilityPaymentsPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.dialogInfo.accountNumber) {
        self.mobileTextField.text=self.dialogInfo.accountNumber;
    }
    self.countryCodeLabel.hidden = YES;
    [self.typeImageView setImageWithString:self.dialogInfo.logo placeholder:nil];
    [self.typeImageView layerWithCornerRadius:40 borderWidth:1 borderColor:UIColorBg243Color];
    self.typeLabel.text=self.dialogInfo.name;
    [self.sureButton setTitle:@"Confirm".icanlocalized forState:UIControlStateNormal];
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.amountTextField.placeholder=@"PleaseEnterAmount".icanlocalized;
    self.descriTextField.placeholder=@"Pleaseenterremarks".icanlocalized;
    self.amountTextField.delegate=self;
    self.mobileTextField.delegate=self;
    self.noticeTextField.delegate=self;
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.amountTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField.inputView = decimalKeyboard;
    if (!self.dialogInfo.showNoticeAccount) {
        self.countryCodeLabel.hidden = NO;
        self.countryCodeLabel.text = [NSString stringWithFormat:@"%@%@", @"+", self.countryCode];
        if(self.isFromFavorite) {
            self.countryCodeLabel.hidden = YES;
        }
        self.noticeBgView.hidden=YES;
        self.mobileTextField.placeholder=@"Please enter the mobile number to recharge".icanlocalized;
        //        self.mobileTextField.placeholder=@"Please enter the mobile number to recharge";
        self.noticeTextField.placeholder=@"PleaseEnterAmount".icanlocalized;
        self.mobileNumberLab.text=@"MobileNumber".icanlocalized;
    }else{
        self.mobileNumberLab.text=@"AccountNumber".icanlocalized;
        self.mobileTextField.placeholder=@"Please enter the account number".icanlocalized;
        self.noticeTextField.placeholder=@"Please enter number for SMS notification".icanlocalized;
        self.noticeLab.text=@"MobileNumber".icanlocalized;
    }
    self.descriLabel.text=@"Description".icanlocalized;
    self.amountLab.text = @"Amount".icanlocalized;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getC2cBalanceUSDT];
    [self fetchUserBalance];
    self.currencyCodeLbl.text = self.currencyCodeVal;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.amountTextField) {
        /*
         * 不能输入.0-9以外的字符。
         * 设置输入框输入的内容格式
         * 只能有一个小数点
         * 小数点后最多能输入两位
         * 如果第一位是.则前面加上0.
         * 如果第一位是0则后面必须输入点，否则不能输入。
         */
        
        BOOL isHaveDian=YES;
        if ([textField.text containsString:@"."]) {
            isHaveDian = YES;
        }else{
            isHaveDian = NO;
        }
        
        if (string.length > 0) {
            
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            //        BXLog(@"single = %c",single);
            
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.')){
                
                return NO;
            }
            
            // 只能有一个小数点
            if (isHaveDian && single == '.') {
                return NO;
            }
            
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        return NO;
                    }
                }
            }
            
            // 小数点后最多能输入两位
            if (isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 1) {
                        return NO;
                    }
                }
            }
            
        }
        
        return YES;
    }else if (textField==self.mobileTextField||textField==self.noticeTextField){
        if (string.length>0) {
            unichar single = [string characterAtIndex:0];
            // 不能输入.0-9以外的字符
            if (!(single >= '0' && single <= '9')){
                return NO;
            }
        }
        
        return YES;
    }
    return YES;
    
    
    
}

-(BOOL)preferredNavigationBarHidden{
    return YES;
}

- (IBAction)backAction:(UIControl *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showAlertWithMessage:(NSString*)message{
    [UIAlertController alertControllerWithTitle:nil message:message target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        
    }];
}
//确认
- (IBAction)sureButtonAction:(id)sender {
    NSString*mobileText=self.mobileTextField.text;
    if ([self.dialogInfo.domain isEqualToString:@"ATEL"]) {
        if ([mobileText hasPrefix:@"075"]) {
            if (mobileText.length!=10) {
                [self showAlertWithMessage:@"Airtel number It can only start with 075/75 and the length is 10 or 9 digits".icanlocalized];
                return;
            }
        }else{
            if ([mobileText hasPrefix:@"75"]) {
                if (mobileText.length!=9) {
                    [self showAlertWithMessage:@"Airtel number It can only start with 075/75 and the length is 10 or 9 digits".icanlocalized];
                    return;
                }
            }else{
                [self showAlertWithMessage:@"Airtel number It can only start with 075/75 and the length is 10 or 9 digits".icanlocalized];
                
                return;
            }
        }
        
    }else if ([self.dialogInfo.domain isEqualToString:@"GSM"]) {
        if ([mobileText hasPrefix:@"076"]||[mobileText hasPrefix:@"074"]||[mobileText hasPrefix:@"077"]) {
            if (mobileText.length!=10) {
                [self showAlertWithMessage:@"Mobile number It can only start with 076/077/074 or 76/77/74, and the length is 10 or 9 digits".icanlocalized];
                
                return;
            }
        }else{
            if ([mobileText hasPrefix:@"76"]||[mobileText hasPrefix:@"74"]||[mobileText hasPrefix:@"77"]) {
                if (mobileText.length!=9) {
                    [self showAlertWithMessage:@"Mobile number It can only start with 076/077/074 or 76/77/74, and the length is 10 or 9 digits".icanlocalized];
                    return;
                }
            }else{
                [self showAlertWithMessage:@"Mobile number It can only start with 076/077/074 or 76/77/74, and the length is 10 or 9 digits".icanlocalized];
                return;
            }
        }
        
    }else if ([self.dialogInfo.domain isEqualToString:@"CDMA"]||[self.dialogInfo.domain isEqualToString:@"LECO"]||[self.dialogInfo.domain isEqualToString:@"CEB"]) {
        if (![NSString checkIsPureString:mobileText]) {
            [self showAlertWithMessage:@"Account number Only 10 digits in length".icanlocalized];
            return;
        }else{
            if (mobileText.length!=10) {
                [self showAlertWithMessage:@"Account number Only 10 digits in length".icanlocalized];
                return;
            }
        }
        
    }else if ([self.dialogInfo.domain isEqualToString:@"DTV"]) {
        if (![NSString checkIsPureString:mobileText]) {
            [self showAlertWithMessage:@"Account number Only 8 digits in length".icanlocalized];
            return;
        }else{
            if (mobileText.length!=8) {
                [self showAlertWithMessage:@"Account number Only 8 digits in length".icanlocalized];
                
                return;
            }
        }
    }else if ([self.dialogInfo.domain isEqualToString:@"HUTCH"]){
        //        HUTCH 号码验证规则   "号码校验长度 10/9   只能以078或78 072/078开头"
        if ([mobileText hasPrefix:@"078"]||[mobileText hasPrefix:@"072"]) {
            if (mobileText.length!=10) {
                [self showAlertWithMessage:@"Mobile number It can only start with 072/078 or 72/78, and the length is 10 or 9 digits".icanlocalized];
                return;
            }
        }else{
            if ([mobileText hasPrefix:@"78"]||[mobileText hasPrefix:@"72"]) {
                if (mobileText.length!=9) {
                    [self showAlertWithMessage:@"Mobile number It can only start with 072/078 or 72/78, and the length is 10 or 9 digits".icanlocalized];
                    return;
                }
            }else{
                [self showAlertWithMessage:@"Mobile number It can only start with 072/078 or 72/78, and the length is 10 or 9 digits".icanlocalized];
                
                return;
            }
        }
    }else if ([self.dialogInfo.domain isEqualToString:@"ETI"]){
        //        HUTCH 号码验证规则   "号码校验长度 10/9   只能以072/078或72/78 开头"
        if ([mobileText hasPrefix:@"072"]) {
            if (mobileText.length!=10) {
                [self showAlertWithMessage:@"Mobile number It can only start with 072/078 or 72/78, and the length is 10 or 9 digits".icanlocalized];
                return;
            }
        }else{
            if ([mobileText hasPrefix:@"72"]) {
                if (mobileText.length!=9) {
                    [self showAlertWithMessage:@"Mobile number It can only start with 072/078 or 72/78, and the length is 10 or 9 digits".icanlocalized];
                    return;
                }
            }else{
                [self showAlertWithMessage:@"Mobile number It can only start with 072/078 or 72/78, and the length is 10 or 9 digits".icanlocalized];
                
                return;
            }
        }
    }
    //767924910
    float amount=self.amountTextField.text.doubleValue;
    self.amount=self.amountTextField.text;
    if (amount<=0) {
        [self showAlertWithMessage:@"Amount cannot be 0".icanlocalized ];
        return;
    }
    if (amount<30.00) {
        [self showAlertWithMessage:@"Minimum payment amount 30 LKR".icanlocalized];
        return;
    }
    NSString*notiteText=self.noticeTextField.text;
    if (self.dialogInfo.showNoticeAccount) {
        if (notiteText.length<=0) {
            [self showAlertWithMessage:@"Please enter number for SMS notification".icanlocalized];
            return;
        }
        if ([notiteText hasPrefix:@"076"]||[notiteText hasPrefix:@"074"]||[notiteText hasPrefix:@"077"]||[notiteText hasPrefix:@"075"]||[notiteText hasPrefix:@"072"]||[notiteText hasPrefix:@"078"]) {
            if (notiteText.length!=10) {
                [self showAlertWithMessage:@"Mobile number It can only start with 078/072/076/077/074/075 or 78/72/76/77/74/75, and the length is 10 or 9 digits".icanlocalized];
                
                return;
            }
        }else{
            if ([notiteText hasPrefix:@"76"]||[notiteText hasPrefix:@"74"]||[notiteText hasPrefix:@"77"]||[notiteText hasPrefix:@"75"]||[notiteText hasPrefix:@"72"]||[notiteText hasPrefix:@"78"]) {
                if (notiteText.length!=9) {
                    [self showAlertWithMessage:@"Mobile number It can only start with 078/072/076/077/074/075 or 78/72/76/77/74/75, and the length is 10 or 9 digits".icanlocalized];
                    return;
                }
            }else{
                [self showAlertWithMessage:@"Mobile number It can only start with 078/072/076/077/074/075 or 78/72/76/77/74/75, and the length is 10 or 9 digits".icanlocalized];
                return;
            }
        }
    }
    //    Airtel   号码校验长度 10/9   前面三位/两位  只能以075/75开头 domain  ATEL
    //    Dialog Mobile   号码校验长度 10/9   前面三位/两位  只能以076/077/074或76/77/74 开头  domain = GSM
    //    Dialog CDMA 校验10位 domain = CDMA
    //    Dialog Fixed Solutions 校验10位  domain = CDMA
    // Dialog TV 校验8位 domain = DTV;
    //CEB 校验10位
    //LECO 校验10位
    //NWSDB
    // Dialog Mobile    Dialog CDMA        Dialog TV Dialog Fixed Solutions 需要校验号码
    /*
     Telecom  ATEL  1  https://oss.shinianwangluo.com/system/dialog_logo/1.png  Airtel  号码必修长度校验 10  前三只能输入075  TX_ATOB
     Telecom  CDMA  1  https://oss.shinianwangluo.com/system/dialog_logo/4.png  Dialog CDMA  号码长度校验 10  没有  TX_ATOB
     Telecom  CDMA  1  https://oss.shinianwangluo.com/system/dialog_logo/2.png  Dialog Fixed Solutions  Dialog宽带 号码必修长度校验 10  没有  TX_ATOB
     Telecom  GSM  1  https://oss.shinianwangluo.com/system/dialog_logo/4.png  Dialog Mobile  Dialog话费  号码必修长度校验 10  前三只能输入076/077/074  TX_ATOB
     Telecom  DTV  1  https://oss.shinianwangluo.com/system/dialog_logo/5.png  Dialog TV  Dialog电视  号码必修长度校验 8  TX_ATOB
     OtherUtility  CEB  1  https://oss.shinianwangluo.com/system/dialog_logo/6.png  CEB  电费CEB  账号长度校验 10  TX_AUBP
     OtherUtility  LECO  1  https://oss.shinianwangluo.com/system/dialog_logo/7.png  LECO  电费LECO  账号长度校验 10  TX_AUBP
     OtherUtility  NWSDB  1  https://oss.shinianwangluo.com/system/dialog_logo/8.png  Water Board  水局  xx/xx/xxx/xxx/xx  TX_AUBP
     */
    PostCreateDialogOrderRequest *checkRequest = [PostCreateDialogOrderRequest request];
    if (!self.dialogInfo.showNoticeAccount) {
        checkRequest.accountNumber = mobileText;
        checkRequest.refernceMobileNumber = mobileText;
    }else {
        checkRequest.accountNumber = mobileText;
        checkRequest.refernceMobileNumber = self.noticeTextField.text;
    }
    checkRequest.dialogId = self.isFromFavorite ? self.dialogInfo.dialogId : self.dialogInfo.ID;
    checkRequest.domain = self.dialogInfo.domain;
    checkRequest.txType = self.dialogInfo.type;
    checkRequest.txAmount = self.amount;
    checkRequest.parameters=[checkRequest mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:checkRequest responseClass:[PostCreateDialogOrderInfor class] contentClass:[PostCreateDialogOrderInfor class] success:^(PostCreateDialogOrderInfor* response) {
        self.paymentId = response.paymentId;
        [self gotoRecharge:amount];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
    
}
/**
 根据金额获取转换后的金额
 */
-(void)gotoRecharge:(float)amount{
    GetExchangeByAmountRequest*request=[GetExchangeByAmountRequest request];
    request.amount=[NSString stringWithFormat:@"%.2f",amount];
    request.fromCode = self.currencyCodeVal;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[ExchangeByAmountInfo class] success:^(NSArray* response) {
        [QMUITips hideAllTips];
        self.currentExchangeByAmountInfo=response.firstObject;
        SelectPayWayViewController*vc=[[SelectPayWayViewController alloc]init];
        vc.currentExchangeByAmountInfo=self.currentExchangeByAmountInfo;
        vc.amount=self.amount;
        vc.isFromFavorite=self.isFromFavorite;
        vc.mobile=self.mobileTextField.text;
        vc.remark=self.descriTextField.text;
        vc.dialogInfo=self.dialogInfo;
        vc.noticeMobile=self.noticeTextField.text;
        vc.currencyCode = self.currencyCodeVal;
        vc.userBalanceInfo = self.userBalanceInfo;
        vc.currentInfo = self.currentInfo;
        vc.paymentId = self.paymentId;
        vc.countryCode = self.countryCode;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

-(void)getC2cBalanceUSDT{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (C2CBalanceListInfo *info in C2CUserManager.shared.c2cBalanceListItems) {
            if ([info.code isEqualToString:@"USDT"]) {
                self.currentInfo = info;
                break;
            }
        }
    });
}

- (void)fetchUserBalance {
    dispatch_async(dispatch_get_main_queue(), ^{
    UserBalanceRequest *request = [UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
        self.userBalanceInfo = response;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    });
}

@end
