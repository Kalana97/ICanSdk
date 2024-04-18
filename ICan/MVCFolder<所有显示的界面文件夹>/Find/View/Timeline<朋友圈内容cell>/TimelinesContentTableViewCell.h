//
//  TimelinesNoneImageTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/5.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const KTimelinesContentTableViewCell =@"TimelinesContentTableViewCell";

@interface TimelinesContentTableViewCell : BaseCell
@property(nonatomic,weak)  IBOutlet UIImageView * firstImageView;
@property(nonatomic,copy) void(^tapBlock)(NSInteger index);
@property(nonatomic,copy) void(^topRightBlock)(void);
@property(nonatomic,copy)  void(^lookPictureBlock)(NSInteger index);
@property(nonatomic,strong) TimelinesListDetailInfo * listRespon;
-(void)clickLikeButtonAction;
@end

NS_ASSUME_NONNULL_END
