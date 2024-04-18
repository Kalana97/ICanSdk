//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 8/9/2020
- File name:  PayMentAgreementViewCell.m
- Description:
- Function List:
*/
        

#import "PayMentAgreementViewCell.h"

@implementation PayMentAgreementViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSString*path;
    if (BaseSettingManager.isChinaLanguages) {
        path=[[NSBundle mainBundle]pathForResource:@"receive" ofType:@"txt"];
    }else{
        path =[[NSBundle mainBundle]pathForResource:@"receive_en" ofType:@"txt"];
    }
    self.lineView.hidden=YES;
    self.contentLabel.text=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
