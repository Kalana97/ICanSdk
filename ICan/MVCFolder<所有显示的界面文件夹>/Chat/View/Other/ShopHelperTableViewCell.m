//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 20/12/2021
- File name:  ShopHelperTableViewCell.m
- Description:
- Function List:
*/
        

#import "ShopHelperTableViewCell.h"
#import "ShopHelperProductCell.h"
@interface ShopHelperTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productHeight;

@property (weak, nonatomic) IBOutlet UIImageView *shoplogo;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;

@property (weak, nonatomic) IBOutlet UIView *orderTimeBgView;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopNameTitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *addressBgView;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *paywayBgView;
@property (weak, nonatomic) IBOutlet UILabel *paywayTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *paywayLabel;
///运费
@property (weak, nonatomic) IBOutlet UILabel *courierFeeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courierFeeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalAmountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
///备注
@property (weak, nonatomic) IBOutlet UIView *remarkBgView;
@property (weak, nonatomic) IBOutlet UILabel *remarkTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;


@end
@implementation ShopHelperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.tableView registNibWithNibName:kShopHelperProductCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setInfo:(ShopHelperMsgInfo *)info{
    _info=info;
//    Order Number
    self.orderIdTitleLabel.text = @"Order Number".icanlocalized;
    self.orderTimeTitleLabel.text = @"Time".icanlocalized;
//    "PaymentMethod"="支付方式";
//    "ReceivingAddress"="收货地址";
//    "Productname"="商品名称";
//    "ShippingFee"="运费";
    self.paywayTitleLabel.text = @"PaymentMethod".icanlocalized;
    self.shopNameTitleLabel.text = @"Productname".icanlocalized;
    self.addressTitleLabel.text = @"ReceivingAddress".icanlocalized;
    self.courierFeeTitleLabel.text = @"ShippingFee".icanlocalized;
    self.totalAmountTitleLabel.text = @"Total".icanlocalized;
    self.remarkTitleLabel.text = @"Remark".icanlocalized;
    [self.shoplogo setImageWithString:info.avatar placeholder:DefaultImg];
    self.shopNameLabel.text = info.name;
    self.orderTimeLabel.text = [GetTime convertDateWithString:info.time dateFormmate:@"yyyy-MM-dd HH:mm:dd"];
    if (info.payType) {
        self.paywayBgView.hidden = NO;
    }else{
        self.paywayBgView.hidden = YES;
    }
    if (info.remark) {
        self.remarkBgView.hidden = NO;
    }else{
        self.remarkBgView.hidden = YES;
    }
    if (info.time) {
        self.orderTimeBgView.hidden = NO;
    }else{
        self.orderTimeBgView.hidden = YES;
    }
    if (info.address) {
        self.addressBgView.hidden = NO;
    }else{
        self.addressBgView.hidden = YES;
    }
    self.remarkLabel.text = info.remark;
    self.titleLabel.text = info.title;
    self.orderIdLabel.text = info.orderId;
    self.addressLabel.text = info.address;
    self.paywayLabel.text = info.payType;
    self.courierFeeLabel.text = [NSString stringWithFormat:@"￥%.2f",info.courierFee.floatValue];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"￥%.2f",info.totalMoney.floatValue];
    NSInteger count = self.info.productInfo.count;
    self.productHeight.constant = count*20+15;
    
    [self.tableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.info.productInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopHelperProductCell*cell = [tableView dequeueReusableCellWithIdentifier:kShopHelperProductCell];
    NSDictionary * dict = self.info.productInfo[indexPath.row];
    cell.goodNameLabel.text = dict.allKeys.firstObject;
    cell.countLabel.text = dict.allValues.firstObject;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}
@end
