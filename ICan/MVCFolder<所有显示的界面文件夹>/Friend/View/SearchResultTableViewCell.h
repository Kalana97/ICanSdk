//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 16/10/2019
- File name:  SearchResultTableViewCell.h
- Description: 搜索结果的cell
- Function List:
*/
        

#import "BaseCell.h"
NS_ASSUME_NONNULL_BEGIN
static NSString* const kSearchResultTableViewCell = @"SearchResultTableViewCell";
static CGFloat const kHeightSearchResultTableViewCell = 55;
@interface SearchResultTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) UserMessageInfo * userMessageInfo;
@property(nonatomic, strong) GroupListInfo *groupListInfo;
@end

NS_ASSUME_NONNULL_END
