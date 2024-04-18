//
//  AddAdressTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/18.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const KAddAdressTableViewCell=@"AddAdressTableViewCell";
static CGFloat const KHeightAddAdressTableViewCell = 50.0;

@interface AddAdressTableViewCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textFeild;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property(nonatomic,copy)NSString * textFeildPlacehoderText;

@property (nonatomic,copy) void(^tapBlock)(void);
@property (nonatomic,assign) BOOL canEdit;

@end

NS_ASSUME_NONNULL_END
