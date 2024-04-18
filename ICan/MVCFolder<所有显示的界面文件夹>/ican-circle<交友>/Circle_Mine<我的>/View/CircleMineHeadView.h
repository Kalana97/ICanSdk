//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 8/7/2021
- File name:  CircleMineHeadView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleMineHeadView : UITableViewHeaderFooterView
@property(nonatomic, strong) CircleUserInfo *userInfo;
@property(nonatomic, strong) LikeMeOrMeLikeCountInfo *likeMeOrMeLikeCountInfo;
@property(nonatomic, strong) UserGoodInfo *userGoodInfo;
@property(nonatomic, copy) void (^clickEditBlock)(void);
@property(nonatomic, copy) void (^showAllBlock)(void);
@property(nonatomic, copy) void (^buyBlock)(void);
@property(nonatomic, copy) void (^editIconBlock)(void);
@property(nonatomic, copy) void (^editBgImgBlock)(void);
@property(nonatomic, copy) void (^addImageBlock)(void);
@end

NS_ASSUME_NONNULL_END
