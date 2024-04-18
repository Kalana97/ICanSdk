#import "SecretChatListCell.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "WCDBManager+ChatList.h"
#import "ChatListModel.h"
@interface SecretChatListCell ()
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

@implementation SecretChatListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgContentView.backgroundColor = UIColorViewBgColor;
    self.unreadLabel.backgroundColor=UIColorMake(240, 33, 77);
    [self.unreadLabel layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
    self.timeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.nameLabel.textColor=UIColorThemeMainTitleColor;
    [self.iconView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    self.lastMessageLabel.textColor = UIColorThemeMainSubTitleColor;
}
/// Description
/// @param chatListModel chatListModel description
- (void)setChatListModel:(ChatListModel *)chatListModel {
    if (chatListModel) {
        _chatListModel = chatListModel;
        //密聊显示名字 不显示头像
        self.lastMessageLabel.text=@"Message".icanlocalized;
        if (chatListModel.draftMessage.length>0) {
            NSMutableAttributedString*contens=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"[%@]%@",@"Draft".icanlocalized,_chatListModel.draftMessage]];
            [contens addAttributes:@{NSForegroundColorAttributeName:UIColor244RedColor} range:NSMakeRange(0, @"Draft".icanlocalized.length+2)];
           
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

