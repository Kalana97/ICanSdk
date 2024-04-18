//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2021
- File name:  C2CMyAdvertisingViewController.h
- Description:
- Function List:
*/
        

#import "C2CBaseTableListViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger,AdvertisingViewType){
    AdvertisingViewTypeMine,///我的广告
    AdvertisingViewTypeOnLineSell,///在线出售
    AdvertisingViewTypeOnLineBuy,///在线购买
};
@interface C2CMyAdvertisingViewController : C2CBaseTableListViewController
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, assign) AdvertisingViewType type;
/** 是否 返回到根控制器 */
@property(nonatomic, assign) BOOL shoulPopToRoot;
@end

NS_ASSUME_NONNULL_END
