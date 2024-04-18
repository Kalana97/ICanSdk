//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 29/9/2019
 - File name:  BaseCell.m
 - Description:
 - Function List:
 - History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
 */


#import "BaseCell.h"

@implementation BaseCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}
-(void)setUpUI{
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@0.7);
    }];
    self.contentView.backgroundColor=UIColor.whiteColor;
    self.backgroundColor=UIColor.whiteColor;
    self.multipleSelectionBackgroundView=[UIView new];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=UIColorSeparatorColor;
    }
    return _lineView;
}
@end
