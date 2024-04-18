//
//  C2CAddCashViewController.h
//  ICan
//
//  Created by Sathsara on 2022-11-16.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface C2CAddCashViewController : UIViewController
@property(nonatomic, copy) void (^addSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
