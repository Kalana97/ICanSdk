//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 31/3/2020
- File name:  RedPacketContentImageView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>
@class ChatModel;
NS_ASSUME_NONNULL_BEGIN

@interface RedPacketContentImageView : UIImageView
@property(nonatomic, strong) ChatModel *chatModel;
@end

NS_ASSUME_NONNULL_END
