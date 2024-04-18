//
//  ShowSelectTypeTableViewCell.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2024-01-03.
//  Copyright © 2024 dzl. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kShowSelectTypeTableViewCell = @"ShowSelectTypeTableViewCell";
@interface ShowSelectTypeTableViewCell : BaseCell
@property (nonatomic, strong) BusinessTypeInfo *typeInfo;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;
@end

NS_ASSUME_NONNULL_END
