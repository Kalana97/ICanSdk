//
//  CoinsTableViewController.m
//  ICan
//
//  Created by Sathsara on 2023-03-21.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "CoinsTableViewController.h"
#import "CurrencyItemCell.h"
#import "MarketModel.h"
#import "DefaultMarketCoinsModel.h"
#import "CoinService.h"
#import "WSModel.h"
#import "CoinDetailVC.h"


@interface CoinsTableViewController ()
@property(nonatomic, strong) NSMutableArray<MarketModel*> *coinList;
@property(nonatomic, strong) NSMutableArray<DefaultMarketCoinsModel*> *coinDataList;
@property(nonatomic, strong) NSMutableArray<WSModel *> *coinsUpdates;
@end

@implementation CoinsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header=nil;
    self.tableView.mj_footer=nil;
    self.titleView.title = @"Market".icanlocalized;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    [self networkMonitoring];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:true];
    [self.webSocket close];
}

-(void)networkMonitoring{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
}

-(void)applicationNetworkStatusChanged:(NSNotification*)userinfo{
    NSInteger status = [[[userinfo userInfo]objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:{
            [[NSNotificationCenter defaultCenter]postNotificationName:KAFNetworkReachabilityStatusNotReachable object:nil];
        }
            return;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
        default:{
            [self getData];
        }
            return;
    }
}

-(void)getData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [QMUITips showLoadingInView:self.view];
        CoinService *coinService = [[CoinService alloc] init];
        [coinService getCoinsWithCompletion:^(NSMutableArray<DefaultMarketCoinsModel*> *coins) {
            [QMUITips hideAllTips];
            if (coins) {
                self.coinDataList = coins;
                [self addCoins];
                NSLog(@"Coins: %@", self.coinDataList[0].name);
            } else {
                NSLog(@"Failed to get coins");
            }
        }];
    });
}

-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kCurrencyItemCell];
}

-(void)initializeRocketSocket{
    NSString *tempUrl = @"wss://ws.coincap.io/prices?assets=";
    for (MarketModel *perCoin in self.coinList) {
        tempUrl = [tempUrl stringByAppendingString:[NSString stringWithFormat:@"%@%@",perCoin.coindId,@","]];
    }
    NSURL *url = [NSURL URLWithString:tempUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    self.webSocket.delegate = self;
    [self.webSocket open];
}

-(void)addCoins{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.coinList removeAllObjects];
        
        MarketModel *Bitcoin = [[MarketModel alloc] init];
        Bitcoin.coindId = @"bitcoin";
        Bitcoin.coinName = @"Bitcoin";
        Bitcoin.coinCode = @"BTC";
        Bitcoin.coinImageName = @"btc";
        [self addCoinObject:Bitcoin];
        
        MarketModel *Ethereum = [[MarketModel alloc] init];
        Ethereum.coindId = @"ethereum";
        Ethereum.coinName = @"Ethereum";
        Ethereum.coinCode = @"ETH";
        Ethereum.coinImageName = @"eth";
        [self addCoinObject:Ethereum];
        
        MarketModel *Tether = [[MarketModel alloc] init];
        Tether.coindId = @"tether";
        Tether.coinName = @"Tether";
        Tether.coinCode = @"USDT";
        Tether.coinImageName = @"usdt";
        [self addCoinObject:Tether];
        
        
        MarketModel *BNB = [[MarketModel alloc] init];
        BNB.coindId = @"binance-coin";
        BNB.coinName = @"BNB";
        BNB.coinCode = @"BNB";
        BNB.coinImageName = @"bnb";
        [self addCoinObject:BNB];
        
        
        MarketModel *USD_Coin = [[MarketModel alloc] init];
        USD_Coin.coindId = @"usd-coin";
        USD_Coin.coinName = @"USD Coin";
        USD_Coin.coinCode = @"USDC";
        USD_Coin.coinImageName = @"usdc";
        [self addCoinObject:USD_Coin];
        
        
        MarketModel *XRP = [[MarketModel alloc] init];
        XRP.coindId = @"xrp";
        XRP.coinName = @"XRP";
        XRP.coinCode = @"XRP";
        XRP.coinImageName = @"xrp";
        [self addCoinObject:XRP];
        
        
        MarketModel *Cardano = [[MarketModel alloc] init];
        Cardano.coindId = @"cardano";
        Cardano.coinName = @"Cardano";
        Cardano.coinCode = @"ADA";
        Cardano.coinImageName = @"ada";
        [self addCoinObject:Cardano];
        
        
        MarketModel *Polygon = [[MarketModel alloc] init];
        Polygon.coindId = @"polygon";
        Polygon.coinName = @"Polygon";
        Polygon.coinCode = @"MATIC";
        Polygon.coinImageName = @"matic";
        [self addCoinObject:Polygon];
        
        
        MarketModel *Dogecoin = [[MarketModel alloc] init];
        Dogecoin.coindId = @"dogecoin";
        Dogecoin.coinName = @"Dogecoin";
        Dogecoin.coinCode = @"DOGE";
        Dogecoin.coinImageName = @"doge";
        [self addCoinObject:Dogecoin];
        
        
        MarketModel *Solana = [[MarketModel alloc] init];
        Solana.coindId = @"solana";
        Solana.coinName = @"Solana";
        Solana.coinCode = @"SOL";
        Solana.coinImageName = @"sol";
        [self addCoinObject:Solana];
        
        
        MarketModel *Binance_USD = [[MarketModel alloc] init];
        Binance_USD.coindId = @"binance-usd";
        Binance_USD.coinName = @"Binance USD";
        Binance_USD.coinCode = @"BUSD";
        Binance_USD.coinImageName = @"busd";
        [self addCoinObject:Binance_USD];
        
        
        MarketModel *Polkadot = [[MarketModel alloc] init];
        Polkadot.coindId = @"polkadot";
        Polkadot.coinName = @"Polkadot";
        Polkadot.coinCode = @"DOT";
        Polkadot.coinImageName = @"dot";
        [self addCoinObject:Polkadot];
        
        
        MarketModel *Shiba_Inu = [[MarketModel alloc] init];
        Shiba_Inu.coindId = @"shiba-inu";
        Shiba_Inu.coinName = @"Shiba Inu";
        Shiba_Inu.coinCode = @"SHIB";
        Shiba_Inu.coinImageName = @"SHIB";
        [self addCoinObject:Shiba_Inu];
        
        
        MarketModel *Litecoin = [[MarketModel alloc] init];
        Litecoin.coindId = @"litecoin";
        Litecoin.coinName = @"Litecoin";
        Litecoin.coinCode = @"LTC";
        Litecoin.coinImageName = @"ltc";
        [self addCoinObject:Litecoin];
        
        
        MarketModel *TRON = [[MarketModel alloc] init];
        TRON.coindId = @"tron";
        TRON.coinName = @"TRON";
        TRON.coinCode = @"TRX";
        TRON.coinImageName = @"trx";
        [self addCoinObject:TRON];
        
        
        MarketModel *Avalanche = [[MarketModel alloc] init];
        Avalanche.coindId = @"avalanche";
        Avalanche.coinName = @"Avalanche";
        Avalanche.coinCode = @"AVAX";
        Avalanche.coinImageName = @"avax";
        [self addCoinObject:Avalanche];
        
        
        MarketModel *Uniswap = [[MarketModel alloc] init];
        Uniswap.coindId = @"uniswap";
        Uniswap.coinName = @"Uniswap";
        Uniswap.coinCode = @"UNI";
        Uniswap.coinImageName = @"uni";
        [self addCoinObject:Uniswap];
        
        
        MarketModel *DAI = [[MarketModel alloc] init];
        DAI.coindId = @"multi-collateral-dai";
        DAI.coinName = @"DAI";
        DAI.coinCode = @"DAI";
        DAI.coinImageName = @"dai";
        [self addCoinObject:DAI];
        
        
        MarketModel *Chainlink = [[MarketModel alloc] init];
        Chainlink.coindId = @"chainlink";
        Chainlink.coinName = @"Chainlink";
        Chainlink.coinCode = @"LINK";
        Chainlink.coinImageName = @"link";
        [self addCoinObject:Chainlink];
        
        
        MarketModel *Cosmos = [[MarketModel alloc] init];
        Cosmos.coindId = @"cosmos";
        Cosmos.coinName = @"Cosmos";
        Cosmos.coinCode = @"ATOM";
        Cosmos.coinImageName = @"atom";
        [self addCoinObject:Cosmos];
    });
}

-(void)addCoinObject:(MarketModel*)model{
    if(model != nil){
        [self.coinList addObject:model];
        for (DefaultMarketCoinsModel *coinData in self.coinDataList) {
            if([coinData.idCode isEqualToString:model.coindId]){
                model.coinPercentage = coinData.changePercent24Hr;
                model.coinPrice = coinData.priceUsd;
                NSUInteger index = [self.coinList indexOfObject:model];
                if(index == 19){
                    [self.tableView reloadData];
                    [self initializeRocketSocket];
                }
            }
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.coinList.count > 0){
        return self.coinList.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CurrencyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCurrencyItemCell];
    MarketModel *model = self.coinList[indexPath.row];
    cell.editSuccessBlock = ^(NSString * _Nonnull coinCode) {
        [self sendDetailView:coinCode];
    };
    if(model != nil){
        [cell setCoinData:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
}

-(void)sendDetailView:(NSString *)coinCodeVal{
    UIStoryboard *board;
    board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    CoinDetailVC *View = [board instantiateViewControllerWithIdentifier:@"CoinDetailVC"];
    View.hidesBottomBarWhenPushed = YES;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCode == %@", coinCodeVal];
    NSArray *filteredArray = [self.coinDataList filteredArrayUsingPredicate:predicate];
    View.CoinDataInfo = filteredArray.firstObject;
    [self.navigationController pushViewController:View animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void)changesOfCells{
    for (MarketModel *coinData in self.coinList) {
        for (WSModel *coinUpdateData in self.coinsUpdates) {
            if([coinUpdateData.name isEqualToString:coinData.coindId]){
                if([coinData.coinPrice floatValue] > [coinUpdateData.price floatValue]){
                    coinData.cellChangeColor = [UIColor colorWithRed:255.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1.0];
                    coinData.isUp = NO;
                }else if ([coinData.coinPrice floatValue] < [coinUpdateData.price floatValue]){
                    coinData.cellChangeColor = [UIColor colorWithRed:236.0/255.0 green:255.0/255.0 blue:236.0/255.0 alpha:1.0];
                    coinData.isUp = YES;
                }
                if([coinUpdateData.price floatValue] > 1){
                    coinData.coinPrice = [NSString stringWithFormat:@"%.2f", [coinUpdateData.price floatValue]];
                }else{
                    coinData.coinPrice = [NSString stringWithFormat:@"%.8f", [coinUpdateData.price floatValue]];
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

-(NSMutableArray<MarketModel *> *)coinList{
    if (!_coinList) {
        _coinList = [NSMutableArray array];
    }
    return _coinList;
}

-(NSMutableArray<DefaultMarketCoinsModel *> *)coinDataList{
    if (!_coinDataList) {
        _coinDataList = [NSMutableArray array];
    }
    return _coinDataList;
}

-(NSMutableArray<WSModel *> *)coinsUpdates{
    if (!_coinsUpdates) {
        _coinsUpdates = [NSMutableArray array];
    }
    return _coinsUpdates;
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
    NSLog(@"%@",self.coinsUpdates);
    [self changesOfCells];
}

@end
