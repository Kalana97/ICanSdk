//
//  SelectTypeCollectionViewCell.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2024-01-03.
//  Copyright © 2024 dzl. All rights reserved.
//

#import "SelectTypeCollectionViewCell.h"
@interface SelectTypeCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation SelectTypeCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lineView layerWithCornerRadius:2.5 borderWidth:0 borderColor:nil];
}

-(void)setCurrentTypes:(NSArray *)currentTypes{
    _currentTypes = currentTypes;
    BOOL contain = NO;
    BusinessTypeInfo *selectInfo;
    for (BusinessTypeInfo *info in currentTypes) {
        if (info.select) {
            contain = YES;
            selectInfo = info;
            break;
        }
    }
    if (contain) {
        if (BaseSettingManager.isChinaLanguages) {
            self.titleLabel.text = selectInfo.businessType;
        }else{
            self.titleLabel.text = selectInfo.businessTypeEn;
        }
    }else{
        self.titleLabel.text = @"ShowSelectAddressView.pleasSelect".icanlocalized;
    }
}

@end
