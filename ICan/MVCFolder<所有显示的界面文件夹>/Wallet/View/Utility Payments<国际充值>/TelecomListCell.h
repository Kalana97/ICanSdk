//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/4/2021
- File name:  TelecomListCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kTelecomListCell = @"TelecomListCell";
@interface TelecomListCell : BaseCell
@property(nonatomic, strong) DialogListInfo *dialogInfo;
@property(nonatomic, copy) void (^favoriteBlock)(void);
@end

NS_ASSUME_NONNULL_END
