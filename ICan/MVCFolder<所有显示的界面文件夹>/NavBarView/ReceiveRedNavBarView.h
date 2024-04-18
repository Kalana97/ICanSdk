//
//  ReceiveRedNavBarView.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/2.
//  Copyright © 2020 dzl. All rights reserved.
// 红包详情

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ReceiveRedNavBarViewDelegate <NSObject>

-(void)navBarLeftReturnAction;
-(void)navBarRightMoreAction;
@end

@interface ReceiveRedNavBarView : UIView
@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic,weak) id<ReceiveRedNavBarViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
