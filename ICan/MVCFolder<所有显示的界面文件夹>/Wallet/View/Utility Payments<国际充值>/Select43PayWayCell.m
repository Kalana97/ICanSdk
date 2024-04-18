
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 6/7/2021
- File name:  Select43PayWayCell.m
- Description:
- Function List:
*/
        

#import "Select43PayWayCell.h"

@interface Select43PayWayCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation Select43PayWayCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.titleLabel.textColor = UIColorThemeMainTitleColor;
    [self.selectBtn setBackgroundImage:UIImageMake(@"icon_circle_select") forState:UIControlStateSelected];
    [self.selectBtn setBackgroundImage:UIImageMake(@"icon_circle_unSelect") forState:UIControlStateNormal];
}

-(void)setInfo:(QuickPayInfo *)info{
    _info=info;
    self.titleLabel.text=info.bankNum;
    self.selectBtn.selected=info.select;
}
- (IBAction)selectBtnAction:(id)sender {
    if (self.selectBlock) {
        self.selectBlock();
    }
}
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

@end
