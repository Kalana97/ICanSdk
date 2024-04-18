//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 27/4/2022
- File name:  C2CBillDetailViewController.h
- Description: c2c账单详情
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CBillDetailViewController : BaseViewController
@property(nonatomic, strong) C2CFlowsInfo *c2cFlowsInfo;
@property(nonatomic, strong) TransactionDataContentResponse *orgTransactionModel;
@property(nonatomic, assign) BOOL isWalletSwap;
@property(nonatomic, assign) BOOL isFromOrgDetail;
@property(nonatomic, assign) BOOL isApproved;
@end

NS_ASSUME_NONNULL_END
