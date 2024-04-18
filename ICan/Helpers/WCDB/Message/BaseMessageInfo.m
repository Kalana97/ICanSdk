//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 26/9/2019
- File name:  NoticeMessageInfo.m
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "BaseMessageInfo.h"

@implementation BaseMessageInfo
-(NSString *)description{
    return [self mj_JSONString];
}
@end
@implementation NoticeAddGroupInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"operatore":@"operator"};
}
@end
@implementation OperatoreInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"operatore":@"operator"};
}
@end
@implementation NoticeQuitGroupInfo

@end
@implementation NoticeDeleteFriendInfo

@end
@implementation NoticeAgreeFriendInfo

@end

@implementation NoticeUpdateGroupNicknameInfo

@end

@implementation NoticeDestroyTimeInfo

@end
@implementation NoticeSubjectInfo

@end
@implementation NoticeAllShutUpInfo

@end
@implementation NoticeShowUserInfoInfo

@end
@implementation NoticeScreencastInfo

@end
@implementation NoticeLoginInfo

@end

@implementation Notice_OnlineChangeInfo

@end

@implementation ExtraInfo

@end
@implementation TextMessageInfo

@end
@implementation AtAllMessageInfo

@end
@implementation AtSingleMessageInfo

@end
@implementation FileMessageInfo

@end
@implementation VoiceMessageInfo

@end
@implementation VideoMessageInfo

@end
@implementation ImageMessageInfo

@end
@implementation LocationMessageInfo

@end
@implementation UserCardMessageInfo

@end
@implementation WithdrawMessageInfo

@end
@implementation ReceiptMessageInfo

@end
@implementation ChatGroupReceiptInfo

@end
@implementation TranferMessageInfo


@end

@implementation ChatCallMessageInfo


@end
@implementation TimeLineJsonInfo


@end

@implementation SingleRedPacketMessageInfo


@end

@implementation MultipleRedPacketMessageInfo


@end
@implementation RemoveChatMsgInfo


@end
@implementation PayHelperMsgInfo
-(NSString *)payChannelTypeName{
//    Balance,BankCard,CreditCard,AliPay,WeChatPay
//    "payChannelTypeNameBalance"="余额";
//    "payChannelTypeNameBankCard"="银行卡";
//    "payChannelTypeNameCreditCard"="信用卡";
//    "payChannelTypeNameAliPay"="支付宝";
//    "payChannelTypeNameWeChatPay"="微信";
    if ([self.payChannelType isEqualToString:@"Balance"]) {
        return @"payChannelTypeNameBalance".icanlocalized;
    }else  if ([self.payChannelType isEqualToString:@"BankCard"]) {
        return @"payChannelTypeNameBankCard".icanlocalized;
    }else  if ([self.payChannelType isEqualToString:@"CreditCard"]) {
        return @"payChannelTypeNameCreditCard".icanlocalized;
    }else  if ([self.payChannelType isEqualToString:@"AliPay"]) {
        return @"payChannelTypeNameAliPay".icanlocalized;
    }else  if ([self.payChannelType isEqualToString:@"WeChatPay"]) {
        return @"payChannelTypeNameWeChatPay".icanlocalized;
    }
    return @"payChannelTypeNameBalance".icanlocalized;
}

@end
@implementation ShopHelperMsgInfo


@end
@implementation ReplyMessageInfo


@end

@implementation BlockUserMessageInfo


@end

@implementation ShareGoodsUrlInfo


@end
@implementation ChatOtherUrlInfo


@end

@implementation Notice_TransferGroupOwnerInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"freshGroupOwner":@"newGroupOwner"};
}

@end
@implementation Notice_FreezeInfo


@end
@implementation NoticeGroupUpdateInfo


@end

@implementation Notice_PayQRInfo


@end

@implementation ChatPostShareMessageInfo


@end

@implementation Add_friend_successInfo


@end
@implementation Notice_GroupRoleUpdateInfo


@end

@implementation Notice_ReadReceiptInfo


@end

@implementation Notice_JoinGroupReviewUpdateInfo


@end

@implementation SystemHelperInfo


@end

@implementation DynamicMessageInfo

@end

@implementation C2COrderMessageInfo

@end

@implementation C2CExtRechargeWithdrawMessageInfo

@end

@implementation C2CTransferMessageInfo

@end

@implementation C2CNotifyMessageInfo

@end

@implementation NoticeOTPMessageInfo

@end

@implementation ReactionMessageInfo

@end
