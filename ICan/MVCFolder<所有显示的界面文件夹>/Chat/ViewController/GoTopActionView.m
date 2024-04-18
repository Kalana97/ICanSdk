//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 21/10/2021
 - File name:  GoTopActionView.m
 - Description:
 - Function List:
 */


#import "GoTopActionView.h"
@interface GoTopActionView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation GoTopActionView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.text = @"topmessage".icanlocalized;
    self.titleLabel.textColor = UIColorThemeMainColor;
    self.bgView.layer.cornerRadius = 20;
    
    self.bgView.layer.shadowColor = UIColor.grayColor.CGColor;
    //阴影偏移
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0 );
    //阴影透明度，默认0
    self.bgView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    self.bgView.layer.shadowRadius = 5;
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
