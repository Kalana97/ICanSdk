//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  SelectTransferTypePopView.h
- Description:余额界面 点击转账
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectTransferTypePopView : UIView
- (void)hiddenView;
- (void)showView;
@property(nonatomic, copy) void (^navigateToAuth)(void);
@end

NS_ASSUME_NONNULL_END
