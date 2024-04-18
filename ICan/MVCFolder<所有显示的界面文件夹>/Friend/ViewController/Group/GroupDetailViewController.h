//
//  GroupDetialViewController.h
//  EasyPay
//
//  Created by young on 24/9/2019.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "BaseViewController.h"
@class  ChatModel;
NS_ASSUME_NONNULL_BEGIN

@interface GroupDetailViewController : BaseViewController
@property (nonatomic, strong) ChatModel *config;
@property (nonatomic, copy) void (^deleteSuccessBlock)(void);
@property (nonatomic, copy) void (^clickIsShowNicknameBlock)(BOOL isOn);
/// 点击了阅后即焚回调
@property (nonatomic,copy) void (^selectDestorytimeBlock)(ChatModel*model);
/// 点击了截屏通知的开关回调
@property (nonatomic,copy) void (^clickScreenNoticeBlock)(ChatModel*model);
/** at所有人回调 */
@property(nonatomic, copy) void (^atAllMemberBlock)(ChatModel*model);
@end

NS_ASSUME_NONNULL_END
