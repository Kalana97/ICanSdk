//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 31/3/2020
- File name:  RedPacketRequest.m
- Description:
- Function List:
*/
        

#import "RedPacketRequest.h"

@implementation RedPacketRequest

@end
@implementation SendSingleRedPacketRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"发送单人红包";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/redEnvelopes/sendSingle"];
    
}
@end
@implementation GrabRedPacketRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"领取红包";
}
@end
@implementation SendMultipleRedPacketRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"发送多人人红包";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/redEnvelopes/sendRoom"];
    
}
@end
@implementation GrabMultipleRedPacketRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"领取多人人红包";
}
@end
@implementation RedPacketDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"红包详情";
}
@end
@implementation RedPacketDetailMemberListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"红包详情红包领取详情（分页）领取的人";
}
@end
@implementation RedPacketSummaryRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"收发的红包概要";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/redEnvelopes/summary"];
       
}
@end
@implementation RedPacketRecordSendListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"发包记录（分页）";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/redEnvelopes/record/send"];
       
}
@end

@implementation RedPacketRecordGrabListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"收包记录（分页）";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/redEnvelopes/record/grab"];
       
}
@end
