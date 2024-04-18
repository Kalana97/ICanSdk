//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 6/5/2020
 - File name:  IcanHelpListTableViewCell.m
 - Description:
 - Function List:
 */

#import "SystemHelperListTableViewCell.h"

@interface SystemHelperListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//订单号
@property (weak, nonatomic) IBOutlet UIStackView *orderBgView;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
/** 订单编号 */
@property (weak, nonatomic) IBOutlet UILabel *orederDetailIdLabel;
@property (weak, nonatomic) IBOutlet UIView *orderLineView;

/** 充值时间 */
@property (weak, nonatomic) IBOutlet UIStackView *rechargeBgView;
@property (weak, nonatomic) IBOutlet UILabel *rechargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *rechargeLineView;

//支付类型
@property (weak, nonatomic) IBOutlet UIStackView *payTypeBgView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *payTypeLineView;


@property (weak, nonatomic) IBOutlet UIStackView *bgView;
/** 备注消息 */
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkDetailLabel;

/** 删除 */
@property (nonatomic,strong)  UIMenuItem *deleteMessageItem;
@property (nonatomic, strong) UIMenuController *menuController;



@end


@implementation SystemHelperListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=UIColorBg243Color;
    self.bgView.backgroundColor=UIColor.whiteColor;
    [self.bgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    UILongPressGestureRecognizer*longpress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
    self.bgView.userInteractionEnabled=YES;
    //"Userrealnameauthentication"="User real name authentication";
//    "Title"="Title";
//    "Notsupportedmessagetemporarily"="Not supported message temporarily";
//    "Status"="Status";
    
    [self.bgView addGestureRecognizer:longpress];
    self.remarkLabel.text=@"Remark".icanlocalized;
    self.payTypeLabel.text=@"IcanHelpListTableViewCell.payTypeLabel".icanlocalized;
    //订单号
    self.orderLabel.text=@"Order number".icanlocalized;
    
}
-(void)setChatModel:(ChatModel *)chatModel{
    _chatModel=chatModel;
    SystemHelperInfo*removeChatInfo = [SystemHelperInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
    self.timeLabel.text=[GetTime convertDateWithString:chatModel.messageTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];;
    
    NSString*titltLabelText;
    NSString*orderLabelText;
    NSString*orederDetailIdLabelText;
    NSString*rechargeLabelText;
    NSString*rechargeTimeLabelText;
    NSString*payTypeLabelText;
    NSString*payTypeDetailText;
    NSString*remarkLabelText;
    NSString*remarkDetailLabelText;
    /**实名认证通过 UserAuthPass,
       实名认证失败 UserAuthFail,
       其他Other
     "Authed"="已认证";
     "Authing"="待审核";
     "NotAuth"="未认证";
     "Authenticationfailed"="认证失败";
     "Title"="Title";
     "Notsupportedmessagetemporarily"="Not supported message temporarily";
     "Status"="Status";
     */
    self.orderBgView.hidden = self.orderLineView.hidden = self.rechargeBgView.hidden = self.rechargeLineView.hidden = NO;
    if ([removeChatInfo.type isEqualToString:@"UserAuthPass"]) {
        titltLabelText=@"Userrealnameauthentication".icanlocalized;
        orderLabelText = @"Title".icanlocalized;
        orederDetailIdLabelText = @"Userrealnameauthentication".icanlocalized;
        rechargeLabelText = @"Status".icanlocalized;
        rechargeTimeLabelText = @"Authed".icanlocalized;
        payTypeLabelText = @"Time".icanlocalized;
        payTypeDetailText = [GetTime convertDateWithString:[NSString stringWithFormat:@"%ld",removeChatInfo.time] dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
        remarkLabelText = @"Remark".icanlocalized;
        remarkDetailLabelText = @"Yourreal-nameauthenticationhaspassed".icanlocalized;
    }else if ([removeChatInfo.type isEqualToString:@"UserAuthFail"]) {
        titltLabelText=@"Userrealnameauthentication".icanlocalized;
        orderLabelText = @"Title".icanlocalized;
        orederDetailIdLabelText = @"Userrealnameauthentication".icanlocalized;
        rechargeLabelText = @"Status".icanlocalized;
        rechargeTimeLabelText = @"Authenticationfailed".icanlocalized;
        payTypeLabelText = @"Time".icanlocalized;
        payTypeDetailText = [GetTime convertDateWithString:[NSString stringWithFormat:@"%ld",removeChatInfo.time] dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
        remarkLabelText = @"Remark".icanlocalized;
        remarkDetailLabelText = removeChatInfo.remark?:@"Authenticationfailed".icanlocalized;
    }else{
        titltLabelText=@"Notsupportedmessagetemporarily".icanlocalized;
        payTypeLabelText = @"Time".icanlocalized;
        payTypeDetailText = [GetTime convertDateWithString:[NSString stringWithFormat:@"%ld",removeChatInfo.time] dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
        remarkLabelText = @"Remark".icanlocalized;
        remarkDetailLabelText = removeChatInfo.remark?:@"Notsupportedmessagetemporarily".icanlocalized;
        self.orderBgView.hidden = self.orderLineView.hidden = self.rechargeBgView.hidden = self.rechargeLineView.hidden = YES;
    }
    self.titleLabel.text = titltLabelText;
    self.orderLabel.text = orderLabelText;
    self.orederDetailIdLabel.text = orederDetailIdLabelText;
    self.rechargeLabel.text = rechargeLabelText;
    self.rechargeTimeLabel.text = rechargeTimeLabelText;
    self.payTypeLabel.text = payTypeLabelText;
    self.payTypeDetailLabel.text = payTypeDetailText;
    self.remarkLabel.text = remarkLabelText;
    self.remarkDetailLabel.text = remarkDetailLabelText;
    
    
    
    
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
