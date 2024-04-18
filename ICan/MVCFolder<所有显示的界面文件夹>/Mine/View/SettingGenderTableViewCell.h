//
//  SettingGenderTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/10/22.
//  Copyright © 2019 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *const KSettingGenderTableViewCell = @"SettingGenderTableViewCell";
static CGFloat const KHeightSettingGenderTableViewCell =60.0;

@interface SettingGenderTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;

@end

NS_ASSUME_NONNULL_END
