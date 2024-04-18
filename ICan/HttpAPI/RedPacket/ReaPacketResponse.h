//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 1/4/2020
- File name:  ReaPacketResponse.h
- Description:
- Function List:
*/
        

#import "BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReaPacketResponse : BaseResponse

@end
/** 发送单人红包和领取单人红包返回数据  */
@interface SendSingleRedPacketInfo : IDInfo
/** 消息ID */
@property(nonatomic, copy) NSString *messageId;
@property(nonatomic, copy) NSString *code;
/** 抢到的金额 */
@property(nonatomic, copy) NSString *amount;
@property(nonatomic, assign) NSInteger status;

@end

@interface GrabSingleRedPacketInfo : SendSingleRedPacketInfo

@end

/** 发送单人红包和领取单人红包返回数据  */
@interface SendMultipleRedPacketInfo : SendSingleRedPacketInfo

@end

@interface GrabMultipleRedPacketInfo : SendSingleRedPacketInfo

@end

/** 红包详情Info */
@interface RedPacketDetailInfo : IDInfo
/** s(单人红包)/g（群红包）     */
@property(nonatomic, copy) NSString *type;
/** 红包编号     */
@property(nonatomic, copy) NSString *code;
/** 发送人id     */
@property(nonatomic, copy) NSString *sendUserId;
/** 发送人昵称     */
@property(nonatomic, copy) NSString *sendUserNickname;
/** 发送人头像     */
@property(nonatomic, copy) NSString *sendUserHeadImgUrl;
/** 发送人性别     */
@property(nonatomic, copy) NSString *sendUserGender;
/** 备注 */
@property(nonatomic, copy) NSString *comment;
/** 总金额     */
@property(nonatomic, copy) NSString *totalMoney;
/** 发包时间     */
@property(nonatomic, copy) NSString *createTime;
/** 退回时间     */
@property(nonatomic, copy) NSString *rejectTime;
/** 是否退回     */
@property(nonatomic, assign) BOOL rejected;
/** 是否完成     */
@property(nonatomic, assign) BOOL done;
/** 红包个数 */
@property(nonatomic, copy) NSString *count;
/** 红包类型（群红包）   AVERAGE(1, "均分金额红包"), RANDOM(2, "运气红包");  */
@property(nonatomic, copy) NSString *roomRedPacketType;
/** 我抢的金额     */
@property(nonatomic, copy) NSString *money;

@property(nonatomic, copy) NSString *doneTime;

@end
/** 红包详情领取人数info */
@interface RedPacketDetailMemberInfo : BaseResponse
/** <#注释#> */
@property(nonatomic, copy) NSString *grabTime;
/** <#注释#> */
@property(nonatomic, copy) NSString *money;
/** <#注释#> */
@property(nonatomic, copy) NSString *userId;
/** <#注释#> */
@property(nonatomic, copy) NSString *nickname;
/** <#注释#> */
@property(nonatomic, copy) NSString *headImgUrl;

@property(nonatomic, assign) BOOL goodLucky;
@end
/** 红包详情领取人数info */
@interface RedPacketDetailMemberListInfo : ListInfo

@end

/** 收发的红包概要 返回 */
@interface RedPacketSummaryInfo:BaseResponse
/** 数量 */
@property(nonatomic, copy) NSString *count;
/** 金钱 */
@property(nonatomic, copy) NSString *money;
/** 手气最佳 */
@property(nonatomic, copy) NSString *goodLuck;
@end

/** 发出的红包记录 */
@interface RedPacketRecordSendInfo : IDInfo
/** 金额 */
@property(nonatomic, copy) NSString *money;
/** 红包个数     */
@property(nonatomic, copy) NSString *count;
/** 类型（null 普通红包）  RANDOM   */
@property(nonatomic, copy) NSString *type;
/** 已抢个数     */
@property(nonatomic, copy) NSString *grabCount;
/** 发包时间     */
@property(nonatomic, copy) NSString *createTime;
/** 退回时间     */
@property(nonatomic, copy) NSString *rejectTime;
/** 领完时间     */
@property(nonatomic, copy) NSString *grabTime;
/** 自己添加 显示的是红包记录 发送的红包 显示的提示语 */
@property(nonatomic, copy) NSString *statesLabelText;
@end

@interface RedPacketRecordSendListInfo : ListInfo

@end
/** 收到的红包列表 里面的ID mock: s:1/g:1 */
@interface RedPacketRecordGrabInfo : IDInfo
/** 当该红包是多人红包的时候 需要利用 belongs 这个ID去查询红包详情*/
@property(nonatomic, copy) NSString *belongs;
/** 金额 */
@property(nonatomic, copy) NSString *money;
/** 类型（null 普通红包）     */
@property(nonatomic, copy) NSString *type;
/** 领取时间     */
@property(nonatomic, copy) NSString *grabTime;
@end

@interface RedPacketRecordGrabListInfo : ListInfo

@end
NS_ASSUME_NONNULL_END
