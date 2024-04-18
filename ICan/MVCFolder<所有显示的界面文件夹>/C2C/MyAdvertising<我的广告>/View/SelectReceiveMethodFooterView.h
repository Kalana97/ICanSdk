//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodFooterView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectReceiveMethodFooterView : UITableViewHeaderFooterView
@property(nonatomic, copy) void (^addBankCardBlock)(void);
@property(nonatomic, copy) void (^addWeChatBlock)(void);
@property(nonatomic, copy) void (^addAlipayBlock)(void);
@end

NS_ASSUME_NONNULL_END
