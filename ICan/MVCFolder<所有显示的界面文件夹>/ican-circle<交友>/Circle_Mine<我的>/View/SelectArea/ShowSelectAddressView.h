//
/**
- Copyright © 2021 limao01. All rights reserved.
- Author: Created  by DZL on 11/1/2021
- File name:  ShowSelectAddressView.h
- Description:显示选择地址的view
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowSelectAddressView : UIControl
@property(nonatomic, assign) AddressViewType addressViewType;
@property(nonatomic, strong) NSMutableArray<NSArray<AreaInfo*>*> *numberItems;
@property(nonatomic, strong) NSMutableArray<AreaInfo*> *selectAreaItems;
@property(nonatomic, copy) void (^successBlock)(NSArray<AreaInfo*>*selectAreaItems);
@property(nonatomic, strong) CircleUserInfo *userInfo;
/**
 确定按钮
 */
@property(nonatomic, strong) UIButton *sureBtn;
-(void)didShowSelectAddressView;
-(void)hiddenSelectAddressView;
@end

NS_ASSUME_NONNULL_END
