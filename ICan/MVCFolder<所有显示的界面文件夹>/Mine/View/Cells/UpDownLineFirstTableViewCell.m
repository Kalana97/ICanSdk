//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 8/7/2020
- File name:  UpDownLineFirstTableViewCell.m
- Description:
- Function List:
*/
        

#import "UpDownLineFirstTableViewCell.h"

@interface UpDownLineFirstTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *separatorLineView;

@end

@implementation UpDownLineFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.xuhaoLa.textColor=UIColorThemeMainTitleColor;
    self.nicknameLa.textColor=UIColorThemeMainTitleColor;
    self.IDLa.textColor=UIColorThemeMainTitleColor;
    self.xuhaoLa.text=@"Serial number".icanlocalized;
    self.nicknameLa.text=[@"mine.profile.title.nickname" icanlocalized:@"昵称"];
    self.separatorLineView.backgroundColor = UIColor10PxClearanceBgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
