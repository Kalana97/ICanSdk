//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 6/5/2020
 - File name:  IcanHelpListTableViewCell.m
 - Description:
 - Function List:
 */


#import "IcanHelpListTableViewCell.h"

@interface IcanHelpListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
/** 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *orederId;
/** 充值时间 */
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;

//支付类型

@property (weak, nonatomic) IBOutlet UIStackView *payTypeBgView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *payTypeLineView;
/** 备注消息 */
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeTimeLabel;
@property (weak, nonatomic) IBOutlet UIStackView *bgView;
/** 删除 */
@property (nonatomic,strong)  UIMenuItem *deleteMessageItem;
@property (nonatomic, strong) UIMenuController *menuController;
@property (weak, nonatomic) IBOutlet UILabel *remarktipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;


@end


@implementation IcanHelpListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=UIColorBg243Color;
    self.bgContentView.backgroundColor=UIColor.whiteColor;
    [self.bgContentView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    UILongPressGestureRecognizer*longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
    self.bgView.userInteractionEnabled=YES;
    [self.bgView addGestureRecognizer:longpress];
    self.remarktipsLabel.text=@"Remark".icanlocalized;
    self.remarktipsLabel.textColor = UIColorThemeMainSubTitleColor;
    self.remarkLabel.textColor = UIColorThemeMainTitleColor;
    
    
    self.payTypeLabel.text=@"IcanHelpListTableViewCell.payTypeLabel".icanlocalized;
    self.payTypeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.payTypeDetailLabel.textColor = UIColorThemeMainTitleColor;


    //订单号
    self.orderTipsLabel.text=@"c2cWalletDetailOrderNumber".icanlocalized;
    self.orderTipsLabel.textColor = UIColorThemeMainSubTitleColor;
    self.orederId.textColor=UIColorThemeMainTitleColor;


    self.lookDetailLabel.text=@"View Details".icanlocalized;
    self.lookDetailLabel.textColor = UIColorThemeMainSubTitleColor;

    self.rechargeLabel.textColor=UIColorThemeMainSubTitleColor;
    self.rechargeTimeLabel.textColor=UIColorThemeMainTitleColor;

    
    self.titleLabel.textColor = UIColorThemeMainTitleColor;
    self.amoutLabel.textColor = UIColorThemeMainTitleColor;

    self.tipsLabel.textColor = UIColorThemeMainSubTitleColor;
    
}
-(void)longpress:(UILongPressGestureRecognizer *)longPressGes{
    if (longPressGes.state==UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        NSMutableArray*items=[NSMutableArray array];
        [items addObject:self.deleteMessageItem];
        [self.menuController setMenuItems:items];
        CGRect targetRect = [self convertRect:self.bgView.frame toView:self.superview.superview];
        [self.menuController setTargetRect:targetRect inView:self.superview.superview];
        [self.menuController setMenuVisible:YES animated:YES];
    }
    
    
}
#pragma mark --
//以下两个方法必须有
/*
 *  让UIView成为第一responser
 */
- (BOOL)canBecomeFirstResponder{
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(menuDeleteAction)){
        return YES;
    }
    return NO;
    
}
-(void)setChatModel:(ChatModel *)chatModel{
    _chatModel=chatModel;
    PayHelperMsgInfo*removeChatInfo=[PayHelperMsgInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
    self.timeLabel.text=[GetTime convertDateWithString:chatModel.messageTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];;
    self.rechargeTimeLabel.text=[GetTime convertDateWithString:[NSString stringWithFormat:@"%ld",removeChatInfo.time] dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
    self.remarkLabel.text=removeChatInfo.remark;
    NSString*titltLabelText;
    NSString*tipsLabelText;
    NSString*rechargeLabelText;
    if ([removeChatInfo.payType isEqualToString:@"Transfer"]) {
        titltLabelText=@"Transfer To Account".icanlocalized;
        tipsLabelText=@"TransferAmount".icanlocalized;
        rechargeLabelText=@"Arrival time".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"RefundSingleRedPacket"]||[removeChatInfo.payType isEqualToString:@"RefundRoomRedPacket"]) {
        titltLabelText=@"red packet Returned".icanlocalized;
        tipsLabelText=@"Red packet amount".icanlocalized;
        rechargeLabelText=@"Return time".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"MobileRecharge"]) {
        titltLabelText=@"Mobile Phone Recharge To Account".icanlocalized;
        tipsLabelText=@"Top up amount".icanlocalized;
        rechargeLabelText=@"Arrival time".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"GiftCard"]) {
        titltLabelText=@"Gift Card Purchase".icanlocalized;
        tipsLabelText=@"Consumption amount".icanlocalized;
        rechargeLabelText=@"Consumption time".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"BalanceRecharge"]) {
        titltLabelText=@"Top Up Received".icanlocalized;
        tipsLabelText=@"Top up amount".icanlocalized;
        rechargeLabelText=@"Arrival time".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_CREATE"]) {
        titltLabelText=@"Withdrawal application".icanlocalized;
        tipsLabelText=@"Withdrawal amount".icanlocalized;
        rechargeLabelText=@"Application Time".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_SUCCESS"]) {
        titltLabelText=@"Successful withdrawal".icanlocalized;
        tipsLabelText=@"Withdrawal amount".icanlocalized;
        rechargeLabelText=@"Arrival time".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_FAIL"]) {
        titltLabelText=@"Withdrawal failed".icanlocalized;
        tipsLabelText=@"Withdrawal amount".icanlocalized;
        rechargeLabelText=@"Failure time".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"Payment"]){
        if ([removeChatInfo.amount containsString:@"-"]) {
            titltLabelText=@"Payment successful".icanlocalized;
            tipsLabelText=@"PaymentAmount".icanlocalized;
            rechargeLabelText=@"Payment Time".icanlocalized;
        }else{
            titltLabelText=@"Successfully Received".icanlocalized;;
            tipsLabelText=@"Received amount".icanlocalized;
            rechargeLabelText=@"Receipt Time".icanlocalized;
        }
        
    }else if ([removeChatInfo.payType isEqualToString:@"ReceivePayment"]){
        if ([removeChatInfo.amount containsString:@"-"]) {
            titltLabelText=@"Payment successful".icanlocalized;
            tipsLabelText=@"PaymentAmount".icanlocalized;
            rechargeLabelText=@"Payment Time".icanlocalized;
        }else{
            titltLabelText=@"Successfully Received".icanlocalized;;
            tipsLabelText=@"Received amount".icanlocalized;
            rechargeLabelText=@"Receipt Time".icanlocalized;
        }
    }else if ([removeChatInfo.payType isEqualToString:@"Dialog"]){
        
        titltLabelText=@"Top-upSuccess".icanlocalized;;
        tipsLabelText=@"Top up amount".icanlocalized;
        rechargeLabelText=@"Application Time".icanlocalized;
        
    }else if([removeChatInfo.payType isEqualToString:@"MomentEarnings"]){
        //"PostingIncome"="发帖收益";
//        "AmountofEarnings"="收益金额";
        titltLabelText=@"PostingIncome".icanlocalized;;
        tipsLabelText=@"AmountofEarnings".icanlocalized;
        rechargeLabelText=@"Receipt Time".icanlocalized;
    }
    self.titleLabel.text=titltLabelText;
    self.tipsLabel.text=tipsLabelText;
    self.rechargeLabel.text=rechargeLabelText;
    self.orederId.text=removeChatInfo.orderId;
    NSString * symbol = removeChatInfo.actualUnit;
    NSString *amount = [NSString stringWithFormat:@"%@ %.2f",removeChatInfo.actualUnit,[removeChatInfo.actualAmount floatValue]];
    NSMutableAttributedString*att=[[NSMutableAttributedString alloc]initWithString:amount];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, symbol.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:29] range:NSMakeRange(symbol.length, amount.length-symbol.length)];
    self.amoutLabel.attributedText=att;
    if (removeChatInfo.payChannelType) {
        self.payTypeBgView.hidden=self.payTypeLineView.hidden=NO;
        if([removeChatInfo.payChannelType isEqualToString:@"CryptoPay"]){
            self.payTypeDetailLabel.text = removeChatInfo.payChannelType;
        }else{
            self.payTypeDetailLabel.text = removeChatInfo.payChannelTypeName;
        }
    }else{
        self.payTypeBgView.hidden=self.payTypeLineView.hidden=YES;
    }
    
    
    
    
}
-(UIMenuController *)menuController{
    if (!_menuController) {
        _menuController=[UIMenuController sharedMenuController];
        [_menuController setArrowDirection:UIMenuControllerArrowDown];
    }
    return _menuController;
}
-(UIMenuItem *)deleteMessageItem{
    if (!_deleteMessageItem) {
        _deleteMessageItem = [[UIMenuItem alloc] initWithTitle:[@"timeline.post.operation.delete" icanlocalized:@"删除"] action:@selector(menuDeleteAction)];
    }
    return _deleteMessageItem;
}
-(void)menuDeleteAction{
    if (self.deleteBlock) {
        self.deleteBlock(self.chatModel);
    }
}
@end
