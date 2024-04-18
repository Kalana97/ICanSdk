//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletSelectAddressView.m
- Description:
- Function List:
*/
        

#import "IcanWalletSelectAddressView.h"
#import "IcanWalletSelectAddressViewTableViewCell.h"
@interface IcanWalletSelectAddressView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, weak) IBOutlet UIView *nullTipsView;
@property(nonatomic, weak) IBOutlet UILabel *nullTipsLabel;
@property(nonatomic, weak) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end
@implementation IcanWalletSelectAddressView

-(void)awakeFromNib{
    [super awakeFromNib];
//    "C2CSelectWithdrawAddress"="选择地址";
//    "C2CWithdrawAddressNoAddress"="您还没有地址";
//    "C2CAddWithdrawAddress"="添加新地址";
    [self.tableView registNibWithNibName:kIcanWalletSelectAddressViewTableViewCell];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    self.titleLabel.text = @"C2CSelectWithdrawAddress".icanlocalized;
    self.nullTipsLabel.text = @"C2CWithdrawAddressNoAddress".icanlocalized;
    [self.addBtn setTitle:@"C2CAddWithdrawAddress".icanlocalized forState:UIControlStateNormal];
}
-(void)setAddressItems:(NSArray<ICanWalletAddressInfo *> *)addressItems{
    _addressItems = addressItems;
    if (addressItems.count>0) {
        self.tableView.hidden = NO;
        self.nullTipsView.hidden = YES;
    }else{
        self.tableView.hidden = YES;
        self.nullTipsView.hidden = NO;
    }
    [self.tableView reloadData];
}
-(IBAction)addBtnAction{
    [self hiddenView];
    !self.addAddressBlock?:self.addAddressBlock();
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IcanWalletSelectAddressViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIcanWalletSelectAddressViewTableViewCell];
    ICanWalletAddressInfo*info = self.addressItems[indexPath.row];
    cell.addressInfo = info;
    cell.didSelectBlock = ^{
        !self.selectBlock?:self.selectBlock(self.addressItems[indexPath.row]);
        [self hiddenView];
    };
    cell.deleteBlock = ^{
        NSMutableArray * array = [NSMutableArray arrayWithArray:self.addressItems];
        [array removeObject:info];
        self.addressItems = [array copy];
        [self.tableView reloadData];
        DeleteIcanWalletAddressRequest* request  = [DeleteIcanWalletAddressRequest request];
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/address/%ld",info.addressId];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CBaseResponse class] contentClass:[C2CBaseResponse class] success:^(id  _Nonnull response) {
            
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            
        }];
        [self hiddenView];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
-(void)hiddenView{
    self.bottomConstraint.constant = -320;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)showView{
    
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.2);
        [self layoutIfNeeded];
    }];
}
@end
