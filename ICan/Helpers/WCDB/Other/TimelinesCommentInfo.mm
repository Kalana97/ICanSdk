//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/7/2021
- File name:  TimelinesCommentInfo.mm
- Description:
- Function List:
*/
        

#import "TimelinesCommentInfo+WCTTableCoding.h"
#import "TimelinesCommentInfo.h"
#import <WCDB/WCDB.h>

@implementation TimelinesCommentInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
WCDB_IMPLEMENTATION(TimelinesCommentInfo)
WCDB_PRIMARY(TimelinesCommentInfo,ID)
WCDB_SYNTHESIZE(TimelinesCommentInfo, ID)
WCDB_SYNTHESIZE(TimelinesCommentInfo, publishTime)
WCDB_SYNTHESIZE(TimelinesCommentInfo, belongsId)
WCDB_SYNTHESIZE(TimelinesCommentInfo, belongsNickName)
WCDB_SYNTHESIZE(TimelinesCommentInfo, belongsHeadImgUrl)
WCDB_SYNTHESIZE(TimelinesCommentInfo, belongsGender)
WCDB_SYNTHESIZE(TimelinesCommentInfo, replyToGender)
WCDB_SYNTHESIZE(TimelinesCommentInfo, replyToId)
WCDB_SYNTHESIZE(TimelinesCommentInfo, replyToNickName)
WCDB_SYNTHESIZE(TimelinesCommentInfo, replyToHeadImgUrl)
WCDB_SYNTHESIZE(TimelinesCommentInfo, content)
WCDB_SYNTHESIZE(TimelinesCommentInfo, targetCommentId)
WCDB_SYNTHESIZE(TimelinesCommentInfo, targetMomentId)
WCDB_SYNTHESIZE(TimelinesCommentInfo, translateMsg)
//设置一个默认值
WCDB_SYNTHESIZE_DEFAULT(TimelinesCommentInfo, translateStatus, 2)
@end

