//
//  NewWalletViewController.h
//  ICan
//
//  Created by Kalana Rathnayaka on 01/03/2024.
//  Copyright © 2024 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewWalletViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIControl *trcBtn;
@property (weak, nonatomic) IBOutlet UIControl *ercBtn;
@property (weak, nonatomic) IBOutlet UIImageView *trcPlusIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ercPlusIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UIView *marketView;
@end

NS_ASSUME_NONNULL_END
