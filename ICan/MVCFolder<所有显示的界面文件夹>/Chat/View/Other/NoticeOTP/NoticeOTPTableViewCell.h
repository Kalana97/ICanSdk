//
//  NoticeOTPTableViewCell.h
//  ICan
//
//  Created by MAC on 2023-05-11.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString* const kNoticeOTPTableViewCell = @"NoticeOTPTableViewCell";
@interface NoticeOTPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *urlImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *cradView;
@property (nonatomic, strong) ChatModel *chatModel;
@end
NS_ASSUME_NONNULL_END
