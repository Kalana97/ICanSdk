//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleSelectHobbyViewController.h
- Description:选择兴趣爱好的界面
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleSelectHobbyViewController : QDCommonTableViewController
@property(nonatomic, copy) void (^selectHobbyBlock)(NSArray<HobbyTagsInfo*>*selectHobbyItems);
/** 用户已经选择的爱好 */
@property(nonatomic, strong) NSArray<HobbyTagsInfo*> *selectHobbyItems;
@end

NS_ASSUME_NONNULL_END
