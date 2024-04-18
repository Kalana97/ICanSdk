//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/6/2020
- File name:  ShowReplyTextViewController.h
- Description: 点子回复的文字，显示文字的页面
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowReplyTextViewController : BaseViewController
@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) ReplyMessageInfo *replyMessageInfo;
@end

NS_ASSUME_NONNULL_END
