//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2021
- File name:  C2CMyAdvertisingListTableViewCell.h
- Description: 我的广告
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kC2CMyAdvertisingListTableViewCell = @"C2CMyAdvertisingListTableViewCell";
@interface C2CMyAdvertisingListTableViewCell : BaseCell
@property(nonatomic, copy) void (^switchBlock)(BOOL open);
@property (nonatomic, strong) C2CAdverInfo *adverInfo;
@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;
@end

NS_ASSUME_NONNULL_END
