//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 31/3/2020
 - File name:  SendMultipleRedPacketViewController.m
 - Description:
 - Function List:
 */


#import "SendVipRedPacketViewController.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+ChatModel.h"
#import "SendRedEnvelopeNavView.h"
#import "ChatUtil.h"
#import "DecimalKeyboard.h"
#import "PayManager.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "RedPacketRecordingViewController.h"
@interface SendVipRedPacketViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
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
@property (weak, nonatomic) IBOutlet UILabel *amountTypeLbl;
/** 发送的总金额 */
@property(nonatomic, copy) NSString *totalSendAmount;
/** 是否是拼手气红包 */
@property(nonatomic, assign) BOOL randomRedPacket;
/** 当金额不合法的时候 提示语 高度是30*/
@property(nonatomic, strong) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIView *errorTipBgView;

@property(nonatomic, strong) NSArray *groupMemberItems;
@property(nonatomic, strong) NSArray *vipItems;
/** 最小金额 */
@property(nonatomic, assign) NSString* minimumAmounts;
@property(nonatomic, assign) NSString* vipMoney;
@property(nonatomic, strong) UserBalanceInfo *balanceInfo;
@end

@implementation SendVipRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navBarView];
    self.payManager=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        self.balanceInfo = balance;
    }];
    self.navigationItem.rightBarButtonItem= [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_more_black") target:self action:@selector(moreButtonAction)];
    self.errorTipBgView.hidden = YES;
    self.randomRedPacket=YES;
    [self changeHeaderLabelPayType];
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
    [self.sendButton setTitle:NSLocalizedString(@"PrepareRedPacket", 塞钱进红包) forState:UIControlStateNormal];
    self.commentTextView.placeholder = NSLocalizedString(@"BlessingWords", 恭喜发财大吉大利);
    self.amoutLabel.text = NSLocalizedString(@"Total", 总金额);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:self.amountTextfield];
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.amountTextfield];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextfield.inputView = decimalKeyboard;
    self.redPacketNumberTextField.placeholder=NSLocalizedString(@"EnterNumber", 红包个数);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:self.redPacketNumberTextField];
    [self fetchGroupMemberInfo];
    self.view.backgroundColor = UIColorBg243Color;
    
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

- (IBAction)showPicker:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    NSString*textstr;
    textstr=self.amountTextfield.text;
    NSInteger redPacketNumber=[self.redPacketNumberTextField.text integerValue];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Random Amount".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.randomRedPacket=YES;
        self.amoutLabel.text = NSLocalizedString(@"Total", 总金额);
        [self changeHeaderLabelPayType];
        if(self.randomRedPacket){
            self.totalSendAmount=[NSString stringWithFormat:@"%.2f",[textstr doubleValue]];
            self.allMoneyLabel.text=[NSString stringWithFormat:@" %.2f CNT",[self.totalSendAmount doubleValue]];
        }else{
            self.totalSendAmount=[NSString stringWithFormat:@"%.2f",[textstr doubleValue]*redPacketNumber];
            self.allMoneyLabel.text=[NSString stringWithFormat:@" %.2f CNT",[self.totalSendAmount doubleValue]];
        }
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Identical Amount".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.randomRedPacket=NO;
        self.amoutLabel.text = NSLocalizedString(@"AmountEach", 总金额);
        [self changeHeaderLabelPayType];
        if(self.randomRedPacket){
            self.totalSendAmount=[NSString stringWithFormat:@"%.2f",[textstr doubleValue]];
            self.allMoneyLabel.text=[NSString stringWithFormat:@" %.2f CNT",[self.totalSendAmount doubleValue]];
        }else{
            self.totalSendAmount=[NSString stringWithFormat:@"%.2f",[textstr doubleValue]*redPacketNumber];
            self.allMoneyLabel.text=[NSString stringWithFormat:@" %.2f CNT",[self.totalSendAmount doubleValue]];
        }
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)changeHeaderLabelPayType{
    
    if(self.randomRedPacket == YES){
        self.amountTypeLbl.text = @"Random Amount".icanlocalized;
    }else{
        self.amountTypeLbl.text = @"Identical Amount".icanlocalized;
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
- (void)textChangeAction:(NSNotification*)noti{
    NSInteger redPacketNumber=[self.redPacketNumberTextField.text integerValue];
    UITextField*textfield=noti.object;
    if (textfield==self.redPacketNumberTextField) {
        if (redPacketNumber>self.vipItems.count) {
            self.minimumAmounts=[NSString stringWithFormat:@"%.2f",[self.vipMoney doubleValue]+(redPacketNumber-self.vipItems.count)*0.01];
        }else{
            self.minimumAmounts=[NSString stringWithFormat:@"%.2f",[self.vipMoney doubleValue]+0.01];;
            
        }
    }
    NSString*textstr;
    //错误提示
    NSString * errorTipsStr;
    BOOL isShowTips=YES;
    double oneRedPacket=0.00;
    //红包个数
    textstr=self.amountTextfield.text;
    if(self.randomRedPacket){
        oneRedPacket = [textstr doubleValue]/redPacketNumber;
        self.totalSendAmount = [NSString stringWithFormat:@"%.2f",[textstr doubleValue]];
    }else{
        oneRedPacket = [textstr doubleValue];
        self.totalSendAmount = [NSString stringWithFormat:@"%.2f",[textstr doubleValue]*redPacketNumber];
    }
    if ([self.totalSendAmount doubleValue]<[self.minimumAmounts doubleValue]) {
        self.sendButton.enabled=NO;
        [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
        isShowTips=YES;
        //         "TheRedPacketLessThan"="红包个数不能小于";
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            errorTipsStr = [NSString stringWithFormat:@"%@%@%@，%@%ld",@"The red packet amount cannot be less than".icanlocalized,self.minimumAmounts,@"CNYChat".icanlocalized,@"TheRedPacketLessThan".icanlocalized,self.vipItems.count+1];
        }
        
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            errorTipsStr = [NSString stringWithFormat:@"%@%@%@，%@%ld",@"The red packet amount cannot be less than".icanlocalized,self.minimumAmounts,@"CNY".icanlocalized,@"TheRedPacketLessThan".icanlocalized,self.vipItems.count+1];
        }
    }else if (redPacketNumber<self.vipItems.count+1){
        self.sendButton.enabled=NO;
        [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
        isShowTips=YES;
        errorTipsStr = [NSString stringWithFormat:@"%@ %ld",@"TheRedPacketLessThan".icanlocalized,self.vipItems.count+1];
    }else if (redPacketNumber>=self.vipItems.count+1&&[self.totalSendAmount doubleValue]>=[self.minimumAmounts doubleValue]){
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
            isShowTips = YES;
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
            isShowTips=YES;
            [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
        }else{
            NSDecimalNumber * total = [NSDecimalNumber decimalNumberWithString:self.amountTextfield.text];
            if ([total isEqualToNumber:[NSDecimalNumber notANumber]]) {
                self.sendButton.enabled=NO;
                [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
            }else{
                self.sendButton.enabled=YES;
                [self.sendButton setBackgroundColor:UIColorMake(243, 92, 75)];
            }
            isShowTips=NO;
        }
        
    }else if (redPacketNumber>0&&oneRedPacket>0.00) {
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
            isShowTips=YES;
            [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
        }
    }
    else {
        isShowTips=NO;
        self.sendButton.enabled=NO;
        [self.sendButton setBackgroundColor:UIColorMake(224, 192, 191)];
    }
    self.allMoneyLabel.text=[NSString stringWithFormat:@" %.2f CNT",[self.totalSendAmount doubleValue]];
    if (isShowTips) {
        [self.bgAmountView layerWithCornerRadius:5 borderWidth:1 borderColor:[UIColor redColor]];
        self.tipsLabel.text=errorTipsStr;
        self.errorTipBgView.hidden=NO;
        
    }else{
        [self.bgAmountView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        self.errorTipBgView.hidden=YES;
        
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
-(void)fetchGroupMemberInfo{
    GetGroupUserListRequest*request=[GetGroupUserListRequest request];
    request.groupId=self.groupListInfo.groupId;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupMemberInfo class] success:^(NSArray<GroupMemberInfo*>* response) {
        self.groupMemberItems = response;
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"vip = %d ",YES];
        self.vipItems= [response filteredArrayUsingPredicate:gpredicate];
        self.groupAmountLabel.text=[NSString stringWithFormat:@"%@%@%@，%@%ld%@",@"This group has a total of".icanlocalized,self.groupListInfo.userCount,@"BuyPackageCollectionViewCell.people".icanlocalized,@"VIP Users Total".icanlocalized,self.vipItems.count,@"BuyPackageCollectionViewCell.people".icanlocalized];
        //如果是VIP群 那么红包个数加一个
        self.redPacketNumberTextField.placeholder=[NSString stringWithFormat:@"%@%ld%@",@"The number of red packets cannot be less than".icanlocalized,self.vipItems.count+1,@"GE".icanlocalized];
        double vipMoney=0.00;
        for (GroupMemberInfo*memberInfo in self.vipItems) {
            vipMoney+=[memberInfo.vipMoney doubleValue];
        }
        self.vipMoney=[NSString stringWithFormat:@"%.2f",vipMoney];
        self.minimumAmounts=[NSString stringWithFormat:@"%.2f",vipMoney+ 0.01];
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            self.amountTextfield.placeholder=[NSString stringWithFormat:@"%@%@%@",@"Amount is at least".icanlocalized,self.minimumAmounts,@"CNYChat".icanlocalized];
        }
        
        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            self.amountTextfield.placeholder=[NSString stringWithFormat:@"%@%@%@",@"Amount is at least".icanlocalized,self.minimumAmounts,@"CNY".icanlocalized];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
    
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
        [UserInfoManager sharedManager].attemptCount = nil;
        [UserInfoManager sharedManager].isPayBlocked = NO;
        if(response.status == 3 || response.status == 2){
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
