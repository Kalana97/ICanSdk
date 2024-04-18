//
//  MyCollectionTimelinesTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/24.
//  Copyright © 2020 dzl. All rights reserved.
//  我的收藏，朋友圈类型，有图片的

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MyCollectionTimelinesImageTableViewCellDelegate <NSObject>

-(void)showHjcActionSheetWith:(CollectionListDetailResponse *)response;

@end


static NSString * const KMyCollectionTimelinesTableViewCell =@"MyCollectionTimelinesImageTableViewCell";

@interface MyCollectionTimelinesImageTableViewCell : BaseCell
@property(nonatomic,strong) CollectionListDetailResponse * response;
@property(nonatomic,weak)id <MyCollectionTimelinesImageTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
