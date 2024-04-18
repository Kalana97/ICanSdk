//
//  VerifyOTPVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-05-11.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VerifyOTPVC : UIViewController
@property (nonatomic, copy) void (^addBlock)(NSString *otp);
@end

NS_ASSUME_NONNULL_END
