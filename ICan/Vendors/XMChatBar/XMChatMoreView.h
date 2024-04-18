//
//  XMChatMoreView.h
//  XMChatBarExample
//
//  Created by shscce on 15/8/18.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  moreItem类型
 */
typedef NS_ENUM(NSUInteger, XMChatMoreItemType){
    XMChatMoreItemPicture  = 0 /**< 图片 */,
    XMChatMoreItemTransfer = 1 /**< 转账 */,
    XMChatMoreItemSendRedEnvelope = 2/**< 发redPacket */,
    XMChatMoreItemVideo = 3 /**< 视频 */,
    XMChatMoreItemVoice = 4  /*  语音 */,
    XMChatMoreItemCollection = 5   /*  收藏 */,
    XMChatMoreItemFace = 6  /**< 表情 */,
    XMChatMoreItemGrapRedEnvelope = 7  /**< 抢redPacket */,
    XMChatMoreItemLocation = 8 /**< 显示地理位置 */,
    XMChatMoreItemCamera = 9 /**< 拍照 */,
    XMChatMoreItemUserBalance = 10 /**< 用户余额 */,
    XMChatMoreItemTurnTableGame = 11 /**< 大轮盘 */,
    XMChatMoreItemUserVcard = 12/**< 发送用户的名片 */,
    XMChatMoreItemPaoMoney = 13/**< 泡币 */,
    XMChatMoreItemPaoFile = 14/**< 文件 */,
    XMChatMoreItemChouJiang = 15/**< 幸运d抽奖 */,
    XMChatMoreItemKeFuChongZhi = 16/**< 客服充值 */,
    XMChatMoreItemPaiXingBang = 17/**< 排行榜*/,
    XMChatMoreItemJinQiang5 = 18/**< 禁抢5*/,
    XMChatMoreItemJinQiang6 = 19/**< 禁抢6*/,
    XMChatMoreItemDuoLeiEnvelope = 20/**< 多雷红包*/,
    XMChatMoreItemUSDTransfer = 21/**< 发送用户的名片 */,
    XMChatMoreItemDiceGame = 22/**<dicegame*/,
};

@protocol XMChatMoreViewDataSource;
@protocol XMChatMoreViewDelegate;
/**
 *  更多view
 */
@interface XMChatMoreView : UIView

@property (weak, nonatomic) id<XMChatMoreViewDelegate> delegate;
@property (weak, nonatomic) id<XMChatMoreViewDataSource> dataSource;

@property (assign, nonatomic) NSUInteger numberPerLine;
@property (assign, nonatomic) UIEdgeInsets edgeInsets;

- (void)reloadData;

@end


@protocol XMChatMoreViewDelegate <NSObject>

@optional
/**
 *  moreView选中的index
 *
 *  @param moreView 对应的moreView
 */
- (void)moreView:(XMChatMoreView *)moreView selectIndex:(XMChatMoreItemType)itemType;

@end

@protocol XMChatMoreViewDataSource <NSObject>

@optional



- (NSArray *)titlesOfMoreView:(XMChatMoreView *)moreView;


- (NSArray *)imageNamesOfMoreView:(XMChatMoreView *)moreView;



- (NSArray *)itemIndexOfMoreView:(XMChatMoreView *)moreView;

#pragma mark == 替代上面的三个代理方法 ==

@required

- (NSArray *)itemsOfMoreView:(XMChatMoreView *)moreView;

@end
