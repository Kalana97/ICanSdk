//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 1/4/2020
- File name:  ReaPacketResponse.m
- Description:
- Function List:
*/
        

#import "ReaPacketResponse.h"

@implementation ReaPacketResponse

@end
@implementation SendSingleRedPacketInfo

@end
@implementation GrabSingleRedPacketInfo

@end
@implementation SendMultipleRedPacketInfo

@end
@implementation GrabMultipleRedPacketInfo

@end
@implementation RedPacketDetailInfo

@end
@implementation RedPacketDetailMemberInfo

@end
@implementation RedPacketDetailMemberListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[RedPacketDetailMemberInfo class]};
}

@end

@implementation RedPacketSummaryInfo

@end

@implementation RedPacketRecordSendInfo
-(NSString *)statesLabelText{
    NSString*statesText;
    if (BaseSettingManager.isChinaLanguages) {
        if (self.grabTime) {
            statesText=[NSString stringWithFormat:@"%@%@/%@个",NSLocalizedString(@"All opened", 已领完),self.count,self.count];
        }else if(self.rejectTime){
            statesText=[NSString stringWithFormat:@"%@%@/%@个",NSLocalizedString(@"Expired", 已过期),self.grabCount,self.count];
        }else{
           statesText=[NSString stringWithFormat:@"%@/%@个",self.grabCount,self.count];
        }
    }else{
    
        if (self.grabTime) {
            statesText=[NSString stringWithFormat:@"%@%@/%@",NSLocalizedString(@"All opened", 已领完),self.count,self.count];
        }else if(self.rejectTime){
            statesText=[NSString stringWithFormat:@"%@%@/%@",NSLocalizedString(@"Expired", 已过期),self.grabCount,self.count];
        }else{
            statesText=[NSString stringWithFormat:@"%@/%@",self.grabCount,self.count];
        }
    }
    return statesText;
}
@end

@implementation RedPacketRecordSendListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[RedPacketRecordSendInfo class]};
}
@end

@implementation RedPacketRecordGrabInfo

@end

@implementation RedPacketRecordGrabListInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[RedPacketRecordGrabInfo class]};
}
@end
