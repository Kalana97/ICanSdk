//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 6/4/2022
- File name:  SelectBuyerComplaintPopView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectBuyerComplaintPopView : UIControl
+(instancetype)showBuyerComplaintView;
@property(nonatomic, copy) void (^tapBblock)(NSString*reason);
///自己是不是卖家
@property(nonatomic, assign) BOOL isSeller;
@end

NS_ASSUME_NONNULL_END
