//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/11/2021
- File name:  C2CSelectLegalTenderViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CCollectLegalTenderViewController : QDCommonTableViewController
@property (nonatomic, strong) CurrencyInfo *selectCurrencyInfo;
@property(nonatomic, strong) NSArray<CurrencyInfo*> *allSupportedCurrencyItems;
@property(nonatomic, copy)   void (^selectBlock)(CurrencyInfo*info);
@property(nonatomic, copy) void (^changeBlock)(void);
@end

NS_ASSUME_NONNULL_END
