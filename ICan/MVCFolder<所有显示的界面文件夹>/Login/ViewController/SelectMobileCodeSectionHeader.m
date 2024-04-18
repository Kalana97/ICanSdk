//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 26/9/2021
 - File name:  SelectMobileCodeSectionHeader.m
 - Description:
 - Function List:
 */


#import "SelectMobileCodeSectionHeader.h"
@interface SelectMobileCodeSectionHeader()
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIView *tipsBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *textField;

@end
@implementation SelectMobileCodeSectionHeader
-(void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    self.textField.textColor=UIColorThemeMainTitleColor;
    self.textField.font=[UIFont systemFontOfSize:15];
    self.textField.placeholder=NSLocalizedString(@"Search",搜索);
    self.tipsLabel.text = @"SelectMobileCodeRegisterTips".icanlocalized;
    self.tipsLabel.textColor=UIColorThemeMainTitleColor;
    self.textField.placeholderColor=UIColorThemeMainSubTitleColor;
    [self.searchBgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    self.searchBgView.backgroundColor = UIColorSearchBgColor;
    self.backgroundColor = UIColorViewBgColor;
}
-(void)searTextFieldDidChange{
    if (!self.textField.markedTextRange) {
        if (self.searchDidChangeBlock) {
            self.searchDidChangeBlock(self.textField.text);
        }
    }
}
@end
