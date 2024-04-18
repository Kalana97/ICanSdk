//
//  BusinessEditViewController.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusinessEditViewController : QDCommonViewController
@property(nonatomic, assign) BOOL isEidt;
@property(nonatomic, assign) AddressViewType addressViewType;
@property(nonatomic, copy) void (^editSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
