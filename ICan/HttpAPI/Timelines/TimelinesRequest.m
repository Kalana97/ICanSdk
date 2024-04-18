//
//  TimelinesRequest.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/9.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesRequest.h"

@implementation TimelinesRequest

@end

@implementation LocationInfo



@end

@implementation SendTimelinesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"发布朋友圈";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/timeLines"];
    
}

@end


@implementation TimelinesListRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"朋友圈（分页）";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/timeLines"];
    
}

@end

@implementation TimeLinesOpenRequest


-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"朋友圈公开的分享";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/timeLines/open/v2"];
    
}
@end
@implementation GetTimelinesAllVideoRequest


-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"朋友圈的所有视频";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/timeLines/allVideo"];
    
}

@end

@implementation TimelinesInteractiveRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"互动";
}


@end

@implementation TimelinesDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"详情";
}


@end

@implementation TimelinesSendCommentRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"评论";
}

@end


@implementation TimelinesReplyRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"回复";
}

@end


@implementation TimelinesDeleteCommentRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除评论";
}



@end

@implementation TimelinesDeleteReplyRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除回复";
}

@end


@implementation DeleteTimelinesRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除朋友圈";
}

@end

@implementation UserAllTimeLinesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"谁谁谁的朋友圈";
}


@end
@implementation TimelineLoveRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"点赞的人";
}


@end
@implementation ChangeTimelineRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"修改朋友圈";
}


@end
@implementation GetTimelineReportTypeRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"朋友圈举报类型";
}
-(NSString *)pathUrlString{
     return  [self.baseUrlString stringByAppendingString:@"/reports/reportType"];
}

@end
@implementation TimeLinesReportRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"举报朋友圈";
}


@end
@implementation ShieldTimelineRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"屏蔽/取消屏蔽好友朋友圈";
}
-(NSString *)pathUrlString{
     return  [self.baseUrlString stringByAppendingString:@"/userFriend/shield/timeline"];
}

@end
@implementation GetNextTimelineVideoRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"下一批视频";
}
@end
