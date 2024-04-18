//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.h
- Description:自选列表头部的筛选view
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IcanTransferSelectBankCardHeadView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property(nonatomic, copy)     void (^searchDidChangeBlock)(NSString*search);
@property(nonatomic, copy) void (^tapBlock)(void);
@end

NS_ASSUME_NONNULL_END
