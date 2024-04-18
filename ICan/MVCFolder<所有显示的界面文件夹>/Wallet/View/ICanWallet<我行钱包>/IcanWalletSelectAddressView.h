//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletSelectAddressView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IcanWalletSelectAddressView : UIView
@property(nonatomic, copy) void (^selectBlock)(ICanWalletAddressInfo*info);
@property(nonatomic, copy) void (^addAddressBlock)(void);
@property(nonatomic, strong) NSArray<ICanWalletAddressInfo*> *addressItems;
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
