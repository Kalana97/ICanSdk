//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 31/3/2020
- File name:  SendRedEnvelopeNavView.h
- Description: 发送红包的导航栏的View
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SendRedEnvelopeNavView : UIView
@property(nonatomic, copy) void (^buttonBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
