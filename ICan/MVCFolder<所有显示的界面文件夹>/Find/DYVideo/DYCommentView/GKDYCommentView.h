//
//  GKDYCommentView.h
//  GKDYVideo
//
//  Created by QuintGao on 2019/5/1.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol GKDYCommentViewDelegate <NSObject>

@optional

-(void)gkDYCommentViewDeleteCommentInfoWithtimelinesListDetailInfo:(TimelinesListDetailInfo*)timelinesListDetailInfo;

@end

@interface GKDYCommentView : UIView
@property(nonatomic, copy) void (^hiddenBlock)(void);
@property(nonatomic, strong) TimelinesListDetailInfo *timelinesListDetailInfo;
@property(nonatomic, strong) NSArray<TimelinesCommentInfo*> *commentItems;
@property(nonatomic, weak) id <GKDYCommentViewDelegate>delegate;
/** 用来保存已经请求的评论接口
 */
@property(nonatomic, strong) NSMutableDictionary * timelineComnentDict;
- (void)requestData;
-(void)removeAllData;
-(void)reloadDataFromTimelinesDetailInfo:(TimelinesDetailInfo*)timelinesDetailInfo;
-(void)fetchTimelinesDetailRequest;
@end

NS_ASSUME_NONNULL_END
