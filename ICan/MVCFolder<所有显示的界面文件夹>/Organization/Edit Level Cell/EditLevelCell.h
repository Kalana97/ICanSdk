//
//  EditLevelCell.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-26.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditLevelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgCell;
@property (weak, nonatomic) IBOutlet UILabel *levelNamLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
-(void)setData:(int)levelVal;
@property(nonatomic, copy) void (^editBlock)(void);
@property(nonatomic, copy) void (^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
