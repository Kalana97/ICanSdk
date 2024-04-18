//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 21/4/2020
- File name:  AnnouncementToastView.h
- Description: 公告界面的展示
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnnouncementToastView : UIView
@property(nonatomic, strong) AnnouncementsInfo *announcementsInfo;
@property(nonatomic, copy) void (^closeBlock)(AnnouncementsInfo*info);
-(void)showView;
@end

NS_ASSUME_NONNULL_END
