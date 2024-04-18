//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 27/12/2019
- File name:  ShwoHasReadView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShwoHasReadView : UIView
@property(nonatomic, strong) NSArray *groupHasReadUserItems;
@property(nonatomic, assign) BOOL isGroup;
@property(nonatomic, copy)  NSString *groupId;
/** 点击的view相对屏幕的位置 */
@property(nonatomic, assign) CGRect convertRect;
-(void)showSurePaymentView;
-(void)hiddenSurePaymentView;
@end

NS_ASSUME_NONNULL_END
