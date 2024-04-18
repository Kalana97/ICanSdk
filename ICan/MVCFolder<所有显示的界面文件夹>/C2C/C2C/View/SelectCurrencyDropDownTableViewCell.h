//
//  SelectCurrencyDropDownTableViewCell.h
//  ICan
//  Created by Kalana Rathnayaka on 12/03/2024.
//  Copyright © 2024 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const kSelectCurrencyItemCell = @"SelectCurrencyDropDownTableViewCell";
@interface SelectCurrencyDropDownTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *currencyIcon;
@property (weak, nonatomic) IBOutlet UILabel *currencyName;
@property (weak, nonatomic) IBOutlet UIImageView *tickImage;
@property(nonatomic, copy) void (^hiddenBlock)(void);
@end

NS_ASSUME_NONNULL_END
