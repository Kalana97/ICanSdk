//
//  TimelinesDynamicMessageTableViewCell.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-09-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "TimelinesResponse.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * const KTimelinesDynamicMessageTableViewCell = @"TimelinesDynamicMessageTableViewCell";

@interface TimelinesDynamicMessageTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet  WKWebView *webView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *firstLabelBgView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIView  * firstAllButtonView;
@property (weak, nonatomic) IBOutlet UIButton *firstLabelAllButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property(nonatomic,strong) TimeLineDynamicMessage *listRespon;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@end

NS_ASSUME_NONNULL_END
