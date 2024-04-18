//
//  NoticeOTPTableViewCell.m
//  ICan
//
//  Created by MAC on 2023-05-11.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "NoticeOTPTableViewCell.h"
#import "ChatModel.h"

@implementation NoticeOTPTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Set preferredMaxLayoutWidth to the label to allow multi-line auto layout
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
    [self.cradView layerWithCornerRadius:10 borderWidth:0.5 borderColor:UIColor.clearColor];
}

- (void)layoutSubviews {
   [super layoutSubviews];
   
   // Invalidate the layout when the cell's layout changes
   [self.contentView layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setChatModel:(ChatModel *)chatModel {
    _chatModel = chatModel;
    NoticeOTPMessageInfo *noticeOTPMessageInfo = [NoticeOTPMessageInfo mj_objectWithKeyValues: _chatModel.messageContent];
    self.urlImageView.hidden = YES;
    self.appNameLabel.text = noticeOTPMessageInfo.appName;
    NSString *verificationCode = noticeOTPMessageInfo.otp;
    NSString *string = noticeOTPMessageInfo.content;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange codeRange = [string rangeOfString:verificationCode];
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blueColor]} range:codeRange];
    self.contentLabel.attributedText = attributedString;
    self.timeLabel.text = [GetTime convertDateWithString:chatModel.messageTime dateFormmate:@"yyyy-MM-dd HH:mm:ss"];
}

@end
