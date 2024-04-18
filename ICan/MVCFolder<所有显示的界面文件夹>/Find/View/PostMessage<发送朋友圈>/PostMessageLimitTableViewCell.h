//
//  PostMessageLimitTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/6.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const KPostMessageLimitTableViewCell =@"PostMessageLimitTableViewCell";

static CGFloat const KHeightPostMessageLimitTableViewCell =50.0f;

@interface PostMessageLimitTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property(nonatomic,strong)NSDictionary * dictionary;
@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,copy) void(^leftBtnBlock)(void);
@end

NS_ASSUME_NONNULL_END
