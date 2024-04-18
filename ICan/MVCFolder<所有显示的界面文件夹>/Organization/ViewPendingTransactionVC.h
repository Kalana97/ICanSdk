//
//  ViewPendingTransactionVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewPendingTransactionVC : BaseViewController <QMUITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fromLbl;
@property (weak, nonatomic) IBOutlet UILabel *amtLbl;
@property (weak, nonatomic) IBOutlet UILabel *toLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *approveBtn;
@property (weak, nonatomic) TransactionDataContentResponse *model;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet QMUITextView *remarkText;
@property (weak, nonatomic) IBOutlet UILabel *fromTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *amtTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *toTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *transTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateTypelbl;
@property (weak, nonatomic) IBOutlet UILabel *noteTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *desctypeLbl;
@end

NS_ASSUME_NONNULL_END
