//
//  AssignMemberCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-07-05.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssignMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet DZIconImageView *userLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet DZIconImageView *selectImg;
@property (weak, nonatomic) IBOutlet UIView *bgCell;
@property (weak, nonatomic) IBOutlet UIView *userTypeBgView;
@property (weak, nonatomic) IBOutlet UIButton *tapBtn;
-(void)setData:(MemebersResponseInfo *) modelData;
@property(nonatomic, copy) void (^tapBlock)(void);
@end

NS_ASSUME_NONNULL_END
