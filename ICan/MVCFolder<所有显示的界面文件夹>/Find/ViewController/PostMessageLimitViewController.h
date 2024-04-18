//
//  PostMessageLimitViewController.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/6.
//  Copyright © 2020 dzl. All rights reserved.
//  发送帖子的隐私设置

#import "QDCommonTableViewController.h"
#import "PostMessageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PostMessageLimitViewControllerDelegate <NSObject>

-(void)didChoseLimit:(NSString *)title index:(NSInteger)index choseArray:(NSArray *)choseArray;

@end

@interface PostMessageLimitViewController : QDCommonTableViewController

@property(nonatomic,copy) void(^choseLimitBlock)(NSString * title);
@property(nonatomic, strong) TimelinesListDetailInfo *timelinesListDetailInfo;
@property(nonatomic,weak) id<PostMessageLimitViewControllerDelegate> delegate;

@property(nonatomic, copy) void (^changeTimelineBlock)(TimelinesListDetailInfo *timelinesListDetailInfo);
@end

NS_ASSUME_NONNULL_END
