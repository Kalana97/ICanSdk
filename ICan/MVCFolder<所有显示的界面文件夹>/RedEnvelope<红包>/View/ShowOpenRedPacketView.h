//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 1/4/2020
- File name:  ShowOpenRedPacketView.h
- Description: 显示的是开红包界面
- Function List:
*/
        

#import <UIKit/UIKit.h>
#import "WCDBManager+ChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShowOpenRedPacketView : UIView
/** 点击关闭的回调 */
@property (copy,nonatomic) void (^cancleBlock)(void);
/** 点击开的按钮的回调 */
@property (nonatomic,copy)  void (^openButtonBlock)(void);
/** 查看详情按钮点击事件的回调 */
@property (nonatomic,copy)  void (^showDetailBlock)(ChatModel*model);
/** yes单人红包 NO多人红包 */
@property (nonatomic,assign) BOOL isSingleRed;

@property(nonatomic, strong) ChatModel *model;
/** 显示 */
- (void)show;

/** 隐藏 */
- (void)hidden;
/** 没有红包 */
- (void)noEnvelope ;
/** 红包超时 */
- (void)redEnvelopeOverTime:(ChatModel*)model;
//你已经领过该红包
-(void)redHasReceived;
-(void)otherError;
@end

NS_ASSUME_NONNULL_END
