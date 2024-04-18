//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/9/2021
- File name:  WalletViewHeadView.h
- Description:我行钱包转账头部视图
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletTransferHeadView : UITableViewHeaderFooterView
@property(nonatomic, copy) void (^sureBlcok)(NSString*type,NSString*account,NSString*mobileCode);
@property(nonatomic, weak) IBOutlet UILabel *nearyLabel;
@end

NS_ASSUME_NONNULL_END
