//
//  ConfirmPopUp.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-08-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmPopUp : BaseViewController
@property(nonatomic, copy) void (^sureBlock)(void);
@property(nonatomic, copy) void (^noBlock)(void);
@property (nonatomic, assign) NSInteger type; //1:rejectTrns
@end

NS_ASSUME_NONNULL_END
