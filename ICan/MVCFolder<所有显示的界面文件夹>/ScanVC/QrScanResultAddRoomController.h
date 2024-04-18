//
//  QrScanResultAddRoomController.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/10/23.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface QrScanResultAddRoomController : BaseViewController
@property(nonatomic,copy) NSString * inviterId;
@property(nonatomic,strong) GroupListInfo*groupDetailInfo;
@property(nonatomic, assign) BOOL fromAddFriend;
@end

NS_ASSUME_NONNULL_END
