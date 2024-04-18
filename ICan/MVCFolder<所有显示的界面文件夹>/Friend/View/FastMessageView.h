//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 3/9/2021
- File name:  FastMessageView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FastMessageView : UIView
@property(nonatomic, copy) void (^sendFastMessageBlock)(NSString*msg);
@property(nonatomic, strong) NSArray<QuickMessageInfo*> *msgItems;
@end

NS_ASSUME_NONNULL_END
