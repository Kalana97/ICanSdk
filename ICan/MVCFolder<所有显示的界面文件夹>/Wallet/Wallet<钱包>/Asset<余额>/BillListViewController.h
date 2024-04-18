//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/11/2019
- File name:  BillListViewController.h
- Description:
- Function List:
*/
        

#import "BaseTableListViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,FlowType){
    FlowTypeAll,//全部
    FlowTypeIncome,//收入
    FlowTypePay,//支出
};
@interface BillListViewController : BaseTableListViewController
@property(nonatomic, assign) FlowType flowType;
@property(nonatomic,copy) NSString *year;
@property(nonatomic,copy) NSString *month;
@property(nonatomic,assign) BOOL isFromOrganization;
@property(nonatomic,assign) BOOL isFromOrganizationAllTransactions;
@property(nonatomic,assign) NSInteger transactionStatusType;
@property(nonatomic,assign) NSInteger transactionType;
@property(nonatomic, strong) MemebersResponseInfo *memberInfo;
@property(nonatomic,copy) NSString *dataTypeTrans;
@property(nonatomic,copy) NSString *currencyType;
@property (nonatomic, assign) BOOL fromSeeMoreMy;
@end

NS_ASSUME_NONNULL_END
