//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 31/3/2020
- File name:  RedPacketRequest.h
- Description:
- Function List:
*/
        

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketRequest : BaseRequest

@end
/** 发送单人红包 */
@interface SendSingleRedPacketRequest : BaseRequest
@property(nonatomic, copy,nullable) NSString *to;
@property(nonatomic, copy,nullable) NSString *amount;
@property(nonatomic, copy,nullable) NSString *comment;
@property(nonatomic, copy,nullable) NSString *payPassword;
@end

/** /redEnvelopes/grab/{type}/{id}  */
@interface GrabRedPacketRequest : BaseRequest

@end

/** 发送多人红包 */
@interface SendMultipleRedPacketRequest:BaseRequest

/** 总金额 */
@property(nonatomic, copy,nullable) NSString *amount;
@property(nonatomic, copy,nullable) NSString *comment;
@property(nonatomic, copy,nullable) NSString *payPassword;
@property(nonatomic, copy,nullable) NSString *groupId;
//AVERAGE(1, "均分金额红包"),//RANDOM(2, "运气红包");
@property(nonatomic, copy,nullable) NSString *type;
/** 数量     */
@property(nonatomic, copy,nullable) NSString *count;
@end

/** 领取多人红包 /redEnvelopes/grabRoom/{id} */
@interface GrabMultipleRedPacketRequest:BaseRequest

@end

/** 红包详情 /redEnvelopes/{type}/{id} type g/s g 群红包  s 单人红包 id 红包id */
@interface RedPacketDetailRequest : BaseRequest

@end
/** 红包详情 领取列表的数据  /redEnvelopes/d/{type}/{id} type
g/s g 群红包  s 单人红包id红包id
 */
@interface RedPacketDetailMemberListRequest : ListRequest

@end


/** 收发的红包概要 /redEnvelopes/summary */
@interface RedPacketSummaryRequest:BaseRequest
/** type    是 send/grab 发/领  */
@property(nonatomic, copy) NSString *type;
/** 年份 */
@property(nonatomic, copy) NSString *year;

@end

/** 发包记录（分页）/redEnvelopes/record/send */
@interface RedPacketRecordSendListRequest:ListRequest
@property(nonatomic, copy) NSString *year;
@end

/** 收包记录（分页）/redEnvelopes/record/grab */
@interface RedPacketRecordGrabListRequest:ListRequest
@property(nonatomic, copy) NSString *year;
@end



NS_ASSUME_NONNULL_END
