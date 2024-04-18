//
//  ReceiptRecordDetailTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const KReceiptRecordDetailTableViewCell =@"ReceiptRecordDetailTableViewCell";
static CGFloat const KHeightReceiptRecordDetailTableViewCell =180.0;

@interface ReceiptRecordDetailTableViewCell : UITableViewCell
@property(nonatomic, strong) ReceiveFlowsInfo *info;
@end

NS_ASSUME_NONNULL_END
