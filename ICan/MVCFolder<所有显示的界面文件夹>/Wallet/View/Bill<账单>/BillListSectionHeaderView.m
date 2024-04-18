//
//  BillListSectionHeaderView.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/18.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BillListSectionHeaderView.h"

@implementation BillListSectionHeaderView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)tapAction{
    !self.tapBlock?:self.tapBlock();
}

-(void)setUpView{
    self.backgroundColor = UIColor10PxClearanceBgColor;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(@10);
    }];
    
    [self addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
        make.width.equalTo(@9);
        make.height.equalTo(@5.5);
        make.centerY.equalTo(self.mas_centerY);
    }];
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel leftLabelWithTitle:@"" font:15 color:UIColorThemeMainSubTitleColor];
        NSDate * date=[GetTime dateConvertFromTimeStamp:[GetTime getCurrentTimestamp]];
        NSString *time =[GetTime stringFromDate:date withDateFormat:@"yyyy/MM"];
        _timeLabel.text = time;
    }
    return _timeLabel;
}


-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_drop_choose"]];
        
    }
    return _rightImageView;
}
@end
