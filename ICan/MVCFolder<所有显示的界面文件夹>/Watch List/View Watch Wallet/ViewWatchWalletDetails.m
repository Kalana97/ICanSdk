//
//  ViewWatchWalletDetails.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-12.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ViewWatchWalletDetails.h"
#import "AssetsDataCell.h"
#import "ChatViewHandleTool.h"
#import "AddWatchWallet.h"
#import "WatchList.h"

@interface ViewWatchWalletDetails ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *address1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *assetsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgCardView;
@property (weak, nonatomic) IBOutlet UILabel *currencyType1;
@property (weak, nonatomic) IBOutlet UILabel *currencyType2;
@property (weak, nonatomic) IBOutlet UIStackView *mainStack1;
@property (weak, nonatomic) IBOutlet UIStackView *mainStack2;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIStackView *fullStackMain;
@property (weak, nonatomic) IBOutlet UIImageView *addWalletImg;
@property (weak, nonatomic) IBOutlet UIButton *addWalletLbl;
@property (weak, nonatomic) IBOutlet UIStackView *emptyScreenStack;
@property (weak, nonatomic) IBOutlet UIView *emptyPopUpView;
@property(nonatomic,strong)UIButton *rightDeleteBtn;
@property(nonatomic,strong)UIButton *rightAddBtn;
@property(nonatomic,strong)UIButton *rightListBtn;
@property(nonatomic, strong) NSArray<C2CWatchWalletInfo*> *WalletItemsList;
@end

@implementation ViewWatchWalletDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav:self.walletModel.name];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registNibWithNibName:@"AssetsDataCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.fullStackMain.hidden = YES;
    self.myTableView.hidden = YES;
    [self.addWalletLbl setTitle:@"Add new wallet".icanlocalized forState:UIControlStateNormal];
    self.addWalletLbl.layer.cornerRadius = 10;
    self.addWalletLbl.layer.masksToBounds = YES;
    [self setupUI];
}

-(void)createNav:(NSString *)titleVal{
    // Create a custom UIButton with image and label
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:titleVal forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"SwapWallet"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10); // Add space between image and label
    [button sizeToFit]; // Automatically adjust button size to fit the content
    // Set the semanticContentAttribute to position the image on the right side
    button.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    // Add a target and action for the button
    [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    // Create a UIBarButtonItem with the custom UIButton as a custom view
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    // Set the UIBarButtonItem as the titleView of the navigation item
    self.navigationItem.titleView = barButtonItem.customView;
}

- (void)buttonTapped {
    [self buttonListTapped];
}

-(void)setupUI{
    if(self.isFromPageViewController == YES){
        [self getWalletList:^{
            [self createNav:self.walletModel.name];
            if(self.walletModel != nil){
                [self getDataRequest:^{
                    [QMUITips hideAllTips];
                    [self createButtonNavWithThree];
                    [self setData];
                    [self.myTableView reloadData];
                }];
            }else{
                [self createButtonNavWithOne];
            }
        }];
    }else{
        if(self.walletModel != nil){
            [self createButtonNavWithThree];
            [self setAsDefaultWallet:self.walletModel.observeWalletId];
            [self getDataRequest:^{
                [QMUITips hideAllTips];
                [self setData];
                [self.myTableView reloadData];
            }];
        }else{
            [self createButtonNavWithOne];
        }
    }
    [self.bgImg layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    [self.bgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
}

-(void)createButtonNavWithThree{
    // Create the custom view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    // Create the first button
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 30, 44);
    UIImage *button1Image = [UIImage imageNamed:@"icon_chat_delete"];
    [button1 setImage:button1Image forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonDeleteTapped) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button1];
    // Create the second button
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(35, 0, 30, 44);
    UIImage *button2Image = [UIImage imageNamed:@"Add new"];
    [button2 setImage:button2Image forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAddTapped) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button2];
    // Create the right bar button item with the custom view
    UIBarButtonItem *customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    // Assign the right bar button item to the navigation item
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
}

-(void)createButtonNavWithOne{
    // Create the custom view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    // Create the second button
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(35, 0, 30, 44);
    UIImage *button1Image = [UIImage imageNamed:@"Add new"];
    [button1 setImage:button1Image forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAddTapped) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:button1];
    // Create the right bar button item with the custom view
    UIBarButtonItem *customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    // Assign the right bar button item to the navigation item
    self.navigationItem.rightBarButtonItem = customBarButtonItem;
}

// Button tap actions
- (void)buttonDeleteTapped {
    [self deleteModel];
}

- (void)buttonAddTapped {
    UIStoryboard *board;
    board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    AddWatchWallet *View = [board instantiateViewControllerWithIdentifier:@"AddWatchWallet"];
    View.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:View animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)buttonListTapped {
    WatchList *findController = [[WatchList alloc] init];
    findController.hidesBottomBarWhenPushed = NO;
    findController.viewPageBlock = ^(WatchWalletListInfo * _Nonnull modelData) {
        self.walletModel = modelData;
        self.isFromPageViewController = NO;
        [self createNav:self.walletModel.name];
        [self setupUI];
    };
    [self.navigationController pushViewController:findController animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(void)setData{
    self.imgCardView.image = [UIImage imageNamed:[ChatViewHandleTool getImageByChannelCodeWatchWallet:self.walletModel.channelCode]];
    self.assetsLbl.text = @"Assets".icanlocalized;
    self.nameLbl.text = self.walletModel.name;
    NSString *extendAddress = self.walletModel.extendAddress;
    NSString *firstPart = [self seperateComma:extendAddress isFirst:YES];
    NSString *secondPart = [self seperateComma:extendAddress isFirst:NO];
    if([self.walletModel.channelCode isEqualToString:@"ican"]){
        if(firstPart != nil && ![firstPart isEqualToString: @""]){
            if ([firstPart hasPrefix:@"T"]) {
                self.currencyType1.text = @"TRC20";
            } else if ([firstPart hasPrefix:@"0x"]) {
                self.currencyType1.text = @"ERC20";
            }
            self.mainStack1.hidden = NO;
            self.addressLbl.text = firstPart;
        }else{
            self.mainStack1.hidden = YES;
        }
        if(secondPart != nil && ![secondPart  isEqualToString: @""]){
            if ([secondPart hasPrefix:@"T"]) {
                self.currencyType1.text = @"TRC20";
            } else if ([secondPart hasPrefix:@"0x"]) {
                self.currencyType2.text = @"ERC20";
            }
            self.mainStack2.hidden = NO;
            self.address1Lbl.text = secondPart;
        }else{
            self.mainStack2.hidden = YES;
        }
    }else{
        if ([self.walletModel.walletAddress hasPrefix:@"T"]) {
            self.currencyType2.text = @"TRC20";
        } else if ([self.walletModel.walletAddress hasPrefix:@"0x"]) {
            self.currencyType2.text = @"ERC20";
        }
        self.address1Lbl.text = self.walletModel.walletAddress;
        self.mainStack1.hidden = YES;
        self.mainStack2.hidden = NO;
    }
    self.fullStackMain.hidden = NO;
    self.emptyPopUpView.hidden = YES;
    self.myTableView.hidden = NO;
}

-(void)deleteModel{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure to remove".icanlocalized
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"Sure".icanlocalized
                                                        style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        DeleteWalletFromListRequest *request = [DeleteWalletFromListRequest request];
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/observe/%ld",self.walletModel.observeWalletId];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CBaseResponse class] contentClass:[C2CBaseResponse class] success:^(id  _Nonnull response) {
            [QMUITipsTool showOnlyTextWithMessage:@"DeleteSuccess".icanlocalized inView:self.view];
            GetWatchWalletListRequest *request = [GetWatchWalletListRequest request];
            [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[WatchWalletListInfo class] success:^(NSArray<WatchWalletListInfo *> *response) {
                if(response.count > 0){
                    [self setAsDefaultWallet:response[response.count - 1].observeWalletId];
                    [self setupUI];
                } else{
                    self.fullStackMain.hidden = YES;
                    self.myTableView.hidden = YES;
                    [self.addWalletLbl setTitle:@"Add new wallet".icanlocalized forState:UIControlStateNormal];
                    self.addWalletLbl.layer.cornerRadius = 10;
                    self.addWalletLbl.layer.masksToBounds = YES;
                    self.walletModel = nil;
                    [self setupUI];
                }
            } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
            }];
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        }];
    }];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Cancel".icanlocalized
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil];
    [alertController addAction:sureAction];
    [alertController addAction:dismissAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)setAsDefaultWallet:(NSInteger)walletId{
    [QMUITips showLoadingInView:self.view];
    C2CAddWalletAsDefault *request = [C2CAddWalletAsDefault request];
    request.pathUrlString = [request.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/api/observe/default/%ld",(long)walletId]];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CAddAddressResponse class] contentClass:[C2CAddAddressResponse class] success:^(C2CAddAddressResponse* response) {
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

- (IBAction)copyBtn1Action:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *textToCopy = self.addressLbl.text;
    [pasteboard setString:textToCopy];
    if (pasteboard.string != nil) {
        [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
    } else {
        NSLog(@"Error copying address to clipboard.");
    }
}

- (IBAction)copyBtn2Action:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *textToCopy = self.address1Lbl.text;
    [pasteboard setString:textToCopy];
    if (pasteboard.string != nil) {
        [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
    } else {
        NSLog(@"Error copying address to clipboard.");
    }
}

- (IBAction)goToAddNewWallet:(id)sender {
    UIStoryboard *board;
    board = [UIStoryboard storyboardWithName:@"Common" bundle:nil];
    AddWatchWallet *View = [board instantiateViewControllerWithIdentifier:@"AddWatchWallet"];
    View.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:View animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.WalletItemsList.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AssetsDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetsDataCell"];
    C2CWatchWalletInfo *model = self.WalletItemsList[indexPath.row];
    if([self.walletModel.channelCode isEqualToString:@"ican"]){
        if(model != nil){
            [cell setAssetDataLogoManual:model];
        }
    }else{
        if(model != nil){
            [cell setAssetData:model];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(NSString *)seperateComma:(NSString *)data isFirst:(BOOL)isFirst{
    NSString *inputString = data;
    // Find the index of the target character
    NSUInteger targetIndex = [inputString rangeOfString:@","].location;
    if (targetIndex != NSNotFound) {
        // Get the characters before the target character
        NSString *charactersBefore = [inputString substringToIndex:targetIndex];
        NSLog(@"Characters before: %@", charactersBefore);
        // Get the characters after the target character
        NSString *charactersAfter = [inputString substringFromIndex:targetIndex + 1];
        NSLog(@"Characters after: %@", charactersAfter);
        if(isFirst == true){
            if(charactersBefore != nil && ![charactersBefore  isEqual: @""]){
                return charactersBefore;
            }else{
                return nil;
            }
        }else{
            if(charactersAfter != nil && ![charactersAfter  isEqual: @""]){
                return charactersAfter;
            }else{
                return nil;
            }
        }
    }else {
        return nil;
    }
}

-(void)getWalletList:(void (^)(void))completion{
    __block bool isFind;
    [QMUITips showLoadingInView:self.view];
    GetWatchWalletListRequest *request = [GetWatchWalletListRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[WatchWalletListInfo class] success:^(NSArray<WatchWalletListInfo*>* response) {
        isFind = NO;
        [QMUITips hideAllTips];
        for (WatchWalletListInfo *dataVal in response) {
            if(dataVal.isDefault  == YES){
                self.walletModel = dataVal;
                isFind = YES;
            }
        }
        if(isFind == NO){
            self.emptyPopUpView.hidden = NO;
            completion();
        }else{
            self.emptyPopUpView.hidden = YES;
            completion();
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
        self.fullStackMain.hidden = YES;
        self.emptyPopUpView.hidden = NO;
        self.myTableView.hidden = YES;
    }];
}

-(void)getDataRequest:(void (^)(void))completion{
    [QMUITips showLoadingInView:self.view];
    C2CGetWalletDetailsRequest *request = [C2CGetWalletDetailsRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/observe/%ld",(long)self.walletModel.observeWalletId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CWatchWalletInfo class] success:^(NSArray* response) {
        self.WalletItemsList = response;
        completion();
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

@end
