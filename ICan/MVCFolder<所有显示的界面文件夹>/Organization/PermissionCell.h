//
//  PermissionCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-26.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PermissionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgCell;
@property (weak, nonatomic) IBOutlet DZIconImageView *permissionLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *permissionTypeLbl;
@property (weak, nonatomic) IBOutlet DZIconImageView *isSelectBtn;
@property(nonatomic, copy) void (^tapBlock)(void);
-(void)setData:(PermissionResponse *)modelData;
@end

NS_ASSUME_NONNULL_END
