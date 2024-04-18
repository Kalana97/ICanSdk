//
//  ShowSelectTypeTableViewCell.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2024-01-03.
//  Copyright © 2024 dzl. All rights reserved.
//

#import "ShowSelectTypeTableViewCell.h"

@interface ShowSelectTypeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation ShowSelectTypeTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
}

-(void)setTypeInfo:(BusinessTypeInfo *)typeInfo{
    _typeInfo = typeInfo;
    if (BaseSettingManager.isChinaLanguages) {
        self.titleLabel.text = typeInfo.businessType;
    }else{
        self.titleLabel.text = typeInfo.businessTypeEn;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
