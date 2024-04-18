//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 8/11/2021
- File name:  FriendListTableViewHeaderView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendListTableViewHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *groupNoticeUnReadLab;
@property (weak, nonatomic) IBOutlet UILabel *friendUnReadLab;
@property(nonatomic, copy)   void (^searchDidChangeBlock)(NSString*search);
@property(nonatomic, copy)   void (^friendBlock)(void);
@property(nonatomic, copy)   void (^groupNoticeBlock)(void);
@end

NS_ASSUME_NONNULL_END
