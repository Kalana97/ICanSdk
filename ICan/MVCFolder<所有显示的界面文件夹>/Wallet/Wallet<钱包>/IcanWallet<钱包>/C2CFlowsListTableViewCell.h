//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 19/1/2022
- File name:  C2CFlowsListTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kC2CFlowsListTableViewCell = @"C2CFlowsListTableViewCell";
@interface C2CFlowsListTableViewCell : BaseCell
@property(nonatomic, strong) C2CFlowsInfo *flowsInfo;
@end

NS_ASSUME_NONNULL_END
