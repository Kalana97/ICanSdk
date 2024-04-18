//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/7/2021
- File name:  TimelinesCommentInfo.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>
static NSString * const KWCTimelinesCommentInfoTable= @"TimelinesCommentInfo";
@interface TimelinesCommentInfo : NSObject
@property(nonatomic, copy,nullable) NSString *ID;
//发布时间
@property(nonatomic,assign)NSInteger  publishTime;
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

//回复人id
@property(nonatomic,copy,nullable)NSString * replyToId;
//回复人昵称
@property(nonatomic,copy,nullable)NSString * replyToNickName;
//回复人头像
@property(nonatomic,copy,nullable)NSString * replyToHeadImgUrl;
//内容
@property(nonatomic,copy,nullable)NSString * content;

@property (nonatomic, copy,nullable) NSString* targetCommentId;
@property (nonatomic, copy,nullable) NSString* targetMomentId;

/** 翻译过后的文本 */
@property(nonatomic, retain,nullable) NSString *translateMsg;
/** 0 未翻译 1成功  2 失败*/
@property(nonatomic, assign) NSInteger translateStatus;


@end
