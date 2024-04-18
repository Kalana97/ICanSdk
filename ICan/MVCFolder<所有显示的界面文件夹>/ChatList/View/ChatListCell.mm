#import "ChatListCell.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "WCDBManager+ChatList.h"
#import "ChatListModel.h"
@interface ChatListCell ()
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

@implementation ChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.unreadLabel.backgroundColor=UIColorMake(240, 33, 77);
    [self.unreadLabel layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    self.timeLabel.textColor =UIColorThemeMainSubTitleColor;
    self.nameLabel.textColor=UIColorThemeMainTitleColor;
    [self.iconView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    self.lastMessageLabel.textColor = UIColorThemeMainSubTitleColor;
}
/// Description
/// @param chatListModel chatListModel description
- (void)setChatListModel:(ChatListModel *)chatListModel {
    if (chatListModel) {
        _chatListModel = chatListModel;
        ChatModel *config = [[ChatModel alloc]init];
        config.authorityType = AuthorityType_friend;
        config.chatID = self.chatListModel.chatID;
        config.chatType = self.chatListModel.chatType;
        ChatSetting *setting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
        if ([chatListModel.messageType isEqualToString:PayHelperMessageType]) {
            [self setPayHelperMessage];
        }else if ([chatListModel.messageType isEqualToString:SystemHelperMessageType]) {
            [self setSystemHelper];
        }else if ([chatListModel.messageType isEqualToString:AnnouncementHelperMessageType]) {
            [self setAnnounceHelper];
        }else if([chatListModel.messageType isEqualToString:ShopHelperMessageType]) {
            [self setShopHelperMessageType];
        }else if([chatListModel.chatType isEqualToString:C2CHelperMessageType]) {
            [self setC2COrderMessage];
        }else if ([chatListModel.chatType isEqualToString:AnnouncementHelperMessageType]) {
            [self setAnnouncementHelper];
        }else if ([chatListModel.chatType isEqualToString:NoticeOTPMessageType]) {
            [self setNoticeOTP];
        }else {
            [self setIcanChatFriendMessageType];
        }
        [self setUnreadLabel:chatListModel setting:setting];
        [self setTopWithSetting:setting];
        self.timeLabel.text = [GetTime getWeixintime:chatListModel.lastMessageTime];
    }
}

-(void)setShopHelperMessageType{
    [self.iconView setImage:UIImageMake(@"icon_chatlist_cell_shop")];
    self.nameLabel.text=@"Mall Assistant".icanlocalized;
    self.serviceIconImageView.hidden=YES;
    self.groupVipImageView.hidden=YES;
    ShopHelperMsgInfo*info=[ShopHelperMsgInfo mj_objectWithKeyValues:self.chatListModel.messageContent];
    self.lastMessageLabel.text=info.title;
}
-(void)setIcanChatFriendMessageType{
    self.serviceIconImageView.hidden=!self.chatListModel.isService;
    ///如果存在草稿，那么则显示草稿
    if (self.chatListModel.draftMessage.length>0) {
        NSMutableAttributedString*contens=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"[%@]%@",@"Draft".icanlocalized,_chatListModel.draftMessage]];
        [contens addAttributes:@{NSForegroundColorAttributeName:UIColor244RedColor} range:NSMakeRange(0, @"Draft".icanlocalized.length+2)];
        self.lastMessageLabel.attributedText=contens;
    }else{
        [self setIcanChatLastText];
    }
    [self setIcanChantNameAndIcon];
}

-(void)setTopWithSetting:(ChatSetting*)setting{
    self.lineView.backgroundColor=setting.isStick?UIColorMake(225,225,225):UIColorSeparatorColor;
}
- (void)setSystemHelper{
    [self.iconView setImageWithString:@"https://oss.icanlk.com/system/head_img/ican/system_notification.png" placeholder:nil];
    self.nameLabel.text = @"systemnotification".icanlocalized;
    self.serviceIconImageView.hidden = YES;
    SystemHelperInfo*removeChatInfo = [SystemHelperInfo mj_objectWithKeyValues:[NSString decodeUrlString: self.chatListModel.messageContent]];
    NSString*titltLabelText;
    /**实名认证通过 UserAuthPass,
     实名认证失败 UserAuthFail,
     其他Other
     "Authed"="已认证";
     "Authing"="待审核";
     "NotAuth"="未认证";
     "Authenticationfailed"="认证失败";
     */
    if ([removeChatInfo.type isEqualToString:@"UserAuthPass"]) {
        titltLabelText=@"Userrealnameauthentication".icanlocalized;
    }else if ([removeChatInfo.type isEqualToString:@"UserAuthFail"]) {
        titltLabelText=@"Userrealnameauthentication".icanlocalized;
    }else {
        titltLabelText=@"Notsupportedmessagetemporarily".icanlocalized;
    }
    self.lastMessageLabel.text=titltLabelText;
    self.groupVipImageView.hidden=YES;
}

- (void)setAnnounceHelper{
    [self.iconView setImageWithString:@"https://oss.icanlk.com/system/head_img/ican/system_notification.png" placeholder:nil];
    self.nameLabel.text = @"AnnouncementNotification".icanlocalized;
    self.serviceIconImageView.hidden = YES;
    SystemHelperInfo*removeChatInfo = [SystemHelperInfo mj_objectWithKeyValues:[NSString decodeUrlString: self.chatListModel.messageContent]];
    NSString*titltLabelText;
    titltLabelText = [NSString stringWithFormat:@"%@", removeChatInfo.title];
    self.lastMessageLabel.text=titltLabelText;
    self.groupVipImageView.hidden=YES;
}

- (void)setNoticeOTP {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:@"https://ican-chat.oss-ap-southeast-1.aliyuncs.com/system/head_img/ican/OTP_screen.png"]];
    self.nameLabel.text = @"NoticeOTP".icanlocalized;
    self.serviceIconImageView.hidden = YES;
    self.groupVipImageView.hidden = YES;
    NoticeOTPMessageInfo *info = [NoticeOTPMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: _chatListModel.messageContent]];
    self.lastMessageLabel.text = info.appName;
}

- (void)setAnnouncementHelper{
    [self.iconView setImageWithString:@"" placeholder:nil];
    [self.iconView setImage:UIImageMake(@"")];
    self.nameLabel.text = @"AnnouncementNotification".icanlocalized;
    self.serviceIconImageView.hidden = YES;
    SystemHelperInfo*removeChatInfo = [SystemHelperInfo mj_objectWithKeyValues:[NSString decodeUrlString: self.chatListModel.messageContent]];
    NSString*titltLabelText;
    /**实名认证通过 UserAuthPass,
     实名认证失败 UserAuthFail,
     其他Other
     "Authed"="已认证";
     "Authing"="待审核";
     "NotAuth"="未认证";
     "Authenticationfailed"="认证失败";
     */
    if ([removeChatInfo.type isEqualToString:@"UserAuthPass"]) {
        titltLabelText=@"Userrealnameauthentication".icanlocalized;
    }else if ([removeChatInfo.type isEqualToString:@"UserAuthFail"]) {
        titltLabelText=@"Userrealnameauthentication".icanlocalized;
    }else {
        titltLabelText=@"Notsupportedmessagetemporarily".icanlocalized;
    }
    self.lastMessageLabel.text=titltLabelText;
    self.groupVipImageView.hidden=YES;
}


- (void)setPayHelperMessage{
    [self.iconView setImage:UIImageMake(@"icon_chatlist_cell_assistant")];
    self.nameLabel.text=@"PaymentAssistant".icanlocalized;
    self.serviceIconImageView.hidden=YES;
    PayHelperMsgInfo*removeChatInfo=[PayHelperMsgInfo mj_objectWithKeyValues:[NSString decodeUrlString: self.chatListModel.messageContent]];
    NSString*titltLabelText;
    if ([removeChatInfo.payType isEqualToString:@"Transfer"]) {
        titltLabelText=@"Transfer To Account".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"RefundSingleRedPacket"]||[removeChatInfo.payType isEqualToString:@"RefundRoomRedPacket"]) {
        titltLabelText=@"red packet Returned".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"MobileRecharge"]) {
        titltLabelText=@"Mobile Phone Recharge To Account".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"GiftCard"]) {
        titltLabelText=@"Gift Card Purchase".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"BalanceRecharge"]) {
        titltLabelText=@"Top Up Received".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_CREATE"]) {
        titltLabelText=@"Withdrawal application".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_SUCCESS"]) {
        titltLabelText=@"Successful withdrawal".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"WITHDRAW_FAIL"]) {
        titltLabelText=@"Withdrawal failed".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"Payment"]){
        if ([removeChatInfo.amount containsString:@"-"]) {
            titltLabelText=@"Payment successful".icanlocalized;
            
        }else{
            titltLabelText=@"Successfully Received".icanlocalized;
            
        }
        
    }else if ([removeChatInfo.payType isEqualToString:@"ReceivePayment"]){
        if ([removeChatInfo.amount containsString:@"-"]) {
            titltLabelText=@"Payment successful".icanlocalized;
            
        }else{
            titltLabelText=@"Successfully Received".icanlocalized;
            
        }
    }else if ([removeChatInfo.payType isEqualToString:@"Dialog"]){
        titltLabelText= @"Top-upSuccess".icanlocalized;
    }else if ([removeChatInfo.payType isEqualToString:@"MomentEarnings"]){
        titltLabelText= @"PostingIncome".icanlocalized;
    }
    self.lastMessageLabel.text=titltLabelText;
    self.groupVipImageView.hidden=YES;
}
-(void)setIcanChantNameAndIcon{
    if ([self.chatListModel.chatType isEqualToString:GroupChat]) {
        if (self.chatListModel.chatID) {
            [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:self.chatListModel.chatID successBlock:^(GroupListInfo * _Nonnull info) {
                if ([info.businessType isEqualToString:@"Vip"]) {
                    self.groupVipImageView.hidden=NO;
                }else{
                    self.groupVipImageView.hidden=YES;
                }
                [[WCDBManager sharedManager]updateShowName:info.name chatId:info.groupId chatType:GroupChat];
                self.nameLabel.text=info.name;
                [self.iconView setImageWithString:info.headImgUrl placeholder:GroupDefault];
            }];
        }else{
            self.nameLabel.text=@"";
        }
        
    }else{
        if([self.chatListModel.chatID isEqual:@"100"]) {
            self.nameLabel.text = @"iCan AI";
            [self.iconView setDZIconImageViewWithUrl:@"https://oss.icanlk.com/system/head_img/ican/iA.png" gender:@"male"];
            self.groupVipImageView.hidden = YES;
        }else {
            if([self.chatListModel.messageType isEqual:DynamicMessageType]){
                NSArray<ChatModel*> *array = [[WCDBManager sharedManager]fetchDynamicHelperMessageTypeWithoutOffset];
                for (ChatModel *model in array) {
                    if([model.merchantId isEqual:self.chatListModel.chatID]){
                        DynamicMessageInfo *info = [DynamicMessageInfo mj_objectWithKeyValues:model.messageContent];
                        self.nameLabel.text = info.sender;
                        [self.iconView setDZIconImageViewWithUrl:info.senderImgUrl gender:@"male"];
                        self.lastMessageLabel.text = info.title;
                    }
                }
                self.groupVipImageView.hidden = YES;
            }else {
                self.groupVipImageView.hidden = YES;
                [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.chatListModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                    [[WCDBManager sharedManager]updateShowName:info.remarkName?:info.nickname chatId:info.userId chatType:UserChat];
                    if([info.remarkName isEqual:@""] || info.remarkName == nil) {
                        self.nameLabel.text = info.nickname;
                    }else {
                        self.nameLabel.text = info.remarkName;
                    }
                    [self.iconView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
                }];
            }
        }
    }
}
- (void)setUnreadLabel:(ChatListModel *)chatListModel setting:(ChatSetting *)setting {
    if (setting.isNoDisturbing) {
        self.disturbImageView.hidden=NO;
        self.unreadLabel.hidden=chatListModel.unReadMessageCount==0;
        self.unreadLabelLeftLeading.constant=0;
        self.unReadLabelWidth.constant = 10;
        self.unReadLabelHeight.constant=10;
        self.unreadLabelTopLeading.constant=5;
        self.unreadLabel.text=@"";
        [self.unreadLabel layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    }else{
        self.unreadLabelTopLeading.constant=-2;
        [self.unreadLabel layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
        self.disturbImageView.hidden=YES;
        self.unreadLabel.hidden=chatListModel.unReadMessageCount==0;
        NSInteger unReadNum=chatListModel.unReadMessageCount;
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
-(void)setC2COrderMessage{
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:@"https://oss.icanlk.com/system/logo/wallet_assistant.png"] placeholderImage:UIImageMake(@"icon_chatlist_cell_shop")];
    self.nameLabel.text=@"WalletAssistant".icanlocalized;
    self.serviceIconImageView.hidden=YES;
    self.groupVipImageView.hidden=YES;
    if ([self.chatListModel.messageType isEqualToString:C2COrderMessageType]) {
        C2COrderMessageInfo*msgInfo=[C2COrderMessageInfo mj_objectWithKeyValues:self.chatListModel.messageContent];
        NSString*stateStr;
        if ([msgInfo.status isEqualToString:@"Unpaid"]) {
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
        self.lastMessageLabel.text = stateStr;
    }else if ([self.chatListModel.messageType isEqualToString:C2CTransferType]){
        self.lastMessageLabel.text = @"WalletTransfer".icanlocalized;
    }else if ([self.chatListModel.messageType isEqualToString:C2CExtRechargeWithdrawType]){
        C2CExtRechargeWithdrawMessageInfo*msgInfo=[C2CExtRechargeWithdrawMessageInfo mj_objectWithKeyValues:self.chatListModel.messageContent];
        if ([msgInfo.type isEqualToString:@"Recharge"]) {
            self.lastMessageLabel.text = @"Top Up".icanlocalized;
        }else{
            self.lastMessageLabel.text = @"Withdraw".icanlocalized;
            
        }
    }else {
        self.lastMessageLabel.text = @"C2CNotify";
    }
    
}

-(void)setIcanChatLastText{
    if ([self.chatListModel.chatType isEqualToString:GroupChat]) {
        if (self.chatListModel.isOutGoing) {
            self.lastMessageLabel.text   = [NSString stringWithFormat:@"%@:%@",@"me".icanlocalized,self.chatListModel.messageContent];
        }else{
            NSString*messageType=self.chatListModel.messageType;
            if ([messageType isEqualToString:ImageMessageType]||[messageType isEqualToString:FileMessageType]||[messageType isEqualToString:VoiceMessageType]||[messageType isEqualToString:UserCardMessageType]||[messageType isEqualToString:TextMessageType]||[messageType isEqualToString:GamifyMessageType]||[messageType isEqualToString:URLMessageType]||[messageType isEqualToString:LocationMessageType]||[messageType isEqualToString:AtSingleMessageType]||[messageType isEqualToString:AtAllMessageType]||[messageType isEqualToString:VideoMessageType]||[messageType isEqualToString:kChatOtherShareType]||[messageType isEqualToString:kChat_PostShare]) {
                [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:self.chatListModel.chatID userId:self.chatListModel.messageFrom successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
                    if (memberInfo) {
                        [self setGroupLastMessageWithName:memberInfo.groupRemark?:memberInfo.nickname];
                    }else{
                        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.chatListModel.messageFrom successBlock:^(UserMessageInfo * _Nonnull info) {
                            [self setGroupLastMessageWithName:info.remarkName?:info.nickname];
                        }];
                    }
                }];
            }else{
                self.lastMessageLabel.text   = self.chatListModel.messageContent;
            }
            
        }
    }else{
        self.lastMessageLabel.text   = self.chatListModel.messageContent;
        
    }
}
-(void)setGroupLastMessageWithName:(NSString*)name{
    if (self.chatListModel.isShowAt) {
        NSMutableAttributedString*contens=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"[%@]%@:%@",NSLocalizedString(@"Someone @ you", 有人@你),name,self.chatListModel.messageContent]];
        [contens addAttributes:@{NSForegroundColorAttributeName:UIColor244RedColor} range:NSMakeRange(0, NSLocalizedString(@"Someone @ you", 有人@你).length+2)];
        self.lastMessageLabel.attributedText=contens;
    }else{
        if (self.chatListModel.messageContent.length>0) {
            self.lastMessageLabel.text   = [NSString stringWithFormat:@"%@:%@",name,self.chatListModel.messageContent];
        }else{
            self.lastMessageLabel.text=@"";
        }
    }
    
}
@end

