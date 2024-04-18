//
//  UnFriendHeaderTipsView.h
//  CaiHongApp
//
//  Created by young on 10/6/2019.
//  Copyright © 2019 LIMAOHUYU. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const KHeightUnFriendHeaderTipsView=30;

@interface UnFriendHeaderTipsView : UIView
@property (nonatomic,strong) DZIconImageView * imageView;
@property (nonatomic,copy) void (^addFriendBlock)(void);
@property (nonatomic,strong) UILabel *tipsLabel;
@property (nonatomic,strong) UIButton * addFriendBtn;

@end


