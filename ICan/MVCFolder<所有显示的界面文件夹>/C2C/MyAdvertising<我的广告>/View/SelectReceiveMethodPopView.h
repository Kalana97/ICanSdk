//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectReceiveMethodPopView : UIView
@property (weak, nonatomic) IBOutlet UIView *addWeChatBgCon;
@property (weak, nonatomic) IBOutlet UILabel *addWeChatLabel;
@property (weak, nonatomic) IBOutlet UIControl *addBankCardBgCon;
@property (weak, nonatomic) IBOutlet UILabel *addBankCardLabel;
@property (weak, nonatomic) IBOutlet UIControl *addAlipayBgCon;
@property (weak, nonatomic) IBOutlet UILabel *addAlipayLabel;
@property (weak, nonatomic) IBOutlet UIView *addCashBgCon;
@property (weak, nonatomic) IBOutlet UILabel *addCashLabel;
@property(nonatomic, copy) void (^addBankCardBlock)(void);
@property(nonatomic, copy) void (^addWeChatBlock)(void);
@property(nonatomic, copy) void (^addAlipayBlock)(void);
@property(nonatomic, copy) void (^addCashBlock)(void);

-(void)hiddenView;
-(void)showView;
@end

NS_ASSUME_NONNULL_END
