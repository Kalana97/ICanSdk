//
//  CoinDetailVC.h
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-04-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticCoinModel.h"
#import "DefaultMarketCoinsModel.h"
#import "BEMSimpleLineGraphView.h"


NS_ASSUME_NONNULL_BEGIN

@interface CoinDetailVC : UIViewController <SRWebSocketDelegate,BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
@property(nonatomic, strong) DefaultMarketCoinsModel *CoinDataInfo;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *percentageLbl;
@property (weak, nonatomic) IBOutlet DZIconImageView *upDownIcon;
@property (weak, nonatomic) IBOutlet UILabel *coinStatisticsLbl;
@property (weak, nonatomic) IBOutlet UILabel *rankLbl;
@property (weak, nonatomic) IBOutlet UILabel *rankDataLbl;
@property (weak, nonatomic) IBOutlet UILabel *marketLbl;
@property (weak, nonatomic) IBOutlet UILabel *marketDataLbl;
@property (weak, nonatomic) IBOutlet UILabel *supplyLbl;
@property (weak, nonatomic) IBOutlet UILabel *supplyDataLbl;
@property (weak, nonatomic) IBOutlet UILabel *volumeLbl;
@property (weak, nonatomic) IBOutlet UILabel *volumeDataLbl;
@property (weak, nonatomic) IBOutlet UILabel *changeLbl;
@property (weak, nonatomic) IBOutlet UILabel *changeDataLbl;
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;
@property(nonatomic, strong) NSString *urlVal;
@property(nonatomic, strong) NSMutableArray<StaticCoinModel*> *historyList;
@property(nonatomic, strong) NSMutableArray<NSString*> *priceList;
@property(nonatomic, strong) NSMutableArray<NSDate*> *dateList;
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@end

NS_ASSUME_NONNULL_END
