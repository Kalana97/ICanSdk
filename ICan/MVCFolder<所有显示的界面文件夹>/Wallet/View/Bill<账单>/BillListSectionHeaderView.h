//
//  BillListSectionHeaderView.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/18.
//  Copyright © 2019 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BillListSectionHeaderView : UIView
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIImageView * rightImageView;
@property(nonatomic,copy)void(^tapBlock)(void);
@end

NS_ASSUME_NONNULL_END
