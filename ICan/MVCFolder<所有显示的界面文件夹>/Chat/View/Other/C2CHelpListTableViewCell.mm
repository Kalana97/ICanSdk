//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 6/5/2020
 - File name:  IcanHelpListTableViewCell.m
 - Description:
 - Function List:
 */


#import "C2CHelpListTableViewCell.h"
#import "WCDBManager+UserMessageInfo.h"
#import "ChatViewHandleTool.h"
@interface C2CHelpListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
///订单通知
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
///订单金额
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
/** 订单编号  1*/
@property (weak, nonatomic) IBOutlet UILabel *orderIdTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderIdDetailLab;
///购买类型 2
@property (weak, nonatomic) IBOutlet UILabel *orderTypeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeDetailLab;
///状态 3
@property (weak, nonatomic) IBOutlet UIView *orderStateLineView;
@property (weak, nonatomic) IBOutlet UIStackView *orderStateBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *orderStateTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStateDetailLab;
///订单时间 4
@property (weak, nonatomic) IBOutlet UILabel *orderTimeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeDetailLab;
@property (weak, nonatomic) IBOutlet UIButton *ccopyOneBtn;
@property (weak, nonatomic) IBOutlet UIView *ccopyOneLineView;
///订单数量 5
@property (weak, nonatomic) IBOutlet UIView *orderCountLineView;
@property (weak, nonatomic) IBOutlet UIStackView *orderCountBgStckView;
@property (weak, nonatomic) IBOutlet UILabel *orderCountTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderCountDetailLab;
@property (weak, nonatomic) IBOutlet UIButton *ccopyTwoBtn;
@property (weak, nonatomic) IBOutlet UIView *ccopyTwoLineView;
///备注 6
@property (weak, nonatomic) IBOutlet UIView *remarkLineView;
@property (weak, nonatomic) IBOutlet UIStackView *remarkBgView;
@property (weak, nonatomic) IBOutlet UILabel *remarkTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkDetailLab;
@property (weak, nonatomic) IBOutlet UIView *lookBgView;
@property (weak, nonatomic) IBOutlet UIView *cellLineView;
@property (weak, nonatomic) IBOutlet UILabel *lookDetailLabel;
@property (weak, nonatomic) IBOutlet UIStackView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
/** 删除 */
@property (nonatomic,strong)  UIMenuItem *deleteMessageItem;
@property (nonatomic, strong) UIMenuController *menuController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *belowAmountViewHeight;
@property (weak, nonatomic) IBOutlet DZIconImageView *logoImg;
@end

@implementation C2CHelpListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorBg243Color;
    self.bgContentView.backgroundColor = UIColor.whiteColor;
    [self.bgContentView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
    self.bgView.userInteractionEnabled = YES;
    [self.bgView addGestureRecognizer:longpress];
    self.orderIdDetailLab.textColor = UIColorThemeMainTitleColor;
    self.orderIdTitleLab.textColor = UIColorThemeMainSubTitleColor;
    self.orderTypeDetailLab.textColor = UIColorThemeMainTitleColor;
    self.orderTypeTitleLab.textColor = UIColorThemeMainSubTitleColor;
    self.orderStateDetailLab.textColor = UIColorThemeMainTitleColor;
    self.orderStateTitleLab.textColor = UIColorThemeMainSubTitleColor;
    self.orderTimeDetailLab.textColor = UIColorThemeMainTitleColor;
    self.orderTimeTitleLab.textColor = UIColorThemeMainSubTitleColor;
    self.orderCountDetailLab.textColor = UIColorThemeMainTitleColor;
    self.orderCountTitleLab.textColor = UIColorThemeMainSubTitleColor;
    self.lookDetailLabel.text = @"View Details".icanlocalized;
    self.lookDetailLabel.textColor = UIColorThemeMainSubTitleColor;
    self.titleLabel.textColor = UIColorThemeMainTitleColor;
    self.amoutLabel.textColor = UIColorThemeMainTitleColor;
    self.tipsLabel.textColor = UIColorThemeMainSubTitleColor;
}

- (void)longpress:(UILongPressGestureRecognizer *)longPressGes {
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:self.deleteMessageItem];
        [self.menuController setMenuItems:items];
        CGRect targetRect = [self convertRect:self.bgView.frame toView:self.superview.superview];
        [self.menuController setTargetRect:targetRect inView:self.superview.superview];
        [self.menuController setMenuVisible:YES animated:YES];
    }
}

#pragma mark --
//以下两个方法必须有 - The following two methods must have
/*
 *  让UIView成为第一responser
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(menuDeleteAction)){
        return YES;
    }
    return NO;
}

- (void)setC2COrderMessageType:(ChatModel * _Nonnull)chatModel {
    self.orderIdTitleLab.hidden = self.orderIdDetailLab.hidden = NO;
    self.orderCountTitleLab.hidden = self.orderCountDetailLab.hidden = NO;
    self.orderTypeTitleLab.hidden = self.orderTypeDetailLab.hidden = NO;
    self.orderStateTitleLab.hidden = self.orderStateDetailLab.hidden = NO;
    self.orderStateLineView.hidden = self.orderStateBgStackView.hidden = NO;
    self.titleLabel.text = @"OrderNotification".icanlocalized;
    self.tipsLabel.text = @"OrderAmount".icanlocalized;
    self.orderIdTitleLab.text = @"OrderID".icanlocalized;
    self.orderTypeTitleLab.text = @"OrderType".icanlocalized;
    self.orderStateTitleLab.text = @"Status".icanlocalized;
    self.orderTimeTitleLab.text = @"Ordertime".icanlocalized;
    self.orderCountTitleLab.text = @"OrderQuantity".icanlocalized;
    self.lookBgView.hidden = self.cellLineView.hidden = NO;
    self.ccopyOneBtn.hidden = self.ccopyOneLineView.hidden = YES;
    self.ccopyTwoBtn.hidden = self.ccopyTwoLineView.hidden = YES;
    self.remarkBgView.hidden = self.remarkLineView.hidden = YES;
    self.orderStateLineView.hidden = self.orderStateBgStackView.hidden = NO;
    C2COrderMessageInfo *msgInfo = [C2COrderMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
    self.timeLabel.text = [GetTime convertDateWithString:chatModel.messageTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.orderIdDetailLab.text = msgInfo.orderId;
    self.orderTypeDetailLab.text = msgInfo.orderId;
    self.orderTimeDetailLab.text = [GetTime convertDateWithString:chatModel.messageTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.orderCountDetailLab.text = [NSString stringWithFormat:@"%@ %@",[msgInfo.quantity calculateByNSRoundDownScale:2].currencyString,msgInfo.virtualCurrency];
    NSString *stateStr;
    if([msgInfo.status isEqualToString:@"Unpaid"]) {
        stateStr = @"C2COrderStateUnpaid".icanlocalized;
    }else if ([msgInfo.status isEqualToString:@"Paid"]) {
        stateStr = @"C2COrderStatePaid".icanlocalized;
    }else if ([msgInfo.status isEqualToString:@"Appeal"]) {
        stateStr = @"C2COrderStateAppeal".icanlocalized;
    }else if ([msgInfo.status isEqualToString:@"Completed"]) {
        stateStr = @"C2COrderStateCompleted".icanlocalized;
    }else if ([msgInfo.status isEqualToString:@"Cancelled"]) {
        stateStr = @"C2COrderStateCancelled".icanlocalized;
    }
    self.orderStateDetailLab.text = stateStr;
    if([msgInfo.buyICanUserId isEqualToString: UserInfoManager.sharedManager.userId]) {
        self.orderTypeDetailLab.text = @"C2CAdverFilterTypePopViewBuy".icanlocalized;
    }else{
        self.orderTypeDetailLab.text = @"C2CAdverFilterTypePopViewSale".icanlocalized;
    }
    NSString *symbol = msgInfo.legalTender;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",msgInfo.legalTender,[msgInfo.totalCount calculateByNSRoundDownScale:8].currencyString];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:amount];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, symbol.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:29] range:NSMakeRange(symbol.length, amount.length - symbol.length)];
    self.amoutLabel.textColor = [UIColor blackColor];
    self.amoutLabel.attributedText = att;
    NSString *imgName = [ChatViewHandleTool getImageByCurrencyCode:msgInfo.legalTender];
    if([imgName isEqualToString:@"N/A"]) {
        self.logoImg.hidden = YES;
    }else {
        self.logoImg.hidden = NO;
        self.logoImg.image = [UIImage imageNamed:imgName];
    }
}

- (void)setC2CNotifyMessageType:(ChatModel * _Nonnull)chatModel {
    C2CNotifyMessageInfo *msgInfo = [C2CNotifyMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
    self.remarkDetailLab.text = msgInfo.remark;
    self.amoutLabel.textColor = [UIColor redColor];
    self.amoutLabel.text = [[msgInfo.balance calculateByRoundingScale:8] stringValue];
    self.titleLabel.text = @"C2CNotification".icanlocalized;
    self.orderTimeTitleLab.text = @"Ordertime".icanlocalized;
    self.tipsLabel.text = @"Balance".icanlocalized;
    self.timeLabel.text = [GetTime convertDateWithString:chatModel.messageTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.remarkTitleLab.text = @"Remark".icanlocalized;
    self.orderTimeDetailLab.text = self.timeLabel.text;
    self.remarkBgView.hidden = self.remarkLineView.hidden = NO;
    self.lookBgView.hidden = self.cellLineView.hidden = YES;
    self.ccopyOneBtn.hidden = self.ccopyOneLineView.hidden = YES;
    self.ccopyTwoBtn.hidden = self.ccopyTwoLineView.hidden = YES;
    self.orderIdTitleLab.hidden = self.orderIdDetailLab.hidden = YES;
    self.orderCountTitleLab.hidden = self.orderCountDetailLab.hidden = YES;
    self.orderTypeTitleLab.hidden = self.orderTypeDetailLab.hidden = YES;
    self.orderStateTitleLab.hidden = self.orderStateDetailLab.hidden = YES;
    self.orderStateLineView.hidden = self.orderStateBgStackView.hidden = YES;
    self.logoImg.hidden = YES;
}

- (void)setC2CTransferData:(ChatModel * _Nonnull)chatModel {
    C2CTransferMessageInfo *msgInfo = [C2CTransferMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
    if (msgInfo.remark.length>0) {
        self.orderCountLineView.hidden = self.orderCountBgStckView.hidden = NO;
    }else{
        self.orderCountLineView.hidden = self.orderCountBgStckView.hidden = YES;
    }
    self.orderIdTitleLab.hidden = self.orderIdDetailLab.hidden = NO;
    self.orderCountTitleLab.hidden = self.orderCountDetailLab.hidden = NO;
    self.orderTypeTitleLab.hidden = self.orderTypeDetailLab.hidden = NO;
    self.orderStateTitleLab.hidden = self.orderStateDetailLab.hidden = NO;
    self.orderStateLineView.hidden = self.orderStateBgStackView.hidden = NO;
    self.titleLabel.text = @"WalletTransfer".icanlocalized;
    self.tipsLabel.text = @"Amount".icanlocalized;
    self.orderIdTitleLab.text = @"OrderID".icanlocalized;
    self.orderTypeTitleLab.text = @"TransferTime".icanlocalized;
    self.orderStateTitleLab.text = @"Originator".icanlocalized;
    self.orderTimeTitleLab.text = @"Receiver".icanlocalized;
    self.orderCountTitleLab.text = @"Remark".icanlocalized;
    self.lookBgView.hidden = self.cellLineView.hidden = YES;
    self.remarkBgView.hidden = self.remarkLineView.hidden = YES;
    self.ccopyOneBtn.hidden = self.ccopyOneLineView.hidden = YES;
    self.ccopyTwoBtn.hidden = self.ccopyTwoLineView.hidden = YES;
    NSString *imgName = [ChatViewHandleTool getImageByCurrencyCode:msgInfo.currencyCode];
    if ([imgName isEqualToString:@"N/A"]){
        self.logoImg.hidden = YES;
    }else{
        self.logoImg.hidden = NO;
        self.logoImg.image = [UIImage imageNamed:imgName];
    }
    self.orderStateLineView.hidden = self.orderStateBgStackView.hidden = NO;
    self.timeLabel.text = [GetTime convertDateWithString:chatModel.messageTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.orderIdDetailLab.text = msgInfo.orderId;
    self.orderTypeDetailLab.text = [GetTime convertDateWithString:msgInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    [[WCDBManager sharedManager] fetchUserMessageInfoWithNumberId:msgInfo.fromNumberId successBlock:^(UserMessageInfo * _Nonnull info) {
        if(info.nickname == nil){
            self.orderStateDetailLab.text = msgInfo.fromNumberId;
        }else {
            self.orderStateDetailLab.text = [info.nickname stringByAppendingString:[NSString stringWithFormat:@" (%@%@",msgInfo.fromNumberId, @")"]];
        }
    }];
    [[WCDBManager sharedManager] fetchUserMessageInfoWithNumberId:msgInfo.toNumberId successBlock:^(UserMessageInfo * _Nonnull info) {
        if(info.nickname == nil){
            self.orderTimeDetailLab.text = msgInfo.toNumberId;
        }else {
            self.orderTimeDetailLab.text = [info.nickname stringByAppendingString:[NSString stringWithFormat:@" (%@%@",msgInfo.toNumberId, @")"]];
        }
    }];
    self.amoutLabel.textColor = [UIColor blackColor];
    self.orderCountDetailLab.text = msgInfo.remark;
    NSString *symbol = msgInfo.currencyCode;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",[msgInfo.amount calculateByNSRoundDownScale:8].currencyString, msgInfo.currencyCode];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:amount];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:29] range:NSMakeRange(0, amount.length - symbol.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(amount.length - symbol.length, symbol.length)];
    self.amoutLabel.attributedText = att;
}

- (void)setC2CExtRechargeOrWithdrawData:(ChatModel * _Nonnull)chatModel {
    C2CExtRechargeWithdrawMessageInfo *msgInfo = [C2CExtRechargeWithdrawMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
    if ([msgInfo.type isEqualToString:@"Recharge"]) {
        self.titleLabel.text = @"Top Up".icanlocalized;
        self.orderStateLineView.hidden = self.orderStateBgStackView.hidden = YES;
    }else{
        ///手续费率 - Fee rate
        self.titleLabel.text = @"Withdraw".icanlocalized;
        self.orderStateLineView.hidden = self.orderStateBgStackView.hidden = NO;
    }
    self.orderIdTitleLab.hidden = self.orderIdDetailLab.hidden = NO;
    self.orderCountTitleLab.hidden = self.orderCountDetailLab.hidden = NO;
    self.orderTypeTitleLab.hidden = self.orderTypeDetailLab.hidden = NO;
    self.orderStateTitleLab.hidden = self.orderStateDetailLab.hidden = NO;
    self.orderStateLineView.hidden = self.orderStateBgStackView.hidden = NO;
    self.tipsLabel.text = @"Amount".icanlocalized;
    self.orderIdTitleLab.text = @"OrderID".icanlocalized;
    self.orderTypeTitleLab.text = @"Transaction time".icanlocalized;
    self.orderStateTitleLab.text = @"HandlingFeeRate".icanlocalized;
    self.orderTimeTitleLab.text = @"FromAddress".icanlocalized;
    self.orderCountTitleLab.text = @"ToAddress".icanlocalized;
    self.remarkTitleLab.text = @"TransactionHash".icanlocalized;
    self.remarkBgView.hidden = self.remarkLineView.hidden = NO;
    self.lookBgView.hidden = self.cellLineView.hidden = YES;
    self.ccopyOneBtn.hidden = self.ccopyOneLineView.hidden = NO;
    self.ccopyTwoBtn.hidden = self.ccopyTwoLineView.hidden = NO;
    self.timeLabel.text = [GetTime convertDateWithString:chatModel.messageTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.orderIdDetailLab.text = msgInfo.orderId;
    ///交易时间 - transaction time
    self.orderTypeDetailLab.text = [GetTime convertDateWithString:msgInfo.createTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.orderStateDetailLab.text = [NSString stringWithFormat:@"%@ %@",[msgInfo.handlingFeeMoney calculateByRoundingScale:2].currencyString,msgInfo.currencyCode];
    self.orderTimeDetailLab.text = [msgInfo.fromAddress stringByReplacingCharactersInRange:NSMakeRange(10, msgInfo.toAddress.length-10-4) withString:@"..."];
    self.orderCountDetailLab.text = [msgInfo.toAddress stringByReplacingCharactersInRange:NSMakeRange(10, msgInfo.toAddress.length-10-4) withString:@"..."];
    self.remarkDetailLab.text = msgInfo.transactionHash;
    NSString *symbol = msgInfo.currencyCode;
    NSString *amount = [NSString stringWithFormat:@"%@ %@",[msgInfo.amount calculateByNSRoundDownScale:2].currencyString, msgInfo.currencyCode];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:amount];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:29] range:NSMakeRange(0, amount.length - symbol.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(amount.length - symbol.length, symbol.length)];
    self.amoutLabel.textColor = [UIColor blackColor];
    self.amoutLabel.attributedText = att;
    NSString *imgName = [ChatViewHandleTool getImageByCurrencyCode:msgInfo.currencyCode];
    if ([imgName isEqualToString:@"N/A"]){
        self.logoImg.hidden = YES;
    }else{
        self.logoImg.hidden = NO;
        self.logoImg.image = [UIImage imageNamed:imgName];
    }
}

- (void)setChatModel:(ChatModel *)chatModel {
    _chatModel = chatModel;
    if ([chatModel.messageType isEqualToString:C2COrderMessageType]) {
        [self setC2COrderMessageType:chatModel];
    }else if ([chatModel.messageType isEqualToString:C2CTransferType]) {
        [self setC2CTransferData:chatModel];
    }else if ([chatModel.messageType isEqualToString:C2CExtRechargeWithdrawType]) {
        [self setC2CExtRechargeOrWithdrawData:chatModel];
    }else if([chatModel.messageType isEqualToString:C2CNotifyMessageType]) {
        [self setC2CNotifyMessageType:chatModel];
    }
}

- (UIMenuController *)menuController {
    if (!_menuController) {
        _menuController = [UIMenuController sharedMenuController];
        [_menuController setArrowDirection:UIMenuControllerArrowDown];
    }
    return _menuController;
}

- (UIMenuItem *)deleteMessageItem {
    if (!_deleteMessageItem) {
        _deleteMessageItem = [[UIMenuItem alloc] initWithTitle:[@"timeline.post.operation.delete" icanlocalized:@"删除"] action:@selector(menuDeleteAction)];
    }
    return _deleteMessageItem;
}

- (void)menuDeleteAction {
    if (self.deleteBlock) {
        self.deleteBlock(self.chatModel);
    }
}
///转出地址
- (IBAction)copyFromAddressAction {
    C2CExtRechargeWithdrawMessageInfo *msgInfo = [C2CExtRechargeWithdrawMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: self.chatModel.messageContent]];
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = msgInfo.toAddress;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:nil];
}
///转入地址
- (IBAction)copytoAddressAction {
    C2CExtRechargeWithdrawMessageInfo *msgInfo = [C2CExtRechargeWithdrawMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: self.chatModel.messageContent]];
    UIPasteboard * board = [UIPasteboard generalPasteboard];
    board.string = msgInfo.fromAddress;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:nil];
}
@end
