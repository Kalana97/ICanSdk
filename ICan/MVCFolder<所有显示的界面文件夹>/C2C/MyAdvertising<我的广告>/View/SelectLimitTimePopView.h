//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.h
- Description:选择支付限时的View
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectLimitTimePopView : UIView
@property(nonatomic, copy) void (^selectBlock)(NSString*limitTime);
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
