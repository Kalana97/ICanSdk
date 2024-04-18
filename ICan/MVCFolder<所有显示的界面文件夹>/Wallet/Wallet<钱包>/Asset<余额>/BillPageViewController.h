//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/2/2022
- File name:  BillPageViewController.h
- Description:
- Function List:
*/
        

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BillPageViewController : WMPageController
@property(nonatomic,copy) NSString *year;
@property(nonatomic,copy) NSString *month;
@property(nonatomic,copy) NSString *dataTypeTrans;
@property(nonatomic,copy) NSString *currencyType;
@property(nonatomic,assign) BOOL isFromOrganization;
@property(nonatomic,assign) BOOL isFromAllTransactions;
@property(nonatomic, strong) MemebersResponseInfo *memberInfo;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL fromSeeMoreMy;

-(void)reloadVc;
@end

NS_ASSUME_NONNULL_END
