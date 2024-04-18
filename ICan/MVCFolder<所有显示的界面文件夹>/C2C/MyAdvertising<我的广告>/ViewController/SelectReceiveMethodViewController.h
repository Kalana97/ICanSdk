//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodViewController.h
- Description:发布广告的时候 选择收款方式
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SelectReceiveMethodType){
    SelectReceiveMethodType_Mine,//从我的界面进来
    SelectReceiveMethodType_Sale,//从我要卖界面进来 选择自己的收款方式
    SelectReceiveMethodType_PublishAdver,///发布广告
};
@interface SelectReceiveMethodViewController : QDCommonTableViewController
@property(nonatomic, assign) SelectReceiveMethodType type;
@property(nonatomic, strong) C2CAdverInfo *adverDetailInfo;
@property(nonatomic, copy) void (^selectReceiveMethodBlock)(C2CPaymentMethodInfo*info);
@property(nonatomic, strong) CurrencyInfo *currentCurrencyInfo;
@end

NS_ASSUME_NONNULL_END
