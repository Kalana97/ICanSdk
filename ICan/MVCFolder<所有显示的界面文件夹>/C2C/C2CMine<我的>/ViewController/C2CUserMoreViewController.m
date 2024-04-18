//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 2/12/2021
- File name:  C2CUserMoreViewController.m
- Description:
- Function List:
*/
        

#import "C2CUserMoreViewController.h"

@interface C2CUserMoreViewController ()
//30日成单量
@property (weak, nonatomic) IBOutlet UILabel *quantityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityAmountLabel;


//30日成单率
@property (weak, nonatomic) IBOutlet UILabel *rateAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *timeBgView;
//30日平均放行时间
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeUnitLabel;

///30日平付款时间
@property (weak, nonatomic) IBOutlet UILabel *loanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanLabel;
@property (weak, nonatomic) IBOutlet UILabel *loanUnitLabel;
///好评率
@property (weak, nonatomic) IBOutlet UILabel *goodRateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodRateLabel;

///好评数
@property (weak, nonatomic) IBOutlet UILabel *goodCountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodCountLabel;
///差评数
@property (weak, nonatomic) IBOutlet UILabel *badCountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *badCountLabel;

///账户已创建
@property (weak, nonatomic) IBOutlet UILabel *creatTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatDaysLabel;
///首次交易至今
@property (weak, nonatomic) IBOutlet UIView *firstBgView;
@property (weak, nonatomic) IBOutlet UILabel *firstTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstDaysLabel;
///交易人数
@property (weak, nonatomic) IBOutlet UILabel *allTransactionsNumberTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *allTransactionsNumberLabel;
///总成单数
@property (weak, nonatomic) IBOutlet UILabel *allOrderCountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *allOrderCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *allOrderCountDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *allOrderUnitLabel;
///30日交易量折合
@property (weak, nonatomic) IBOutlet UILabel *equivalentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *equivalentLabel;
///总交易量折合
@property (weak, nonatomic) IBOutlet UILabel *equivalentTotalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *equivalentTotalLabel;
@end

@implementation C2CUserMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UserData".icanlocalized;
//    "OrderVolume30th"="30日成单量";
//    "30dayOrderRate"="30日成单率";
//    "30DaySaverageLoantime"="30日平均放款时间";
//    "30DaysAveragePaymentTime"="30日平均付款时间";
//    "PraiseRate"="好评率";
//    "NumbeOofPraise"="好评数";
//    "NumberOfBadReviews"="差评数";
//    "AccountHasBeenCreated"="账户已创建";
//    "FirstTransactionToDate"="首次交易至今";
//    "NumberOfTransactions"="交易人数";
//    "AssemblySingular"="总成单数";
//    "30DayTradingVolumeEquivalent"="30日交易量折合";
//    "TotalTransactionVolumeEquivalent"="总交易量折合";
//    "C2CDay"="天";
//    "Single"="单";
    self.quantityTitleLabel.text = @"OrderVolume30th".icanlocalized;
    self.rateTitleLabel.text = @"30dayOrderRate".icanlocalized;
    self.timeTitleLabel.text = @"30DaySaverageLoantime".icanlocalized;
    self.loanTitleLabel.text = @"30DaysAveragePaymentTime".icanlocalized;
    self.goodRateTitleLabel.text = @"PraiseRate".icanlocalized;
    self.goodCountTitleLabel.text = @"NumbeOofPraise".icanlocalized;
    self.badCountTitleLabel.text = @"NumberOfBadReviews".icanlocalized;
    self.creatTimeTitleLabel.text = @"AccountHasBeenCreated".icanlocalized;
    self.firstTimeTitleLabel.text = @"FirstTransactionToDate".icanlocalized;
    self.allTransactionsNumberTitleLabel.text = @"NumberOfTransactions".icanlocalized;
    self.allOrderCountTitleLabel.text = @"AssemblySingular".icanlocalized;
    self.equivalentTitleLabel.text = @"30DayTradingVolumeEquivalent".icanlocalized;
    self.equivalentTotalTitleLabel.text = @"TotalTransactionVolumeEquivalent".icanlocalized;
    self.loanUnitLabel.text = @"minutes".icanlocalized;
    self.timeUnitLabel.text = @"minutes".icanlocalized;
    self.creatDaysLabel.text = @"C2CDay".icanlocalized;
    self.firstDaysLabel.text = @"C2CDay".icanlocalized;
    self.allOrderUnitLabel.text = @"Single".icanlocalized;
    
    [self setData];
}
-(void)setData{
    self.quantityAmountLabel.text = [NSString stringWithFormat:@"%zi",self.userInfo.clinchCount];
    float rate = (self.userInfo.clinchCount*1.0)/(self.userInfo.orderCount*1.0)*100;
    if (self.userInfo.clinchCount==0) {
        self.rateAmountLabel.text = [NSString stringWithFormat:@"%@%%",@"110"];
    }else{
        self.rateAmountLabel.text = [NSString stringWithFormat:@"%.2f%%",rate];
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%.2f",self.userInfo.averageConfirmTime];
    self.loanLabel.text = [NSString stringWithFormat:@"%.2f",self.userInfo.averagePayTime];
    
    
    if (self.userInfo.praiseCount==0) {
        self.goodRateLabel.text = [NSString stringWithFormat:@"100%%"];
    }else{
        float evluateRate = (self.userInfo.praiseCount*1.0)/((self.userInfo.praiseCount+self.userInfo.negativeCount)*1.0)*100;
        self.goodRateLabel.text = [NSString stringWithFormat:@"%.2f%%",evluateRate];
    }
    
    self.goodCountLabel.text = [NSString stringWithFormat:@"%ld",self.userInfo.praiseCount];
    self.badCountLabel.text = [NSString stringWithFormat:@"%ld",self.userInfo.negativeCount];
    
    self.allOrderCountLabel.text = [NSString stringWithFormat:@"%ld",self.userInfo.orderCount];
//    "Buy"="买";
//    "Sell"="卖";
    self.allOrderCountDetailLabel.text = [NSString stringWithFormat:@"%@%ld|%@%ld",@"Buy".icanlocalized,self.userInfo.buyOrderCount,@"Sell".icanlocalized,self.userInfo.sellOrderCount];
    
    NSInteger create = [GetTime numberOfDaysWithFromDate:[NSDate dateWithTimeIntervalSince1970:self.userInfo.createTime.integerValue/1000] toDate:[NSDate date]];
    self.creatTimeLabel.text = [NSString stringWithFormat:@"%ld",create];
    self.allTransactionsNumberLabel.text = [NSString stringWithFormat:@"%ld",self.userInfo.transactionUserCount];
    if (self.userInfo.firstOrderTime) {
        NSInteger first = [GetTime numberOfDaysWithFromDate:[NSDate dateWithTimeIntervalSince1970:self.userInfo.firstOrderTime.integerValue/1000] toDate:[NSDate date]];
        self.firstTimeLabel.text = [NSString stringWithFormat:@"%ld",(long)first];
    }else{
        self.firstBgView.hidden = YES;
    }
    
    
}

@end
