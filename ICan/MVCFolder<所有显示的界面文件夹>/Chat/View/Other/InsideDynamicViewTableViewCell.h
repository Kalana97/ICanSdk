//
//  InsideDynamicViewTableViewCell.h
//  ICan
//
//  Created by Kalana Rathnayaka on 06/09/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString* const kInsideDynamicListTableViewCell = @"InsideDynamicViewTableViewCell";
@interface InsideDynamicViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *topic;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@end

NS_ASSUME_NONNULL_END
