//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 26/9/2019
 - File name:  ChatNoticeTableViewCell.m
 - Description:
 - Function List:
 - History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
 */


#import "ChatNoticeTableViewCell.h"
#import "ChatModel.h"
@interface ChatNoticeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cmdLabel;
@property (weak, nonatomic) IBOutlet UIView *jiangeView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation ChatNoticeTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.backgroundColor=UIColorBg243Color;
    self.cmdLabel.textColor = UIColorThemeMainSubTitleColor;
    ViewRadius(self.bgView, 5);
}

-(void)setcurrentChatModel:(ChatModel *)currentChatModel{
    _chatModel = currentChatModel;
    if ([currentChatModel.messageType isEqualToString:C2COrderMessageType]) {
        C2COrderMessageInfo*jsonInfo=[C2COrderMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: currentChatModel.messageContent]];
        /**
         "C2COrderStateUnpaid"="未付款";
         "YouHaveNewOrder"="您有新的订单";
         "C2COrderStatePaid"="已付款";
         "C2COrderStatePaidTips"="订单已付款";
         "C2COrderStateAppeal"="申诉";
         "C2COrderStateAppealTips"="订单正在进行申诉";
         "C2COrderStateCompleted"="已完成";
         "C2COrderStateCompletedTips"="订单已完成";
         "C2COrderStateCancelled"="已取消";
         "C2COrderStateCancelledTip"="订单已取消";
         */
        NSString*stateStr;
        NSString*stateTips;
        if ([jsonInfo.status isEqualToString:@"Unpaid"]) {
            stateStr = @"C2COrderStateUnpaid".icanlocalized;
            stateTips = @"YouHaveNewOrder".icanlocalized;
        }else if ([jsonInfo.status isEqualToString:@"Paid"]) {
            stateStr = @"C2COrderStatePaid".icanlocalized;
            stateTips = @"C2COrderStatePaidTips".icanlocalized;
        }else if ([jsonInfo.status isEqualToString:@"Appeal"]) {
            stateStr = @"C2COrderStateAppeal".icanlocalized;
            stateTips = @"C2COrderStateAppealTips".icanlocalized;
        }else if ([jsonInfo.status isEqualToString:@"Completed"]) {
            stateStr = @"C2COrderStateCompleted".icanlocalized;
            stateTips = @"C2COrderStateCompletedTips".icanlocalized;
        }else if ([jsonInfo.status isEqualToString:@"Cancelled"]) {
            stateStr = @"C2COrderStateCancelled".icanlocalized;
            stateTips = @"C2COrderStateCancelledTip".icanlocalized;
        }
        self.cmdLabel.text = stateTips;
    }else{
        self.cmdLabel.text = currentChatModel.showMessage;
    }
   
    self.timeLabel.hidden = self.jiangeView.hidden = YES;
    self.timeLabel.text = [GetTime timeStringWithTimeInterval:currentChatModel.messageTime];
}

@end
