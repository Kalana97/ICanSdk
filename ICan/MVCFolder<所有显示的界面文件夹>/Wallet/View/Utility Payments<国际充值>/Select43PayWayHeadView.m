
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 6/7/2021
- File name:  Select43PayWayHeadView.m
- Description:
- Function List:
*/
        

#import "Select43PayWayHeadView.h"

@interface Select43PayWayHeadView ()
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation Select43PayWayHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.lineView.backgroundColor = UIColorSeparatorColor;
    self.backgroundColor = UIColorViewBgColor;
    self.amountLabel.textColor = UIColorThemeMainTitleColor;
}


#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

@end
