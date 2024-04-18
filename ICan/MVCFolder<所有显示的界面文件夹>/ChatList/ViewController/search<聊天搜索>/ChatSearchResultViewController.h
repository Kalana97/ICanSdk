//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/1/2021
- File name:  ChatSearchResultViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonTableViewController.h"
@class ChatModel;
NS_ASSUME_NONNULL_BEGIN

@interface ChatSearchResultViewController : QDCommonTableViewController
@property(nonatomic, strong) NSArray *historyItems;
@property(nonatomic, copy)   NSString *searchText;
@end

NS_ASSUME_NONNULL_END
