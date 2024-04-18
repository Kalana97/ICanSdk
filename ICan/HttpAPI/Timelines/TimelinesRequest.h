//
//  TimelinesRequest.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/9.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimelinesRequest : BaseRequest

@end

@interface  LocationInfo: NSObject
//经度
@property(nonatomic,copy,nullable)NSString * longitude;
//纬度
@property(nonatomic,copy,nullable)NSString * latitude;
//地址
@property(nonatomic,copy,nullable)NSString * name;

@end

@interface SendTimelinesRequest : BaseRequest
//文字内容
@property(nonatomic,copy,nullable)NSString * content;
//图片内容
@property(nonatomic,strong,nullable)NSArray * imageUrls;
/** 图片宽度 */
@property(nonatomic, strong) NSNumber *width;
/** 图片高度 */
@property(nonatomic, strong) NSNumber *height;
//视频地址
@property(nonatomic,copy,nullable)NSString * videoUrl;
//朋友圈可见范围
@property(nonatomic,copy)NSString * visibleRange;
//提醒看的人
@property(nonatomic,strong,nullable)NSArray * reminders;
//部分朋友可见
@property(nonatomic,strong,nullable)NSArray * specifies;
//屏蔽的人
@property(nonatomic,strong,nullable)NSArray * shields;

//位置
@property(nonatomic,strong,nullable)LocationInfo * location;

//额外字段
@property(nonatomic,copy,nullable)NSString * ext;

//原始帖子id
@property(nonatomic,copy,nullable)NSString * sharedId;
/**
 转发的帖子，区别与sharedId（原始id）
 */
@property(nonatomic, copy,nullable) NSString *forwardId;
@end

/**
 获取的是朋友圈
 */
@interface TimelinesListRequest : ListRequest

@end
/**
 获取公开的分享
 */
@interface TimeLinesOpenRequest : BaseRequest
@property(nonatomic,strong,nullable) NSNumber *page;
@property(nonatomic,strong,nullable) NSNumber *size;
/**
 是否只是拿视频
 */
@property(nonatomic,copy,nullable)  NSString*isVideo;

@end
/**
 /timeLines/allVideo
 获取所有能看到的视频
 */

@interface GetTimelinesAllVideoRequest:ListRequest
@end

@interface TimelinesInteractiveRequest : BaseRequest

@end

/** 帖子详情 */
@interface TimelinesDetailRequest : BaseRequest

@end

@interface TimelinesSendCommentRequest : BaseRequest

@end


@interface TimelinesReplyRequest : BaseRequest

@end
//删除评论
@interface TimelinesDeleteCommentRequest : BaseRequest

@end
//删除回复
@interface TimelinesDeleteReplyRequest : BaseRequest

@end

//删除朋友圈
@interface DeleteTimelinesRequest : BaseRequest

@end

//谁谁谁的朋友圈
@interface UserAllTimeLinesRequest : ListRequest

@end

/** 点赞的人/timeLines/love/{id}
 */
@interface TimelineLoveRequest:ListRequest

@end
/** /timeLines/{id}  修改朋友圈 */
@interface ChangeTimelineRequest:BaseRequest
//文字内容
@property(nonatomic,copy,nullable)NSString * content;
//图片内容
@property(nonatomic,strong,nullable)NSArray * imageUrls;
//视频地址
@property(nonatomic,copy,nullable)NSString * videoUrl;
//朋友圈可见范围
@property(nonatomic,copy)NSString * visibleRange;
//提醒看的人
@property(nonatomic,strong,nullable)NSArray * reminders;
//部分朋友可见
@property(nonatomic,strong,nullable)NSArray * specifies;
//屏蔽的人
@property(nonatomic,strong,nullable)NSArray * shields;

//位置
@property(nonatomic,strong,nullable)LocationInfo * location;

//额外字段
@property(nonatomic,copy,nullable)NSString * ext;

//原始帖子id
@property(nonatomic,copy,nullable)NSString * sharedId;

@end

/**
 /reports/reportType
 */
@interface GetTimelineReportTypeRequest : BaseRequest

@end
/** /reports/{id}*/
@interface TimeLinesReportRequest:BaseRequest
@property(nonatomic, copy) NSString *reportType;
@property(nonatomic, copy,nullable) NSString *content;

@property(nonatomic, copy) NSString *type;
@end

/**
 屏蔽/取消屏蔽好友朋友圈
 /userFriend/shield/timeline
 */
@interface ShieldTimelineRequest : BaseRequest
@property(nonatomic, copy) NSString* userId;
/** 是否是屏蔽 */
@property(nonatomic, assign) bool unShield;
@end

/**
 /timeLines/next/{type}/{id}
 type
 类型
 open-公开的分享 other-朋友圈列表  user-某个用户的朋友圈
 id
 朋友圈id
 */
@interface GetNextTimelineVideoRequest : ListRequest
/**
 某个用户的朋友圈视频
 */
@property(nonatomic, copy,nullable) NSString *userId;
@end
NS_ASSUME_NONNULL_END
