//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 22/11/2021
 - File name:  SelectReceiveMethodViewController.m
 - Description:
 - Function List:
 */


#import "SelectReceiveMethodViewController.h"

#import "SelectReceiveMethodFooterView.h"
#import "C2CAddBankCardViewController.h"
#import "C2CAddCashViewController.h"
#import "C2CAddWeChatOrAlipayViewController.h"
#import "C2CPaymentMethodTableViewCell.h"
#import "SelectReceiveMethodPopView.h"
@interface SelectReceiveMethodViewController ()
@property (nonatomic, strong) NSArray<C2CPaymentMethodInfo*> *typeItems;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, strong) SelectReceiveMethodPopView *popView;
@end
@implementation SelectReceiveMethodViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    "SelectReceiveMethodViewControllerTitle"="C2C收款方式";
//    "SelectReceiveMethodViewControllerAddTitle"="添加收款方式";
    self.title = @"SelectReceiveMethodViewControllerTitle".icanlocalized;
    [self.addButton setTitle:@"SelectReceiveMethodViewControllerAddTitle".icanlocalized forState:UIControlStateNormal];
    switch (self.type) {

        case SelectReceiveMethodType_Sale:{
            self.popView.addAlipayBgCon.hidden = !self.adverDetailInfo.supportAliPay;
            self.popView.addBankCardBgCon.hidden = !self.adverDetailInfo.supportBankTransfer;
            self.popView.addWeChatBgCon.hidden = !self.adverDetailInfo.supportWechat;
            [self getPaymentMethodRequest];
        }
            break;
        case SelectReceiveMethodType_PublishAdver:{
//            Wechat,AliPay,BankTransfer
            self.popView.addAlipayBgCon.hidden = ![self.currentCurrencyInfo.supportPaymentMethodType containsString:@"AliPay"];
            self.popView.addBankCardBgCon.hidden = ![self.currentCurrencyInfo.supportPaymentMethodType containsString:@"BankTransfer"];
            self.popView.addWeChatBgCon.hidden = ! [self.currentCurrencyInfo.supportPaymentMethodType containsString:@"Wechat"];;
            [self getPaymentMethodRequest];
        }
            break;
        case SelectReceiveMethodType_Mine:{
            [self getPaymentMethodRequest];
        }
            break;
            
        default:
            break;
    }
    [[C2CUserManager shared]getC2COssTokenRequest:^{
        
    }];
    
    
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.tableView registNibWithNibName:kC2CPaymentMethodTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo (@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@-90);
    }];
    
}


-(IBAction)addButtonAction{
    [self.popView showView];
    
}
-(void)layoutTableView{
    
}


-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction * deleted = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[@"timeline.post.operation.delete" icanlocalized:@"删除"] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteMethodRequest:indexPath];
        
    }];
    if (self.type == SelectReceiveMethodType_Mine) {
        return @[deleted];
    }
    return nil;
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.typeItems.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    C2CPaymentMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CPaymentMethodTableViewCell];
    cell.paymentMethodInfo = self.typeItems[indexPath.row];
    cell.isHashShows = NO;
    cell.cellType = C2CPaymentMethodTableViewCellTypeMineList;
    if (indexPath.row == self.typeItems.count-1) {
        cell.bottomLineView.hidden = YES;
    }else{
        cell.bottomLineView.hidden = NO;
    }
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == SelectReceiveMethodType_Sale) {
        !self.selectReceiveMethodBlock?:self.selectReceiveMethodBlock(self.typeItems[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.type == SelectReceiveMethodType_PublishAdver){
        !self.selectReceiveMethodBlock?:self.selectReceiveMethodBlock(self.typeItems[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(SelectReceiveMethodPopView *)popView{
    if (!_popView) {
        _popView = [[NSBundle mainBundle]loadNibNamed:@"SelectReceiveMethodPopView" owner:self options:nil].firstObject;
        _popView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        @weakify(self);
        _popView.addWeChatBlock = ^{
            @strongify(self);
            C2CAddWeChatOrAlipayViewController * vc = [[C2CAddWeChatOrAlipayViewController alloc]init];
            vc.isWeChat = YES;
            vc.addSuccessBlock = ^{
                [self getPaymentMethodRequest];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        _popView.addAlipayBlock = ^{
            @strongify(self);
            C2CAddWeChatOrAlipayViewController * vc = [[C2CAddWeChatOrAlipayViewController alloc]init];
            vc.isWeChat = NO;
            vc.addSuccessBlock = ^{
                [self getPaymentMethodRequest];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        _popView.addBankCardBlock = ^{
            @strongify(self);
            C2CAddBankCardViewController * vc = [[C2CAddBankCardViewController alloc]init];
            vc.addSuccessBlock = ^{
                [self getPaymentMethodRequest];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        _popView.addCashBlock = ^{
            @strongify(self);
            C2CAddCashViewController * vc = [[C2CAddCashViewController alloc]init];
            vc.addSuccessBlock = ^{
                [self getPaymentMethodRequest];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        
    }
    return _popView;
}
-(void)getPaymentMethodRequest{
    C2CGetPaymentMethodRequest * request = [C2CGetPaymentMethodRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CPaymentMethodInfo class] success:^(NSArray<C2CPaymentMethodInfo*>* response) {
        if (response.count==0) {
            [self showEmptyViewWithLoading:NO image:UIImageMake(@"img_c2c_orderlist_nulltips") text:@"NoPaymentMethodCurrentlyAvailable".icanlocalized detailText:nil buttonTitle:nil buttonAction:nil];
        }else{
            [self hideEmptyView];
        }
        self.typeItems = response;
        NSMutableArray * saleTypeItems = [NSMutableArray array];
        if (self.type == SelectReceiveMethodType_Sale) {
            if (self.adverDetailInfo.supportBankTransfer) {
                NSPredicate * predicte = [NSPredicate predicateWithFormat:@"paymentMethodType contains [cd] %@ ",@"BankTransfer"];
                [saleTypeItems addObjectsFromArray:[self.typeItems filteredArrayUsingPredicate:predicte]];
            }
            /** 收款类型,可用值:Wechat,AliPay,BankTransfer     */
            if (self.adverDetailInfo.supportWechat) {
                NSPredicate * predicte = [NSPredicate predicateWithFormat:@"paymentMethodType contains [cd] %@ ",@"Wechat"];
                [saleTypeItems addObjectsFromArray:[self.typeItems filteredArrayUsingPredicate:predicte]];
            }
            if (self.adverDetailInfo.supportAliPay) {
                NSPredicate * predicte = [NSPredicate predicateWithFormat:@"paymentMethodType contains [cd] %@ ",@"AliPay"];
                [saleTypeItems addObjectsFromArray:[self.typeItems filteredArrayUsingPredicate:predicte]];
            }
            if (self.adverDetailInfo.supportCash) {
                NSPredicate * predicte = [NSPredicate predicateWithFormat:@"paymentMethodType contains [cd] %@ ",@"Cash"];
                [saleTypeItems addObjectsFromArray:[self.typeItems filteredArrayUsingPredicate:predicte]];
            }
            self.typeItems = saleTypeItems;
        }else if (self.type == SelectReceiveMethodType_PublishAdver){
//            Wechat,AliPay,BankTransfer
            if ([self.currentCurrencyInfo.supportPaymentMethodType containsString:@"BankTransfer"]) {
                NSPredicate * predicte = [NSPredicate predicateWithFormat:@"paymentMethodType contains [cd] %@ ",@"BankTransfer"];
                [saleTypeItems addObjectsFromArray:[self.typeItems filteredArrayUsingPredicate:predicte]];
            }
            if ([self.currentCurrencyInfo.supportPaymentMethodType containsString:@"Wechat"]) {
                NSPredicate * predicte = [NSPredicate predicateWithFormat:@"paymentMethodType contains [cd] %@ ",@"Wechat"];
                [saleTypeItems addObjectsFromArray:[self.typeItems filteredArrayUsingPredicate:predicte]];
            }
            if ([self.currentCurrencyInfo.supportPaymentMethodType containsString:@"AliPay"]) {
                NSPredicate * predicte = [NSPredicate predicateWithFormat:@"paymentMethodType contains [cd] %@ ",@"AliPay"];
                [saleTypeItems addObjectsFromArray:[self.typeItems filteredArrayUsingPredicate:predicte]];
            }
            if ([self.currentCurrencyInfo.supportPaymentMethodType containsString:@"Cash"]) {
                NSPredicate * predicte = [NSPredicate predicateWithFormat:@"paymentMethodType contains [cd] %@ ",@"Cash"];
                [saleTypeItems addObjectsFromArray:[self.typeItems filteredArrayUsingPredicate:predicte]];
            }
            self.typeItems = saleTypeItems;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)deleteMethodRequest:(NSIndexPath*)index{
    C2CPaymentMethodInfo * info = self.typeItems[index.row];
    C2CDeleteMyPaymentMethodRequest * request = [C2CDeleteMyPaymentMethodRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/paymentMethod/%@",info.paymentMethodId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        NSMutableArray * array = [NSMutableArray arrayWithArray:self.typeItems];
        [array removeObject:info];
        self.typeItems = array;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
    
}
@end
