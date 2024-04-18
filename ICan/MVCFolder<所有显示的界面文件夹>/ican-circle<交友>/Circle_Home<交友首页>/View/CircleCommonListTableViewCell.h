//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 19/5/2021
- File name:  CircleCommonListTableViewCell.h
- Description:公用的cell 例如交友首页 收藏 喜欢我的 我喜欢的页面
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kCircleCommonListTableViewCell=@"CircleCommonListTableViewCell";
@interface CircleCommonListTableViewCell : BaseCell
@property(nonatomic, assign) CircleListType circleListType;
@property(nonatomic, strong) CircleUserInfo *userInfo;
/**
 是否是主页
 */
@property(nonatomic, assign) BOOL isHome;
@end

NS_ASSUME_NONNULL_END
