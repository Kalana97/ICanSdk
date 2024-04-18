//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletTransferTableCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kIcanWalletTransferTableCell = @"IcanWalletTransferTableCell";
static CGFloat const kheightIcanWalletTransferTableCell = 60;
@interface IcanWalletTransferTableCell : BaseCell
@property(nonatomic, strong) UserMessageInfo *historyInfo;
@property(nonatomic, assign) BOOL recentTransactions;
@property(nonatomic, assign) BOOL shoulShowAddFriend;
@property (nonatomic, copy) void (^addBlock)(UserMessageInfo*userMessageInfo);
@end

NS_ASSUME_NONNULL_END
