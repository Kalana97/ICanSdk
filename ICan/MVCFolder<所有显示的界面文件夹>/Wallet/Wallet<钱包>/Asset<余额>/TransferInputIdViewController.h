//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 28/9/2021
- File name:  TransferInputIdViewController.h
- Description:转账的时候 输入ID的界面
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferInputIdViewController : QDCommonViewController
/** 默认是人命币 */
@property(nonatomic, assign) BOOL isCNY;
@property(nonatomic, strong) C2CBalanceListInfo *currencyBalanceListInfo;
@end

NS_ASSUME_NONNULL_END
