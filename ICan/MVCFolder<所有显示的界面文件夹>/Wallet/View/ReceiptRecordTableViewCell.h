//
//  ReceiptRecordTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * const KReceiptRecordTableViewCell =@"ReceiptRecordTableViewCell";
static CGFloat const KHeightReceiptRecordTableViewCell =62.0;

@interface ReceiptRecordTableViewCell : BaseCell
@property(nonatomic, strong) ReceiveFlowsInfo *flowsInfo;
@end

NS_ASSUME_NONNULL_END
