//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  ExchangeCurrencyListHead.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeCurrencyListHead : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic, copy) void (^selectCurrencyBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *targetCurrencyLab;
@end

NS_ASSUME_NONNULL_END
