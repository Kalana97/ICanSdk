//
//  TimelinesResponse.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/9.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseResponse.h"
@class TimelinesCommentInfo;
NS_ASSUME_NONNULL_BEGIN

@interface TimelinesResponse : BaseResponse

@end

@interface SharedMessageInfo : IDInfo
@property(nonatomic, assign) NSInteger width;

@property(nonatomic, assign) NSInteger height;
//发布的人id
@property(nonatomic,copy,nullable)NSString * belongsId;
//发布的人头像
@property(nonatomic,copy,nullable)NSString * headImgUrl;
//昵称
@property(nonatomic,copy,nullable)NSString * nickName;

//发布时间
@property(nonatomic,copy,nullable)NSString * publishTime;

//文字内容
@property(nonatomic,copy,nullable)NSString * content;
//图片内容
@property(nonatomic,strong,nullable)NSArray * imageUrls;
//视频地址
@property(nonatomic,copy,nullable)NSString * videoUrl;
//朋友圈可见范围
@property(nonatomic,copy,nullable)NSString * visibleRange;
//性别
@property(nonatomic,copy,nullable)NSString *gender;

//位置
@property(nonatomic,strong,nullable)LocationInfo * location;
//额外字段
@property(nonatomic,copy,nullable)NSString * ext;
//
@property(nonatomic,copy,nullable)NSString * sharedId;

@end

@interface TimelinesListDetailInfo : BaseResponse
/** 帖子id  */
@property (nonatomic,copy,nullable) NSString * ID;

//发布的人id
@property(nonatomic,copy,nullable)NSString * belongsId;
//发布的人头像
@property(nonatomic,copy,nullable)NSString * headImgUrl;
//昵称
@property(nonatomic,copy,nullable)NSString * nickName;

//发布时间
@property(nonatomic,assign)NSInteger  publishTime;

//文字内容
@property(nonatomic,copy,nullable)NSString * content;
//图片内容
@property(nonatomic,strong,nullable)NSArray * imageUrls;
//视频地址
@property(nonatomic,copy,nullable)NSString * videoUrl;

//性别
@property(nonatomic,copy,nullable)NSString *gender;
/** 提醒阅读的对象(@/提到的用户)
 */
@property(nonatomic, strong) NSArray *reminders;
/**
 屏蔽的阅读的对象（除了这些好友）
 */
@property(nonatomic, strong) NSArray *shields;
/** 指定的阅读对象
 */
@property(nonatomic, strong) NSArray *specifies;

/*朋友圈可见范围公开Open,仅自己可见OnlyMyself,好友AllFriend指定好SomeFriends,除了这些好友ExceptSomeFriends
 */
@property(nonatomic,copy,nullable)NSString * visibleRange;
@property(nonatomic, assign) NSInteger width;
@property(nonatomic, assign) NSInteger height;
//位置
@property(nonatomic,strong,nullable)LocationInfo * location;
/** 是否评论 */
@property(nonatomic, assign) BOOL comment;
//评论条数
@property(nonatomic,assign)NSInteger  commentNum;
//点赞条数
@property(nonatomic,assign)NSInteger  loveNum;
//是否点赞
@property(nonatomic,assign) BOOL love;
/** 转发数量 */
@property(nonatomic, assign) NSInteger forwardNum;
/** 举报数
 */
@property(nonatomic, assign)       NSInteger  reportNum;
//额外字段
@property(nonatomic,copy,nullable) NSString * ext;
//
@property(nonatomic,copy,nullable) NSString * sharedId;

@property(nonatomic,strong)  SharedMessageInfo * sharedMessage;

@property(nonatomic, assign) BOOL showLookGoodsLabel;
//自己添加的属性
//发表的文字的总高度
@property(nonatomic, assign) CGFloat originContentHeight;
@property(nonatomic, assign) CGFloat contentHeight;
//原来的分享的总高度
@property(nonatomic, assign) CGFloat originShareContentHeight;
@property(nonatomic, assign) CGFloat shareContentHeight;
@property(nonatomic, assign) CGFloat oneImageHeight;


@property(nonatomic, copy)   NSMutableAttributedString *contenttextAttributedString;
@property(nonatomic, copy)   NSMutableAttributedString *shareContenttextAttributedString;

/** 保存的是被@的人的昵称数组 */
@property(nonatomic, strong) NSArray *atPeopleItems;
/** 保存的是被@的人的昵称 和ID的字典  k:v */
@property(nonatomic, strong) NSArray *atDictItems;
@property(nonatomic, copy)   NSMutableAttributedString *contentLabelAttString;
/** 保存的是被分享的帖子 被@的人的昵称数组 */
@property(nonatomic, strong) NSArray *atSharePeopleItems;
/** 保存的是被分享的帖子 @的人的昵称 和ID的字典  k:v */
@property(nonatomic, strong) NSArray *atShareDictItems;
@property(nonatomic, copy)   NSMutableAttributedString *shareContentLabelAttString;

/** 是否显示全文按钮 */
@property(nonatomic, assign) BOOL showAllButton;
/** 是否点击显示全文按钮 */
@property(nonatomic, assign) BOOL clickShowAllButton;
/** 是否显示全文按钮 */
@property(nonatomic, assign) BOOL showShareAllButton;
/** 是否点击显示分享的全文按钮 */
@property(nonatomic, assign) BOOL clickShareShowAllButton;
@property(nonatomic, copy)   NSString *visibleRangeImgStr;
-(void)cacheCellHeightWith;
-(void)cacheTimeLineDetailHeight;
@end

@interface DynamicMessageDataList : NSObject
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy, nullable)   NSString *imageURL;
@property (nonatomic, copy, nullable)   NSString *onclickData;
@property (nonatomic, copy, nullable)   NSString *onclickFunction;
@property (nonatomic, copy, nullable)   NSString *title;
@end

@interface DynamicMessageLanguage : NSObject
@property (nonatomic, copy, nullable)   NSString *code;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, copy, nullable)   NSString *name;
@property (nonatomic, copy, nullable)   NSString *nameCN;
@property (nonatomic, copy, nullable)   NSString *nameEn;
@end

@interface TimeLineDynamicMessage : NSObject
@property (nonatomic, copy, nullable)   NSArray<DynamicMessageDataList *> *dataList;
@property (nonatomic, copy, nullable)   NSString *headerImgURL;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger merchantId;
@property (nonatomic, strong, nullable) DynamicMessageLanguage *language;
@property (nonatomic, copy, nullable)   NSString *messageData;
@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic, copy, nullable)   NSString *onclickData;
@property (nonatomic, copy, nullable)   NSString *onclickFunction;
@property (nonatomic, copy, nullable)   NSString *sender;
@property (nonatomic, copy, nullable)   NSString *senderImgURL;
@property (nonatomic, copy, nullable)   NSString *showType;
@property (nonatomic, assign)   NSInteger showTime;
@property (nonatomic, copy, nullable)   NSString *title;
@end

@interface TimelineContentInfo : NSObject
@property(nonatomic,strong,nullable) TimeLineDynamicMessage *dynamicMessage;
@property(nonatomic,strong,nullable) TimelinesListDetailInfo *timeLinePageVO;
@property (nonatomic, assign) NSInteger type;
@end

@interface TimelinesListInfo : ListInfo


@end

@interface TimeLinesNonDynamicListInfo : ListInfo


@end

@interface ReplyVOsInfo : IDInfo

//发布时间
@property(nonatomic,assign) NSInteger publishTime;
//发布人id
@property(nonatomic,copy,nullable)NSString * belongsId;
//发布人昵称
@property(nonatomic,copy,nullable)NSString * belongsNickName;
//发布人头像
@property(nonatomic,copy,nullable)NSString * belongsHeadImgUrl;
//性别
@property(nonatomic,copy,nullable)NSString *belongsGender;

//性别
@property(nonatomic,copy,nullable)NSString *replyToGender;

//被回复人id
@property(nonatomic,copy,nullable)NSString * replyToId;
//被回复人昵称
@property(nonatomic,copy,nullable)NSString * replyToNickName;
//被回复人头像
@property(nonatomic,copy,nullable)NSString * replyToHeadImgUrl;
//内容
@property(nonatomic,copy,nullable)NSString * content;

@end




@interface TimelinesDetailInfo : BaseResponse

@property (nonatomic,strong)TimelinesListDetailInfo * timeLine;
@property (nonatomic,strong)NSArray <TimelinesCommentInfo*>*comments;
@end

/** 点赞的人列表 */
@interface TimelineLoveInfo : IDInfo
@property(nonatomic, copy) NSString *headImgUrl;
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *gender;
@end
/** 举报返回的type */
@interface TimelinesReportInfo:BaseResponse
@property(nonatomic, copy) NSString *key;
@property(nonatomic, copy) NSString *value;
@end

NS_ASSUME_NONNULL_END
