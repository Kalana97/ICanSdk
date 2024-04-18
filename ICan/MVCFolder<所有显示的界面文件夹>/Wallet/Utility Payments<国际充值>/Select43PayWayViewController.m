
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 6/7/2021
 - File name:  Select43PayWayViewController.m
 - Description:
 - Function List:
 */


#import "Select43PayWayViewController.h"
#import "Select43PayWayHeadView.h"
#import "Select43PayWayCell.h"
#import "Select43PayWayFooterView.h"
#import "ShowUtilityFavoritesView.h"
#import "PayResultWebViewController.h"
#import "UtilityPaymentsSuccessViewController.h"
@interface Select43PayWayViewController ()
@property(nonatomic, strong) Select43PayWayHeadView *headView;
@property(nonatomic, strong) Select43PayWayFooterView *footerView;
@property(nonatomic, strong) QuickPayInfo *savePayInfo;
@property(nonatomic, strong) QuickPayInfo *selectPaywayInfo;
@property(nonatomic, strong) NSMutableArray *paywayItems;
@property(nonatomic, strong)  ShowUtilityFavoritesView *favoritesView;
@end

@implementation Select43PayWayViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Select43PayWayFooterView.payBtn".icanlocalized;
    [self.tableView registerNib:[UINib nibWithNibName:kSelect43PayWayHeadView bundle:nil] forHeaderFooterViewReuseIdentifier:kSelect43PayWayHeadView];
    [self.tableView registNibWithNibName:kSelect43PayWayCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSelect43PayWayFooterView bundle:nil] forHeaderFooterViewReuseIdentifier:kSelect43PayWayFooterView];
    self.savePayInfo=[[QuickPayInfo alloc]init];
    //    "Select43PayWayViewController.savePayInfo"="保存并支付";
    //    "Select43PayWayViewController.noSavePayInfo"="不保存支付";
    self.savePayInfo.bankNum=@"Select43PayWayViewController.savePayInfo".icanlocalized;
    
    self.savePayInfo.select=YES;
    self.selectPaywayInfo=self.savePayInfo;
    [self.paywayItems addObject:self.savePayInfo];
    [self getQuickInfoRequest];
}
-(void)initTableView{
    [super initTableView];
}
#pragma mark - Getter
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headView= [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSelect43PayWayHeadView];
    if (self.isRechargeBalance) {
        self.headView.amountLabel.text=[NSString stringWithFormat:@"￥%.2f",self.amount.doubleValue];
    }else{
        self.headView.amountLabel.text=[NSString stringWithFormat:@"%@ %.2f",self.currencyCode,self.amount.doubleValue];
    }
    
    return self.headView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    self.footerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:kSelect43PayWayFooterView];
    @weakify(self);
    self.footerView.payBlock = ^{
        @strongify(self);
        [self payRequest];
    };
    self.footerView.clearBlock = ^{
        @strongify(self);
        [self clearRequest];
    };
    return self.footerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.paywayItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuickPayInfo*info=self.paywayItems[indexPath.row];
    UITableViewRowAction * deleted = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[@"timeline.post.operation.delete" icanlocalized:@"删除"] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"DeleteBankcardTips", 是否删除银行卡) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ClearQuickPayInfoRequest*request=[ClearQuickPayInfoRequest request];
            request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/quickPayInfo/%@",info.ID];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                [self getQuickInfoRequest];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
            }];
            
        }];
        [alert addAction:cancel];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }];
    
    return info==self.savePayInfo?nil:@[deleted];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Select43PayWayCell*cell=[tableView dequeueReusableCellWithIdentifier:kSelect43PayWayCell];
    cell.info=self.paywayItems[indexPath.row];
    cell.selectBlock = ^{
        [self tapAction:indexPath];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tapAction:indexPath];
}
-(void)tapAction:(NSIndexPath *)indexPath{
    QuickPayInfo*nowSelectInfo=[self.paywayItems objectAtIndex:indexPath.row];
    if (nowSelectInfo==self.selectPaywayInfo) {
        self.selectPaywayInfo.select=!self.selectPaywayInfo.select;
    }else{
        for (QuickPayInfo*info in self.paywayItems) {
            info.select=NO;
        }
        nowSelectInfo.select=YES;
        self.selectPaywayInfo=nowSelectInfo;
    }
    [self.tableView reloadData];
}
#pragma mark - Lazy
-(NSMutableArray *)paywayItems{
    if (!_paywayItems) {
        _paywayItems=[NSMutableArray array];
    }
    return _paywayItems;
}
#pragma mark - Event
#pragma mark - Networking
-(void)getQuickInfoRequest{
    GetQuickPayInfoListRequest*request=[GetQuickPayInfoListRequest request];
    request.channelCode=self.selectChannelInfo.channelCode;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[QuickPayInfo class] success:^(NSArray<QuickPayInfo*>* response) {
        if (response.count>0) {
            QuickPayInfo*info=response.lastObject;
            info.select=YES;
            self.savePayInfo.select=NO;
            self.selectPaywayInfo=info;
        }
        self.paywayItems=[NSMutableArray arrayWithArray:response];
        [self.paywayItems addObject:self.savePayInfo];
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)payRequest{
    if (self.isRechargeBalance) {
        RechargeRequest*request=[RechargeRequest request];
        //如果存在选中
        if (self.selectPaywayInfo.select) {
            if (self.selectPaywayInfo==self.savePayInfo ) {
                request.isSaveCard=@(YES);
            }else{
                request.quickPayInfoId=self.selectPaywayInfo.ID;
                
            }
        }else{
            request.isSaveCard=@(NO);
        }
        request.payType=self.selectChannelInfo.channelCode;
        request.orderAmount=self.amount;
        request.parameters=[request mj_JSONObject];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[RechargeInfo class] contentClass:[RechargeInfo class] success:^(RechargeInfo* response) {
            if (response.payUrl) {
                NSString*payurl=response.payUrl.netUrlEncoded;
                PayResultWebViewController*vc=[[PayResultWebViewController alloc]init];
                if (payurl.length>0) {
                    vc.payUrl=payurl;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:response.payInfo]]) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:response.payInfo] options:@{} completionHandler:nil];
                    
                }
            }
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
    }else{
        PostDialogPaymentRequest*request=[PostDialogPaymentRequest request];
        request.channelId=self.selectChannelInfo.ID;
        if (self.selectPaywayInfo.select) {
            //如果当前选择的是保存并支付 那就是没有选择卡号 需要跳转到webView进行输入卡号支付
            if (self.selectPaywayInfo==self.savePayInfo ) {
                request.saveCard=@(YES);
            }else{
                request.quickPayId=self.selectPaywayInfo.ID;
                
            }
        }else{
            request.saveCard=@(NO);
        }
        request.parameters=[request mj_JSONObject];
        [QMUITipsTool showLoadingWihtMessage:@"Processing".icanlocalized inView:self.view isAutoHidden:NO];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[DialogPaymentInfo class] contentClass:[DialogPaymentInfo class] success:^(DialogPaymentInfo* response) {
            [QMUITips hideAllTips];
            if ([response.status isEqualToString:@"Paying"]) {
                //检查是否收藏
                CheckDialogFavoritesRequest*request=[CheckDialogFavoritesRequest request];
                if (self.isFromFavorite) {
                    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@/%@",self.dialogInfo.dialogId,self.mobile];
                }else{
                    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@/%@",self.dialogInfo.ID,self.mobile];
                }
                
                [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* sresponse) {
                    if ([sresponse isEqualToString:@"true"]) {
                        [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:NO];
                        
                    }else{
                        self.favoritesView=[[NSBundle mainBundle]loadNibNamed:@"ShowUtilityFavoritesView" owner:self options:nil].firstObject;
                        self.favoritesView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                        self.favoritesView.info=self.dialogInfo;
                        [self.favoritesView showFavoritesView];
                        @weakify(self);
                        self.favoritesView.sureBlock = ^{
                            @strongify(self);
                            if (self.favoritesView.nameTextField.text.trimmingwhitespaceAndNewline.length==0) {
                                [QMUITipsTool showOnlyTextWithMessage:@"UtilityPaymentsPayViewController.tipError".icanlocalized inView:self.view];
                                return;
                            }
                            //添加收藏
                            PostDialogFavoritesRequest*request=[PostDialogFavoritesRequest request];
                            request.dialogId=self.dialogInfo.ID;
                            request.nickname=self.favoritesView.nameTextField.text;
                            request.accountNumber=self.mobile;
                            request.parameters=[request mj_JSONObject];
                            [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                                [self.favoritesView hiddenFavoritesView];
                                [[NSNotificationCenter defaultCenter]postNotificationName:KClickDialogFavoriteButotnNotification object:nil userInfo:nil];
                                [QMUITips showSucceed:@"AddSuccess".icanlocalized inView:self.view];
                            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                                [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
                            }];
                            
                            [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:NO];
                        };
                        self.favoritesView.cancelBlock = ^{
                            @strongify(self);
                            [self checkPaySuccessWithDialogPaymentInfo:response shouldCheck:YES];
                        };
                        
                        
                        
                    }
                } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                    
                }];
            }else{
                [QMUITipsTool showErrorWihtMessage:@"Top-upFailure".icanlocalized inView:self.view];
            }
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
    
    
    
}
-(void)checkPaySuccessWithDialogPaymentInfo:(DialogPaymentInfo*)info shouldCheck:(BOOL)shouldCheck{
    NSString*payurl=info.redirectUrl.netUrlEncoded;
    PayResultWebViewController*vc=[[PayResultWebViewController alloc]init];
    if (payurl.length>0) {
        vc.payUrl=payurl;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UtilityPaymentsSuccessViewController*vc=[[UtilityPaymentsSuccessViewController alloc]init];
        vc.dialogPaymentInfo=info;
        vc.dialogInfo=self.dialogInfo;
        vc.mobile=self.mobile;
        vc.shouldCheck=shouldCheck;
        vc.isFromFavorite=self.isFromFavorite;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)clearRequest{
    if (self.selectPaywayInfo!=self.savePayInfo) {
        ClearQuickPayInfoRequest*request=[ClearQuickPayInfoRequest request];
        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/quickPayInfo/%@",self.selectPaywayInfo.ID];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
            [self getQuickInfoRequest];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
    
}
@end
