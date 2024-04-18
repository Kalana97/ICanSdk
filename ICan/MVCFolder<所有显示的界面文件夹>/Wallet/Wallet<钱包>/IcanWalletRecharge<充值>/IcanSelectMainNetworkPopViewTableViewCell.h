//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 24/2/2022
- File name:  IcanSelectMainNetworkPopViewTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IcanSelectMainNetworkPopViewTableViewCell : BaseCell
@property(nonatomic, copy) void (^didSelectBlock)(void);
@property(nonatomic, strong) ICanWalletMainNetworkInfo *mainNetworkInfo;
@end

NS_ASSUME_NONNULL_END
