//
//  PopupView.h
//  ICan
//
//  Created by Kalana Rathnayaka on 28/02/2024.
//  Copyright © 2024 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopupView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
-(void)showQRCodeView;
-(void)hiddenQRCodeView;
@end

NS_ASSUME_NONNULL_END
