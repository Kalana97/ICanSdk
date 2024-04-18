//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 1/12/2021
- File name:  C2CPConfirmOrderSelectMethodPopView.m
- Description:
- Function List:
*/
        

#import "C2CPConfirmOrderSelectMethodPopView.h"
#import "C2CPaymentMethodTableViewCell.h"
@interface C2CPConfirmOrderSelectMethodPopView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation C2CPConfirmOrderSelectMethodPopView
-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kC2CPaymentMethodTableViewCell];
    self.titleLab.text = @"SelectPaymentMode".icanlocalized;
}
-(void)hiddenView{
    self.hidden = YES;
    [self removeFromSuperview];
}
-(void)showView:(BOOL)isBuyer{
    self.isBuyer = isBuyer;
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

-(void)setIsBuyer:(BOOL)isBuyer{
    _isBuyer = isBuyer;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    self.tableViewHeight.constant = self.tableView.contentSize.height;
}

-(void)setAdverDetailInfo:(C2CAdverInfo *)adverDetailInfo{
    _adverDetailInfo = adverDetailInfo;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    self.tableViewHeight.constant = self.tableView.contentSize.height;
}
-(void)setOrderInfo:(C2COrderInfo *)orderInfo{
    _orderInfo = orderInfo;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    self.tableViewHeight.constant = self.tableView.contentSize.height;
}
//隔断手势的传递链，不再向下传递，并且让cell成为响应者
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"C2CPConfirmOrderSelectMethodPopView"]) {
        // cell 不需要响应 父视图的手势，保证didselect 可以正常
        return YES;
    }
    return NO;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.orderInfo.transactionType isEqualToString:@"Sell"]) {
        return 1;
    }else{
        if(self.isBuyer){
            return self.minePaymentMethods.count;
        }
    }
    return self.adverDetailInfo.paymentMethods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CPaymentMethodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CPaymentMethodTableViewCell];
    cell.isHashShows = YES;
    if ([self.orderInfo.transactionType isEqualToString:@"Sell"]) {
        cell.paymentMethodInfo = self.orderInfo.sellPaymentMethod;
        cell.bottomLineView.hidden = YES;
    }else{
        if(self.isBuyer){
            cell.paymentMethodInfo = self.minePaymentMethods[indexPath.row];
            if (indexPath.row == self.minePaymentMethods.count-1) {
                cell.bottomLineView.hidden = YES;
            }else{
                cell.bottomLineView.hidden = NO;
            }
        }else{
            cell.paymentMethodInfo = self.adverDetailInfo.paymentMethods[indexPath.row];
            if (indexPath.row == self.adverDetailInfo.paymentMethods.count-1) {
                cell.bottomLineView.hidden = YES;
            }else{
                cell.bottomLineView.hidden = NO;
            }
        }
    }
    
    
    cell.cellType = C2CPaymentMethodTableViewCellTypeSelectMethodPopView;
    return cell;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.orderInfo.transactionType isEqualToString:@"Sell"]) {
        !self.selectBlock?:self.selectBlock(self.orderInfo.sellPaymentMethod);
    }else{
        if(self.isBuyer){
            !self.selectBlock?:self.selectBlock(self.minePaymentMethods[indexPath.row]);
        }else{
            !self.selectBlock?:self.selectBlock(self.adverDetailInfo.paymentMethods[indexPath.row]);

        }
    }
    [self hiddenView];
}


@end
