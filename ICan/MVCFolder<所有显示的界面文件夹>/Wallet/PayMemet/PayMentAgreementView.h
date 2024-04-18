//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 3/9/2020
- File name:  PayMentAgreementView.h
- Description:收付款协议
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayMentAgreementView : UIView
@property(nonatomic, copy) void (^agreeBlock)(void);
@end

NS_ASSUME_NONNULL_END
