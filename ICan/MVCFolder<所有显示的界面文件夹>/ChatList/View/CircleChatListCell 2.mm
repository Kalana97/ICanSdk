#import "CircleChatListCell.h"
#import "ChatModel.h"
#import "WCDBManager+ChatSetting.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
@interface CircleChatListCell ()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unReadLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unReadLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unreadLabelLeftLeading;
@property (weak, nonatomic) IBOutlet UIImageView *disturbImageView;
@property (weak, nonatomic) IBOutlet UIImageView *serviceIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *groupVipImageView;

//默认是-2
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unreadLabelTopLeading;

@end

@implementation CircleChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.unreadLabel.backgroundColor=UIColorMake(240, 33, 77);
    [self.unreadLabel layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    self.timeLabel.textColor = UICOLOR_RGB_Alpha(0x999999, 1);
    self.nameLabel.textColor=UIColor252730Color;
    [self.iconView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    self.lastMessageLabel.textColor = UIColor153Color;
}
- (void)extracted:(ChatListModel *)chatListModel setting:(ChatSetting *)setting {
    [self.iconView setImage:UIImageMake(@"chat_assistant")];
    self.nameLabel.text=@"支付助手".icanlocalized;
    self.serviceIconImageView.hidden=YES;
    PayHelperMsgInfo*removeChatInfo=[PayHelperMsgInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatListModel.messageContent]];
    self.bgContentView.backgroundColor=setting.isStick?UIColorMake(247,247,247):[UIColor whiteColor];
    self.lineView.backgroundColor=setting.isStick?UIColorMake(225,225,225):UIColorSeparatorColor;
    NSString*titltLabelText;
    if ([removeChatInfo.payType isEqualToString:@"Transfer"]) {
        titltLabelText=@"转账到账".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"RefundSingleRedPacket"]||[removeChatInfo.payType isEqualToString:@"RefundRoomRedPacket"]) {
        titltLabelText=@"红包退回".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"MobileRecharge"]) {
        titltLabelText=@"手机充值到账".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"GiftCard"]) {
        titltLabelText=@"礼品卡购买".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"BalanceRecharge"]) {
        titltLabelText=@"充值到账".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_CREATE"]) {
        titltLabelText=@"提现申请".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_SUCCESS"]) {
        titltLabelText=@"提现成功".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_FAIL"]) {
        titltLabelText=@"提现失败".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"Payment"]){
        if ([removeChatInfo.amount containsString:@"-"]) {
            titltLabelText=@"付款成功".icanlocalized;
            
        }else{
            titltLabelText=@"收款成功".icanlocalized;
            
        }
        
    }else if ([removeChatInfo.payType isEqualToString:@"ReceivePayment"]){
        if ([removeChatInfo.amount containsString:@"-"]) {
            titltLabelText=@"付款成功".icanlocalized;
            
        }else{
            titltLabelText=@"收款成功".icanlocalized;
            
        }
    }
    self.lastMessageLabel.text=titltLabelText;
    self.groupVipImageView.hidden=YES;
}
/// Description
/// @param chatListModel chatListModel description
- (void)setChatListModel:(ChatListModel *)chatListModel {
    if (chatListModel) {
        _chatListModel = chatListModel;
        //密聊显示名字 不显示头像
        self.lastMessageLabel.text=@"Message".icanlocalized;
        if (chatListModel.secretDraftMessage.length>0) {
            NSMutableAttributedString*contens=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"[%@]%@",@"草稿".icanlocalized,_chatListModel.secretDraftMessage]];
            [contens addAttributes:@{NSForegroundColorAttributeName:UIColor244RedColor} range:NSMakeRange(0, @"草稿".icanlocalized.length+2)];
           
            self.lastMessageLabel.attributedText=contens;
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd"];
        NSDate *datenow = [NSDate date];
        NSString *currentTimeString = [formatter stringFromDate:datenow];
        NSString * lastMsgTime = [NSString timestampSwitchTime:[chatListModel.lastMessageTime longLongValue] andFormatter:@"MM-dd HH:mm"];
        if ([lastMsgTime containsString:currentTimeString]) {
            lastMsgTime = [lastMsgTime stringByReplacingOccurrencesOfString:currentTimeString withString:@""];
        }
        self.timeLabel.text = lastMsgTime;
        self.groupVipImageView.hidden=YES;
        self.serviceIconImageView.hidden=YES;
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:chatListModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
            [[WCDBManager sharedManager]updateShowName:info.remarkName?:info.nickname chatId:info.userId chatType:UserChat];
            self.nameLabel.text=info.remarkName?:info.nickname;
            
        }];
        
        [self.iconView setImageWithString:KSecretHeadImg placeholder:BoyDefault];
        self.unreadLabelTopLeading.constant=-2;
        [self.unreadLabel layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
        self.disturbImageView.hidden=YES;
        NSInteger unReadNum=chatListModel.unReadMessageCount;
        self.unreadLabel.hidden=unReadNum==0;
        self.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)unReadNum];
        self.unreadLabel.hidden = unReadNum==0;
        ViewRadius(_unreadLabel, 10);
        if (unReadNum > 9&&unReadNum<=99) {
            self.unreadLabelLeftLeading.constant=-17;
            self.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)unReadNum];
            self.unReadLabelWidth.constant = 26;
            self.unReadLabelHeight.constant=20;
        }else if (unReadNum > 99) {
            self.unreadLabel.text = @"···";
            self.unreadLabelLeftLeading.constant=-25;
            self.unReadLabelWidth.constant = 32;
            self.unReadLabelHeight.constant=20;
            
        } else {
            self.unreadLabelLeftLeading.constant=-15;
            self.unReadLabelWidth.constant = 20;
            self.unReadLabelHeight.constant=20;
            self.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)unReadNum];
        }
        
    }
   
    
}
@end

