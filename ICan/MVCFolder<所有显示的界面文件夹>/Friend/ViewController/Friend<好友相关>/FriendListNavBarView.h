//
/*
- TimeLineNavBarView.h
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/12/10
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendListNavBarView : UIView
@property (nonatomic, strong) IBOutlet UILabel *numberLabel;
@property(nonatomic, copy) void (^publishBlock)(void);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navbarHeight;
@property(nonatomic, copy) void (^messageBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
