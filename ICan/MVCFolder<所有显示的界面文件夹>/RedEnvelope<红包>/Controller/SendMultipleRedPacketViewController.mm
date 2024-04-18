//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 31/3/2020
 - File name:  SendMultipleRedPacketViewController.m
 - Description:
 - Function List:
 */


#import "SendMultipleRedPacketViewController.h"
#import "SendRedEnvelopeNavView.h"
#import "ChatUtil.h"
#import "PayManager.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "RedPacketRecordingViewController.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+ChatModel.h"
@interface SendMultipleRedPacketViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@property(nonatomic, strong) SendRedEnvelopeNavView *navBarView;

//这个是普通红包
@property(nonatomic, weak) IBOutlet UIView *bgAmountView;
@property(nonatomic, weak) IBOutlet UILabel *amoutLabel;
@property(nonatomic, weak) IBOutlet UITextField *amountTextfield;
@property(nonatomic, weak) IBOutlet UILabel *cnyLabel;

//这个是拼手气红包
@property(weak, nonatomic)   IBOutlet UIView *randomImageJianGeView;
@property(nonatomic, weak) IBOutlet UIImageView *randomTipsImageView;
//当前为拼手气红包,改为普通红包
@property(nonatomic, weak) IBOutlet UILabel  *changeLabel;
@property(nonatomic, weak) IBOutlet UIView *redPacketNumberBgView;
//红包个数
@property(nonatomic, weak) IBOutlet UILabel *redPacketNumberLabel;
@property(nonatomic, weak) IBOutlet UITextField *redPacketNumberTextField;
/** 个 */
@property(nonatomic, weak) IBOutlet UILabel *numberLabel;

@property(nonatomic, weak) IBOutlet UILabel *groupAmountLabel;


@property(nonatomic, weak) IBOutlet UIView *commentView;
@property(nonatomic, weak) IBOutlet QMUITextView *commentTextView;

@property(nonatomic, weak) IBOutlet UILabel *allMoneyLabel;
@property(nonatomic, weak) IBOutlet UIButton *sendButton;
@property(nonatomic, strong) PayManager *payManager;
/** 发送的总金额 */
@property(nonatomic, copy) NSString *totalSendAmount;
/** 是否是拼手气红包 */
@property(nonatomic, assign) BOOL randomRedPacket;
/** 当金额不合法的时候 提示语 高度是30*/
@property(nonatomic, strong) IBOutlet UILabel *tipsLabel;
@property(nonatomic, strong) UserBalanceInfo *balanceInfo;
@end

@implementation SendMultipleRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    self.payManager=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        self.balanceInfo = balance;
    }];
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_more_black") target:self action:@selector(moreButtonAction)];
    self.tipsLabel.hidden = YES;
    self.randomRedPacket=YES;
    self.title = NSLocalizedString(@"SendRedPacket", 发红包);
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.cnyLabel.text = NSLocalizedString(@"YuanChat", CNY);
     }
    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        self.cnyLabel.text = NSLocalizedString(@"Yuan", CNT);
    }
    self.redPacketNumberLabel.text = NSLocalizedString(@"Quantity", 红包个数);
    self.numberLabel.text = NSLocalizedString(@"GE", 个);
    [self.sendButton setTitle:NSLocalizedString(@"PrepareRedPacket", 塞钱进红包) forState:UIControlStateNormal];
    self.commentTextView.placeholder = NSLocalizedString(@"BlessingWords", 恭喜发财大吉大利);
    if ([BaseSettingManager isChinaLanguages]) {
        self.groupAmountLabel.text = [NSString stringWithFormat:@"%@ %@人",@"This group has a total of".icanlocalized,self.groupListInfo.userCount];
    }else{
        self.groupAmountLabel.text = [NSString stringWithFormat:@"%@ members",self.groupListInfo.userCount];
    }
    [self setRandomTips];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeAction) name:UITextFieldTextDidChangeNotification object:self.amountTextfield];
    self.redPacketNumberTextField.placeholder=NSLocalizedString(@"EnterNumber", 红包个数);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeAction) name:UITextFieldTextDidChangeNotification object:self.redPacketNumberTextField];
    self.view.backgroundColor = UIColorBg243Color;

}

-(void)setRandomTips{
    self.amoutLabel.text = NSLocalizedString(@"Total", 总金额);
    self.randomTipsImageView.hidden = NO;
    self.randomImageJianGeView.hidden = NO;
    NSString*nowTips=NSLocalizedString(@"RandomAmountNow", 當前為拼手氣紅包);
    NSString*changTips=NSLocalizedString(@"Change to Identical Amount", 改為普通紅包);
    NSMutableAttributedString*att=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",nowTips,changTips]];
    [att addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(0, nowTips.length)];
    [att addAttribute:NSForegroundColorAttributeName value:UIColorMake(191, 157, 94) range:NSMakeRange(att.length-changTips.length, changTips.length)];
    self.changeLabel.attributedText=att;
    [self.changeLabel yb_addAttributeTapActionWithStrings:@[changTips] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        [self setGeneralRedTips];
        [self textChangeAction];
    }];
}
-(void)setGeneralRedTips{
    self.amoutLabel.text = NSLocalizedString(@"AmountEach", 单个金额);
    self.randomTipsImageView.hidden = YES;
    self.randomImageJianGeView.hidden = YES;
    NSString*nowTips=NSLocalizedString(@"IdenticalAmountNow", 当前为普通红包);
    NSString*changTips=NSLocalizedString(@"Change to Random Amount", 改为拼手气红包);
    NSMutableAttributedString*att=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",nowTips,changTips]];
    [att addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(0, nowTips.length)];
    [att addAttribute:NSForegroundColorAttributeName value:UIColorMake(191, 157, 94) range:NSMakeRange(att.length-changTips.length, changTips.length)];
    self.changeLabel.attributedText=att;
    [self.changeLabel yb_addAttributeTapActionWithStrings:@[changTips] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        [self setRandomTips];
        [self textChangeAction];
    }];
}

-(IBAction)sendButtonAction{
    if (self.balanceInfo) {
        [self showSurePayView];
    }else{
        [UserInfoManager.sharedManager fetchUserBalanceRequest:^(UserBalanceInfo * _Nonnull balance) {
            self.balanceInfo = balance;
            [self showSurePayView];
        }];
    }
}
-(void)showSurePayView{
    NSDecimalNumber * total = [NSDecimalNumber decimalNumberWithString:self.totalSendAmount];
    if ([total compare:self.balanceInfo.balance] == NSOrderedAscending || [total compare:self.balanceInfo.balance] == NSOrderedSame) {
        [self.payManager showPayViewWithAmount:self.totalSendAmount typeTitleStr:@"chatView.function.redPacket".icanlocalized SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
            [self sendMultipleRedPacketRequest:password];
        }];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:@"Insufficient Balance".icanlocalized inView:self.view];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)textChangeAction{
    NSString*textstr;
    //错误提示
    NSString * errorTipsStr;
    BOOL isShowTips=YES;
    double oneRedPacket;
    NSInteger redPacketNumber=[self.redPacketNumberTextField.text integerValue];
    if (self.randomRedPacket) {//拼手气红包
        textstr=self.amountTextfield.text;
        oneRedPacket=[textstr doubleValue]/redPacketNumber;
        self.totalSendAmount=[NSString stringWithFormat:@"%.2f",[textstr doubleValue]];
    }else{
        textstr=self.amountTextfield.text;
        oneRedPacket=[textstr doubleValue];
    }
    if (redPacketNumber>0&&oneRedPacket>0.00) {
        if(oneRedPacket>10000.00){
            //            errorTipsStr=@"单个红包金额不可超过10000元";
            //IcanChat
            if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                errorTipsStr = @"Up to 10000CNY for each Red Packet Chat".icanlocalized;
             }

            //IcanMeta
            if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                errorTipsStr = @"Up to 10000CNY for each Red Packet".icanlocalized;
            }
            self.sendButton.enabled=NO;
            [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
            isShowTips=YES;
        }else if (oneRedPacket<0.01){
            //            errorTipsStr=@"单个红包金额不低于0.01元";
            //IcanChat
            if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
                errorTipsStr = @"The red packet amount cannot be less than 0.01CNY Chat".icanlocalized;
             }
            //IcanMeta
            if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
                errorTipsStr = @"The red packet amount cannot be less than 0.01CNY".icanlocalized;
            }
            self.sendButton.enabled=NO;
            isShowTips = YES;
            [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
        }else if(oneRedPacket<=10000.00&&oneRedPacket>=0.01){
            NSDecimalNumber * total = [NSDecimalNumber decimalNumberWithString:self.amountTextfield.text];
            if ([total isEqualToNumber:[NSDecimalNumber notANumber]]) {
                self.sendButton.enabled=NO;
                [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
            }else{
                self.sendButton.enabled=YES;
                [self.sendButton setBackgroundColor:UIColorMake(243, 92, 75)];
            }
            if (!self.randomRedPacket) {
                self.totalSendAmount=[NSString stringWithFormat:@"%.2f",[self.amountTextfield.text doubleValue]*[self.redPacketNumberTextField.text integerValue]];
            }
            isShowTips=NO;
        }else{
            self.sendButton.enabled=NO;
            [self.sendButton setBackgroundColor:UIColorMake(243, 92, 75)];
            isShowTips=NO;
        }
    }else{
        isShowTips=NO;
        self.sendButton.enabled=NO;
        [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
    }
    self.allMoneyLabel.text=[NSString stringWithFormat:@"￥%.2f",[self.totalSendAmount doubleValue]];
    if (isShowTips) {
        [self.bgAmountView layerWithCornerRadius:5 borderWidth:1 borderColor:[UIColor redColor]];
    }else{
        [self.bgAmountView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    }
    if (isShowTips) {
        self.tipsLabel.text=errorTipsStr;
        self.tipsLabel.hidden=NO;
        
    }else{
        self.tipsLabel.hidden=YES;
       
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    if (textField==self.amountTextfield) {
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
    }
    if (string.length == 0)
        return YES;
    //第一个参数，被替换字符串的range，第二个参数，即将键入或者粘贴的string，返回的textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([checkStr integerValue]>[self.groupListInfo.userCount integerValue]) {
        [QMUITipsTool showErrorWihtMessage:@"The number of red packets cannot exceed the number of people in the group".icanlocalized inView:self.view];
        return NO;
    }
    return  [NSString checkIsPureString:checkStr];
}


-(SendRedEnvelopeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[SendRedEnvelopeNavView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, isIPhoneX?88:64)];
        @weakify(self);
        _navBarView.buttonBlock = ^(NSInteger tag) {
            @strongify(self);
            if (tag==100) {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }else{
                QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                }];
                QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"SentPackets", 发出的红包)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                    RedPacketRecordingViewController*vc=[[RedPacketRecordingViewController alloc]init];
                    vc.receive=NO;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }];
                QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ReceivedPackets", 收到的红包) style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                    RedPacketRecordingViewController*vc=[[RedPacketRecordingViewController alloc]init];
                    vc.receive=YES;
                    [self.navigationController pushViewController:vc animated:YES];
                  
                }];
                
                
                QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
                [alertController addAction:action1];
                [alertController addAction:action3];
                [alertController addAction:action2];
                [alertController showWithAnimated:YES];
            }
            
        };
    }
    return _navBarView;
}

-(void)moreButtonAction{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"SentPackets", 发出的红包)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        RedPacketRecordingViewController*vc=[[RedPacketRecordingViewController alloc]init];
        vc.receive=NO;
        [self.navigationController pushViewController:vc animated:YES];
       
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ReceivedPackets", 收到的红包) style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        RedPacketRecordingViewController*vc=[[RedPacketRecordingViewController alloc]init];
        vc.receive=YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    }];
    
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}
-(void)sendMultipleRedPacketRequest:(NSString*)password{
    SendMultipleRedPacketRequest*request=[SendMultipleRedPacketRequest request];
    request.groupId=self.groupId;
    if (self.randomRedPacket) {
        request.amount=self.amountTextfield.text;
    }else{
        request.amount=[NSString stringWithFormat:@"%.2f",[self.amountTextfield.text doubleValue]*[self.redPacketNumberTextField.text integerValue]];
    }
    request.count=self.redPacketNumberTextField.text;
    request.type=self.randomRedPacket?@"RANDOM":@"AVERAGE";
    request.comment=self.commentTextView.text.length>0?self.commentTextView.text:NSLocalizedString(@"BlessingWords", 恭喜发财大吉大利);
    request.payPassword=password;
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[SendMultipleRedPacketInfo class] contentClass:[SendMultipleRedPacketInfo class] success:^(SendMultipleRedPacketInfo* response) {
        [QMUITips hideAllTips];
        if(response.status == 3 || response.status == 2){
            [UserInfoManager sharedManager].attemptCount = nil;
            [UserInfoManager sharedManager].isPayBlocked = NO;
            [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.navigationController popViewControllerAnimated:YES];
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

@end
