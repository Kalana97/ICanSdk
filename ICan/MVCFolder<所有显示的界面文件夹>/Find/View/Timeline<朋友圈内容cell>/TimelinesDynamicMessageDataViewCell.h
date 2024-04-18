//
//  TimelinesDynamicMessageDataViewCell.h
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-09-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const KTimelinesDynamicMessageDataViewCell = @"TimelinesDynamicMessageDataViewCell";
@interface TimelinesDynamicMessageDataViewCell : BaseCell
@property (nonatomic, copy, nullable)  DynamicMessageDataList *dataList;
@property (weak, nonatomic) IBOutlet UIImageView *dataListImg;
@property (weak, nonatomic) IBOutlet UILabel *dataListTitle;
@property (weak, nonatomic) IBOutlet UIView *cellViewContainer;
@property (weak, nonatomic) IBOutlet UIStackView *cellcontentStack;
@property (weak, nonatomic) IBOutlet UILabel *dataListSubTitle;
@property (weak, nonatomic) IBOutlet UIView *dataListImgContainer;
@end

NS_ASSUME_NONNULL_END
