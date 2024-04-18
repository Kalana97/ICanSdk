//
//  AddFriendDefaultTableViewCell.m
//  OneChatAPP
//
//  Created by mac on 2016/11/23.
//  Copyright © 2016年 DW. All rights reserved.
//

#import "AddFriendDefaultTableViewCell.h"

@interface AddFriendDefaultTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (strong,nonatomic) UIView * lineView;

@end

@implementation AddFriendDefaultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.titleLB.textColor= UIColorThemeMainTitleColor;
    self.desLB.textColor=UIColorThemeMainSubTitleColor;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.lineView.backgroundColor = UIColorSeparatorColor;
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.3);
        make.bottom.equalTo(@0);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
    }];    
}
-(void)setImageSettingItem:(ImageSettingItem *)imageSettingItem{
    _imageSettingItem=imageSettingItem;
    self.iconView.image=[UIImage imageNamed:imageSettingItem.imgUrl];
    self.titleLB.text=imageSettingItem.leftTitle;
    self.desLB.text=imageSettingItem.rightTitle;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
        
    }
    return _lineView;
}


@end
