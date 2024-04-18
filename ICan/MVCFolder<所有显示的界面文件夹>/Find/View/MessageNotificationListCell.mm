//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 12/3/2020
- File name:  MessageNotificationListCell.m
- Description:
- Function List:
*/
        

#import "MessageNotificationListCell.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+TimeLineNotice.h"
#import "TimeLineNoticeInfo.h"
@implementation MessageNotificationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor=UIColor252730Color;
    self.timeLabel.textColor=UIColor153Color;
    [self.iconImageView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    
}
- (IBAction)moreButtonAction:(id)sender {
    if (self.moreButtonBlock) {
        self.moreButtonBlock();
    }
}

-(void)setTimeline:(TimeLineNoticeInfo *)timeline{
    if (timeline) {
        [self.iconImageView setDZIconImageViewWithUrl:timeline.avatar gender:timeline.gender];
        self.timeLabel.text=[GetTime timelinesTime:timeline.time];
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:timeline.userId successBlock:^(UserMessageInfo * _Nonnull info) {
            NSString*name=info.remarkName?:info.nickname;
            if (name.length>5) {
                name=[NSString stringWithFormat:@"%@...",[name substringToIndex:5]];
                
            }
            if ([timeline.messageType isEqualToString:@"Message"]) {
                self.titleLabel.text=[NSString stringWithFormat:@"%@%@",name,@"mentioned you in the post".icanlocalized];
               }else if ([timeline.messageType isEqualToString:@"Comment"]){
                   self.titleLabel.text=[NSString stringWithFormat:@"%@%@",name,@"commented on your post".icanlocalized];
               }else if ([timeline.messageType isEqualToString:@"Reply"]){
                   self.titleLabel.text=[NSString stringWithFormat:@"%@%@",name,@"replied you".icanlocalized];
               }else if ([timeline.messageType isEqualToString:@"Share"]){
                   self.titleLabel.text=[NSString stringWithFormat:@"%@%@",name,@"shared your post".icanlocalized];
               }
        }];
    }
    
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
