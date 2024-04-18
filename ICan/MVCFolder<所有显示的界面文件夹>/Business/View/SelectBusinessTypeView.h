//
//  SelectBusinessTypeView.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2024-01-02.
//  Copyright © 2024 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessUserResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectBusinessTypeView : UIControl
@property (nonatomic, strong) NSMutableArray<NSArray<BusinessTypeInfo  *> *> *numberItems;
@property (nonatomic, strong) NSMutableArray<BusinessTypeInfo *> *selectBusinessTypes;
@property (nonatomic, copy) void (^successBlock)(NSArray<BusinessTypeInfo *> *selectTypes);
@property (nonatomic, strong) BusinessCurrentUserInfo *userInfo;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, assign) NSInteger typeId;
-(void)didShowSelectAddressView;
-(void)hiddenSelectAddressView;
@end

NS_ASSUME_NONNULL_END
