//
//  CoinDetailVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-04-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "CoinDetailVC.h"
#import "WSModel.h"

@interface CoinDetailVC ()
@property (nonatomic, assign) NSInteger previousStepperValue;
@property (nonatomic, assign) NSInteger totalNumber;
@property(nonatomic, strong) NSMutableArray<WSModel *> *coinsUpdates;
@property (weak, nonatomic) IBOutlet UIButton *oneHourBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneDayBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneWeekBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneMonthBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneYearBtn;
@property (nonatomic, strong) NSArray *buttons;

@end

@implementation CoinDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myGraph.delegate = self;
    self.myGraph.dataSource = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.buttons = @[self.oneHourBtn, self.oneDayBtn, self.oneWeekBtn, self.oneMonthBtn, self.oneYearBtn];
        [self setCoinDataInfoFromModel];
        [self getBackDateTimeStamp:0 completion:^{
            [self mapDataList:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" outPutTimeFormatString:@"yyyy-MM-dd HH:mm:ss" completion:^{
                NSLog(@"%lu",(unsigned long)self.dateList.count);
                NSLog(@"%lu",(unsigned long)self.priceList.count);
                [self setDataForGraph];
            }];
        }];
        [self designGraph];
        [self setButtonUIStak];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    [self initializeRocketSocket:self.CoinDataInfo.idCode];
    [self setButtonUIStak];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:true];
    [self.webSocket close];
}

-(void)setDataForGraph{
    [self hydrateDatasets];
}

-(void)designGraph{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    // Apply the gradient to the bottom portion of the graph
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    // Enable and disable various graph properties and axis displays
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.autoScaleYAxis = YES;
    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableReferenceXAxisLines = NO;
    self.myGraph.enableReferenceYAxisLines = NO;
    self.myGraph.enableReferenceAxisFrame = YES;
    self.myGraph.enableXAxisLabel = NO;
    self.myGraph.enableYAxisLabel = NO;
    // Draw an average line
    self.myGraph.averageLine.enableAverageLine = YES;
    self.myGraph.averageLine.alpha = 0.6;
    self.myGraph.averageLine.color = [UIColor darkGrayColor];
    self.myGraph.averageLine.width = 2.5;
    self.myGraph.averageLine.dashPattern = @[@(2),@(2)];
    // Set the graph's animation style to draw, fade, or none
    self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    // Dash the y reference lines
    self.myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    // Show the y axis values with this format string
    self.myGraph.formatStringForValues = @"%.1f";
}

- (void)hydrateDatasets {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.arrayOfValues removeAllObjects];
        [self.arrayOfDates removeAllObjects];
        self.totalNumber = 0;
        // Add objects to the array based on the stepper value
        for (int i = 0; i < self.priceList.count; i++) {
            [self.arrayOfValues addObject:self.priceList[i]];// Random values for the graph
            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.dateList[i]]]; // Dates for the X-Axis of the graph
            self.totalNumber = self.totalNumber + [[self.arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
        }
        [self.myGraph reloadGraph];
    });
}

- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwentyFourHours = 24 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwentyFourHours];
    return newDate;
}

- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSDate *date = self.arrayOfDates[index];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd";
    NSString *label = [df stringFromDate:date];
    return label;
}

-(void)setButtonUIStak{
    [self setUpBtns:0];
    [self setLocalizations];
    for (UIButton *button in self.buttons) {
        button.layer.cornerRadius = button.bounds.size.height / 2;
        button.layer.masksToBounds = YES;
    }
}

-(void)initializeRocketSocket:(NSString *) coinCode{
    NSString *tempUrl = @"wss://ws.coincap.io/prices?assets=";
    tempUrl = [tempUrl stringByAppendingString:[NSString stringWithFormat:@"%@",coinCode]];
    NSURL *url = [NSURL URLWithString:tempUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

-(void)setLocalizations{
    self.rankLbl.text = @"Rank".icanlocalized;
    self.changeLbl.text = @"Change".icanlocalized;
    self.supplyLbl.text = @"Total Supply".icanlocalized;
    self.volumeLbl.text = @"Volume".icanlocalized;
    self.marketLbl.text = @"Market Cap".icanlocalized;
    self.coinStatisticsLbl.text = @"Coin Statistics".icanlocalized;
}

-(void)setUpBtns:(NSInteger)btnIndex{
    for (UIButton *button in self.buttons) {
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    UIButton *selectedButton = self.buttons[btnIndex];
    [selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectedButton.backgroundColor = [UIColor systemBlueColor];
    [selectedButton layoutIfNeeded];
}

-(void)updateDataInSelfModel{
    WSModel *newCoinUpdate = self.coinsUpdates.firstObject;
    if([newCoinUpdate.price  floatValue] > [self.CoinDataInfo.priceUsd floatValue]){
        self.upDownIcon.image = [UIImage imageNamed:@"goUp"];
    }else if ([newCoinUpdate.price  floatValue] < [self.CoinDataInfo.priceUsd floatValue]){
        self.upDownIcon.image = [UIImage imageNamed:@"goDown"];
    }
    self.CoinDataInfo.priceUsd = [NSString stringWithFormat:@"%f ", [newCoinUpdate.price  floatValue]];
    if([self.CoinDataInfo.priceUsd floatValue] > 1){
        self.titleLbl.text = [NSString stringWithFormat:@"$%.2f ", [self.CoinDataInfo.priceUsd  floatValue]];
    }else{
        self.titleLbl.text = [NSString stringWithFormat:@"$%.8f ", [self.CoinDataInfo.priceUsd  floatValue]];
    }
}

-(void)setCoinDataInfoFromModel{
    self.title = self.CoinDataInfo.symbol;
    if([self.CoinDataInfo.priceUsd floatValue] > 1){
        self.titleLbl.text = [NSString stringWithFormat:@"$%.2f ", [self.CoinDataInfo.priceUsd  floatValue]];
    }else{
        self.titleLbl.text = [NSString stringWithFormat:@"$%.8f ", [self.CoinDataInfo.priceUsd floatValue]];
    }
    self.percentageLbl.text = [NSString stringWithFormat:@"%.2f %@", [self.CoinDataInfo.changePercent24Hr floatValue],@"%"];
    self.rankDataLbl.text = self.CoinDataInfo.rank;
    if([self.CoinDataInfo.marketCapUsd floatValue] > 1){
        self.marketDataLbl.text = [NSString stringWithFormat:@"$%.2f ", [self.CoinDataInfo.marketCapUsd floatValue]];
    }else{
        self.marketDataLbl.text = [NSString stringWithFormat:@"%.8f ", [self.CoinDataInfo.marketCapUsd floatValue]];
    }
    self.supplyDataLbl.text = [NSString stringWithFormat:@"%.2f ", [self.CoinDataInfo.supply floatValue]];
    if([self.CoinDataInfo.volumeUsd24Hr floatValue] > 1){
        self.volumeDataLbl.text = [NSString stringWithFormat:@"$%.2f ", [self.CoinDataInfo.volumeUsd24Hr floatValue]];
    }else{
        self.volumeDataLbl.text = [NSString stringWithFormat:@"%.8f ", [self.CoinDataInfo.volumeUsd24Hr floatValue]];
    }
    self.changeDataLbl.text = [NSString stringWithFormat:@"%.2f %@", [self.CoinDataInfo.changePercent24Hr floatValue],@"%"];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    [self.coinsUpdates removeAllObjects];
    NSError *jsonError = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    if (jsonError) {
        NSLog(@"JSON Error: %@", jsonError);
        return;
    }
    for (NSString *dict in jsonObject) {
        WSModel *crypto = [[WSModel alloc] init];
        crypto.name = dict;
        crypto.price = [NSNumber numberWithFloat:[[jsonObject valueForKey:crypto.name] floatValue]];
        [self.coinsUpdates addObject:crypto];
    }
    [self updateDataInSelfModel];
}


-(void)getBackDateTimeStamp:(NSInteger)typeVal completion:(void (^)(void))completion{
    [self.historyList removeAllObjects];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval currentTimeInMilliseconds = currentTime * 1000;
    if(typeVal == 0){
        NSDate *oneHourBackDate = [currentDate dateByAddingTimeInterval:-3600]; // 3600 seconds in an hour
        NSTimeInterval oneHourBackTimestamp = [oneHourBackDate timeIntervalSince1970];
        [self createLinkUrlAndGetData:oneHourBackTimestamp endValue:currentTimeInMilliseconds intervelValue:@"m5" completion:^{
            completion();
        }];
    }else if (typeVal == 1){
        NSDate *oneDayBackDate = [currentDate dateByAddingTimeInterval:-86400]; // 86400 seconds in a day
        NSTimeInterval oneDayBackTimestamp = [oneDayBackDate timeIntervalSince1970];
        [self createLinkUrlAndGetData:oneDayBackTimestamp endValue:currentTimeInMilliseconds intervelValue:@"h1" completion:^{
            completion();
        }];
    }else if (typeVal == 2){
        NSDateComponents *weekComponent = [[NSDateComponents alloc] init];
        weekComponent.day = -7;
        NSDate *oneWeekBackDate = [[NSCalendar currentCalendar] dateByAddingComponents:weekComponent toDate:currentDate options:0];
        NSTimeInterval oneWeekBackTimestamp = [oneWeekBackDate timeIntervalSince1970];
        [self createLinkUrlAndGetData:oneWeekBackTimestamp endValue:currentTimeInMilliseconds intervelValue:@"d1" completion:^{
            completion();
        }];
    }else if (typeVal == 3){
        NSDateComponents *monthComponent = [[NSDateComponents alloc] init];
        monthComponent.month = -1;
        NSDate *oneMonthBackDate = [[NSCalendar currentCalendar] dateByAddingComponents:monthComponent toDate:currentDate options:0];
        NSTimeInterval oneMonthBackTimestamp = [oneMonthBackDate timeIntervalSince1970];
        [self createLinkUrlAndGetData:oneMonthBackTimestamp endValue:currentTimeInMilliseconds intervelValue:@"d1" completion:^{
            completion();
        }];
    }else if(typeVal == 4){
        NSDateComponents *yearComponent = [[NSDateComponents alloc] init];
        yearComponent.year = -1;
        NSDate *oneYearBackDate = [[NSCalendar currentCalendar] dateByAddingComponents:yearComponent toDate:currentDate options:0];
        NSTimeInterval oneYearBackTimestamp = [oneYearBackDate timeIntervalSince1970];
        [self createLinkUrlAndGetData:oneYearBackTimestamp endValue:currentTimeInMilliseconds intervelValue:@"d1" completion:^{
            completion();
        }];
    }else{
        NSDateComponents *yearComponent = [[NSDateComponents alloc] init];
        yearComponent.year = -1;
        NSDate *oneYearBackDate = [[NSCalendar currentCalendar] dateByAddingComponents:yearComponent toDate:currentDate options:0];
        NSTimeInterval oneYearBackTimestamp = [oneYearBackDate timeIntervalSince1970];
        [self createLinkUrlAndGetData:oneYearBackTimestamp endValue:currentTimeInMilliseconds intervelValue:@"d1" completion:^{
            completion();
        }];
    }
}

-(void)createLinkUrlAndGetData:(NSTimeInterval)startValue endValue:(NSTimeInterval)endValue intervelValue:(NSString *)intervelValue completion:(void (^)(void))completion{
    NSTimeInterval startTimestampInMilliseconds = startValue * 1000;
    self.urlVal = [NSString stringWithFormat:@"https://api.coincap.io/v2/assets/%@/history?interval=%@&start=%f&end=%f",self.CoinDataInfo.idCode,intervelValue,startTimestampInMilliseconds,endValue];
    [self getCoinsWithCompletion:^(NSMutableArray<StaticCoinModel *> *staticData) {
        self.historyList = staticData;
        completion();
    }];
}

- (void)getCoinsWithCompletion:(void (^)(NSMutableArray<StaticCoinModel*> *staticData))completion{
    NSURL *url = [NSURL URLWithString:self.urlVal];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            completion(nil);
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"JSON Error: %@", jsonError);
            completion(nil);
            return;
        }
        NSArray *coinsJson = json[@"data"];
        NSMutableArray<StaticCoinModel *> *statistics = [NSMutableArray array];
        for (NSDictionary *coinJson in coinsJson) {
            StaticCoinModel *coin = [[StaticCoinModel alloc] initWithDictionary:coinJson];
            [statistics addObject:coin];
        }
        completion(statistics);
    }];
    [task resume];
}

-(void)mapDataList:(NSString*)inputTimeFormatString outPutTimeFormatString:(NSString *)outPutTimeFormatString completion:(void (^)(void))completion{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    for (StaticCoinModel *dataVal in self.historyList) {
        if(dataVal.priceUsd != nil){
            [self.priceList addObject:dataVal.priceUsd];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:inputTimeFormatString];
        NSDate *date = [dateFormatter dateFromString:dataVal.date];
        if(date != nil){
            [self.dateList addObject:date];
        }
    }
    completion();
}

- (IBAction)buttonClickActionsRequest:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self setUpBtns:sender.tag];
            [self getHistoryData:sender.tag];
            break;
        case 1:
            [self setUpBtns:sender.tag];
            [self getHistoryData:sender.tag];
            break;
        case 2:
            [self setUpBtns:sender.tag];
            [self getHistoryData:sender.tag];
            break;
        case 3:
            [self setUpBtns:sender.tag];
            [self getHistoryData:sender.tag];
            break;
        case 4:
            [self setUpBtns:sender.tag];
            [self getHistoryData:sender.tag];
            break;
        default:
            [self setUpBtns:0];
            [self getHistoryData:sender.tag];
            break;
    }
}

-(void)getHistoryData:(NSInteger)typeInt{
    [self.dateList removeAllObjects];
    [self.priceList removeAllObjects];
    [self getBackDateTimeStamp:typeInt completion:^{
        [self mapDataList:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ" outPutTimeFormatString:@"yyyy-MM-dd HH:mm:ss" completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%lu",(unsigned long)self.dateList.count);
                NSLog(@"%lu",(unsigned long)self.priceList.count);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hydrateDatasets];
                    [self.myGraph reloadGraph];
                });
            });
        }];
    }];
}

-(NSMutableArray<WSModel *> *)coinsUpdates{
    if (!_coinsUpdates) {
        _coinsUpdates = [NSMutableArray array];
    }
    return _coinsUpdates;
}

-(NSMutableArray<StaticCoinModel *> *)historyList{
    if (!_historyList) {
        _historyList=[NSMutableArray array];
    }
    return _historyList;
}

-(NSMutableArray<NSString *> *)priceList{
    if (!_priceList) {
        _priceList=[NSMutableArray array];
    }
    return _priceList;
}

-(NSMutableArray<NSDate *> *)dateList{
    if (!_dateList) {
        _dateList=[NSMutableArray array];
    }
    return _dateList;
}

-(NSMutableArray *)arrayOfValues{
    if (!_arrayOfValues) {
        _arrayOfValues = [NSMutableArray array];
    }
    
    return _arrayOfValues;
}

-(NSMutableArray *)arrayOfDates{
    if (!_arrayOfDates) {
        _arrayOfDates = [NSMutableArray array];
    }
    return _arrayOfDates;
}

- (float)getRandomFloat {
    float i1 = (float)(arc4random() % 1000000) / 100 ;
    return i1;
}

#pragma mark - SimpleLineGraph Data Source
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    if (self.arrayOfValues.count < 1){
        return 0;
    }else{
        return (int)[self.arrayOfValues count];
    }
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate
- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    NSLog(@""); // Future Use
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    NSLog(@"");// Future Use
}

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @"";// Future Use
}

@end
