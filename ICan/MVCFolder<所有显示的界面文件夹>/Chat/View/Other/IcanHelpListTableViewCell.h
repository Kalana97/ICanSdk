//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 6/5/2020
- File name:  IcanHelpListTableViewCell.h
- Description:支付助手相关的cell
- Function List:
*/
        

#import "BaseCell.h"
#import "WCDBManager+ChatModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString* const kIcanHelpListTableViewCell = @"IcanHelpListTableViewCell";
static CGFloat const KHeightIcanHelpListTableViewCell = 280;
@interface IcanHelpListTableViewCell : BaseCell
@property(nonatomic, strong) ChatModel *chatModel;
@property(nonatomic, copy) void (^deleteBlock)(ChatModel*model);
@end

NS_ASSUME_NONNULL_END
