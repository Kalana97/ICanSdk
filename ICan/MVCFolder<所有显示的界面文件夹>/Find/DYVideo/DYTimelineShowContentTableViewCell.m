//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 13/8/2020
- File name:  DYTimelineShowContentTableViewCell.m
- Description:
- Function List:
*/
        

#import "DYTimelineShowContentTableViewCell.h"
#import "XMFaceManager.h"
@implementation DYTimelineShowContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.textColor=UIColor252730Color;
    self.lineView.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)setTimelinesListDetailInfo:(TimelinesListDetailInfo *)timelinesListDetailInfo{
    NSMutableAttributedString *textAttributedString = [XMFaceManager emotionStrWithString:timelinesListDetailInfo.content];
      [textAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f*ADAPTATIONRATIO] range:NSMakeRange(0, textAttributedString.length)];
    [textAttributedString addAttribute:NSForegroundColorAttributeName value:UIColor252730Color range:NSMakeRange(0, textAttributedString.length)];
    self.contentLabel.attributedText=textAttributedString ;
}
@end
