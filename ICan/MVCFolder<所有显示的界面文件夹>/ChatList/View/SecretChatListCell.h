
#import <UIKit/UIKit.h>
#import "BaseCell.h"
@class ChatListModel;
@class ChatModel;
static NSString* const kSecretChatListCell = @"SecretChatListCell";
static CGFloat const kSecretChatListCellHeight = 80;
@interface SecretChatListCell : BaseCell
@property (nonatomic, strong) ChatListModel *chatListModel; //消息模型

@end
