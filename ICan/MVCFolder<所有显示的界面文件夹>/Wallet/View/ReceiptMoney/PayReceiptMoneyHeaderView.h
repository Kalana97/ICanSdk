//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/9/2020
- File name:  PayReceiptMoneyHeaderView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayReceiptMoneyHeaderView : UIView
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) void (^sureButtonBlock)(void);
@property(nonatomic, strong) QMUITextField *moneytextField;
@property(nonatomic, strong) QMUITextView *commentTextView;
@end

NS_ASSUME_NONNULL_END
