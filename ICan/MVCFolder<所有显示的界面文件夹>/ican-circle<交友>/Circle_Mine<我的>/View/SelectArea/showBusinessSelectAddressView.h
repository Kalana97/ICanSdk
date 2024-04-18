//
//  showBusinessSelectAddressView.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessUserResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface showBusinessSelectAddressView : UIControl
@property(nonatomic, assign) AddressViewType addressViewType;
@property(nonatomic, strong) NSMutableArray<NSArray<AreaInfo *> *> *numberItems;
@property(nonatomic, strong) NSMutableArray<AreaInfo *> *selectAreaItems;
@property(nonatomic, copy) void (^successBlock)(NSArray<AreaInfo *> *selectAreaItems);
@property(nonatomic, strong) BusinessCurrentUserInfo *userInfo;
@property(nonatomic, strong) UIButton *sureBtn;
-(void)didShowSelectAddressView;
-(void)hiddenSelectAddressView;
@end

NS_ASSUME_NONNULL_END
