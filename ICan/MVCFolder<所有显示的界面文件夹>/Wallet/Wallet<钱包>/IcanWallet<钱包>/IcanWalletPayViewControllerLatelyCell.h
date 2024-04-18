//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 19/1/2022
- File name:  IcanWalletPayViewControllerLatelyCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kIcanWalletPayViewControllerLatelyCell = @"IcanWalletPayViewControllerLatelyCell";
@interface IcanWalletPayViewControllerLatelyCell : BaseCell
@property(nonatomic, strong) C2CFlowsInfo *info;
@end

NS_ASSUME_NONNULL_END
