//
//  AnnouncementHelperTableViewCell.h
//  ICan
//
//  Created by Sathsara on 2022-10-04.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MesageContentModel.h"


NS_ASSUME_NONNULL_BEGIN

static NSString* const kAnnouncementHelperListTableViewCell = @"AnnouncementHelperTableViewCell";
@interface AnnouncementHelperTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *subHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIView *radousView;
@property(nonatomic, strong) ChatModel *chatModel;
@property (nonatomic,strong) NSMutableArray <MesageContentModel *>* msgContents;

@end

NS_ASSUME_NONNULL_END
