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

@interface IcanWalletSelecMainNetworkView : UIView
@property(nonatomic, strong) NSArray<ICanWalletMainNetworkInfo*> *mainNetworkItems;
@property(nonatomic, copy) void (^selectBlock)(ICanWalletMainNetworkInfo*info);
-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
