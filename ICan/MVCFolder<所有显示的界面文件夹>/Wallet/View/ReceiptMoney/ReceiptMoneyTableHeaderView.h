//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 1/9/2020
- File name:  ReceiptMoneyTableHeaderView.h
- Description:收款页面头部视图
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReceiptMoneyTableHeaderView : UIView
/**
 点击设置金额，如果有金额那么就显示成清除金额
 */
@property(nonatomic, strong) UIButton *settingMoneyButton;
/** 自己设置的收款金额 */
@property(nonatomic, strong) UILabel *moneyLabel;
@property(nonatomic, copy) void (^settingMoneyBlock)(void);
/**
 清除金额
 */
@property(nonatomic, copy) void (^clearMoneyBlock)(void);
/**
 保存收款码
 */
@property(nonatomic, copy) void (^saveQrImageBlock)(void);

@property(nonatomic, strong) UIImageView *qrCodeImageView;
-(void)updateHasMoney;
@end

NS_ASSUME_NONNULL_END
