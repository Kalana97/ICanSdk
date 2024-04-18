//
//  APRTransactionCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-07-10.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APRTransactionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *transactionLvlLbl;
-(void)setData:(PermissionResponse *)permissionModel;
@property (nonatomic, strong) OrganizationDetailsInfo *organizationInfoModel;
@property (weak, nonatomic) IBOutlet UIView *bgCell;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (nonatomic, copy) void (^tapBlock)(NSString *);
@property(nonatomic, strong) MemebersResponseInfo *memberInfo;
@end

NS_ASSUME_NONNULL_END
