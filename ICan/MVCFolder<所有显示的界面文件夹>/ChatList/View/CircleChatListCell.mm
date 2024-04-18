#import "CircleChatListCell.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+CircleUserInfo.h"
#import "CircleUserInfo.h"
#import "ChatListModel.h"
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
        }else{
            self.lastMessageLabel.text   = self.chatListModel.messageContent;
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
        [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithCircleUserId:chatListModel.circleUserId successBlock:^(CircleUserInfo * _Nonnull info) {
            self.nameLabel.text=info.nickname;
            [self.iconView setCircleIconImageViewWithUrl:info.avatar gender:info.gender];
        }];
        self.unreadLabelTopLeading.constant=-2;
        [self.unreadLabel layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
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

