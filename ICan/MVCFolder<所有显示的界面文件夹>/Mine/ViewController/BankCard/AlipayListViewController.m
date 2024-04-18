//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 13/11/2019
 - File name:  AlipayListViewController.m
 - Description:
 - Function List:
 */


#import "AlipayListViewController.h"
#import "BaseCell.h"
#import "BindingAlipayViewController.h"

static NSString*const KAlipayListCell=@"AlipayListCell";
static CGFloat const kHeihgtAlipayListCell = 50;
@interface AlipayListCell:BaseCell
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *accountLabel;
@property(nonatomic, strong) UIButton *deleteButton;
@property(nonatomic, strong) BindingAliPayListInfo *aliPayListInfo;
@property(nonatomic, copy) void (^deleteAlipaySuccessBlock)(void);
@end


@implementation AlipayListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
-(void)setAliPayListInfo:(BindingAliPayListInfo *)aliPayListInfo{
    _aliPayListInfo=aliPayListInfo;
    self.accountLabel.text=aliPayListInfo.account;
}
-(void)setUpUI{
    [super setUpUI];
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.left.equalTo(@10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentView addSubview:self.accountLabel];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.deleteButton.mas_left).offset(-10);
    }];
}
-(UILabel *)accountLabel{
    if (!_accountLabel) {
        _accountLabel=[UILabel leftLabelWithTitle:nil font:14 color:UIColor102Color];
    }
    return _accountLabel;
}
-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton=[UIButton dzButtonWithTitle:NSLocalizedString(@"Unbind", 去解绑) image:nil backgroundColor:nil titleFont:14 titleColor:UIColorThemeMainColor target:self action:@selector(deleButtonAction)];
        _deleteButton.titleLabel.textAlignment=NSTextAlignmentRight;
    }
    return _deleteButton;
}
-(void)deleButtonAction{
    
    [UIAlertController alertControllerWithTitle:NSLocalizedString(@"DeterminedtotieuptheAlipay?", 确定解绑该支付宝) message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        if (index==1) {
            [self deleteAlipayAccount];
        }
    }];
}
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc]init];
        _iconImageView.image=UIImageMake(@"wallet_alipayList_left_icon");
        [_iconImageView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        
    }
    return _iconImageView;
}
///解绑支付宝
-(void)deleteAlipayAccount{
    //    /bankCards/aliPay/{bindId}
    DeleteAlipayRequest*request=[DeleteAlipayRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/bankCards/aliPay/%@",self.aliPayListInfo.bindId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        !self.deleteAlipaySuccessBlock?:self.deleteAlipaySuccessBlock();
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
@end
@interface AlipayListFooterView : UIView
@property(nonatomic, strong) UIImageView *arrowImageView;
@property(nonatomic, strong) UILabel *tipsLabel;
@property(nonatomic, copy) void (^tapBlock)(void);
@end

@implementation AlipayListFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=UIColor.whiteColor;
        [self addSubview:self.tipsLabel];
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.width.equalTo(@13);
            make.height.equalTo(@13);
            make.centerY.equalTo(self.mas_centerY);
        }];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled=YES;
    }
    return self;
}
-(void)tapAction{
    !self.tapBlock?:self.tapBlock();
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        //        Add Alipay
        //Add other Alipay accounts
        _tipsLabel=[UILabel leftLabelWithTitle:NSLocalizedString(@"Add Alipay", 添加其他支付宝账号) font:14 color:UIColor153Color];
    }
    return _tipsLabel;
}
-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView=[[UIImageView alloc]init];
        _arrowImageView.image=UIImageMake(@"icon_arrow_right");
    }
    return _arrowImageView;
}
@end
@interface AlipayListViewController ()
@property(nonatomic, strong) AlipayListFooterView *footerView;
@property(nonatomic, strong) NSArray<BindingAliPayListInfo*> *alipayInfoItems;
@end

@implementation AlipayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorBg243Color;
    self.title=NSLocalizedString(@"mine.listView.cell.alipay", 支付宝);
    [self fetchBindingAlipayRequest];
}

-(void)initTableView{
    [super initTableView];
    self.tableView.backgroundColor=UIColorBg243Color;
    if ([UserInfoManager sharedManager].openPay) {
        self.tableView.tableFooterView=self.footerView;
    }
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registClassWithClassName:KAlipayListCell];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 38.0)];
    view.backgroundColor = UIColorBg243Color;
    UILabel * label = [UILabel leftLabelWithTitle:NSLocalizedString(@"Alipay binding", 支付宝绑定) font:14 color:UIColor102Color];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(view.mas_centerY);
    }];
    return view;
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.alipayInfoItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeihgtAlipayListCell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlipayListCell*cell=[tableView dequeueReusableCellWithIdentifier:KAlipayListCell];
    cell.aliPayListInfo=self.alipayInfoItems[indexPath.row];
    if ([UserInfoManager sharedManager].openPay) {
        cell.deleteButton.hidden=self.isFromWithdraw;
    }else{
        cell.deleteButton.hidden=YES;
    }
    
    cell.deleteAlipaySuccessBlock = ^{
        [self fetchBindingAlipayRequest];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFromWithdraw) {
        [self.navigationController popViewControllerAnimated:YES];
        !self.selectAlipyBlock?:self.selectAlipyBlock(self.alipayInfoItems[indexPath.row]);
    }
}
-(AlipayListFooterView *)footerView{
    if (!_footerView) {
        _footerView=[[AlipayListFooterView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        @weakify(self);
        _footerView.tapBlock = ^{
            @strongify(self);
            BindingAlipayViewController*vc=[[BindingAlipayViewController alloc]init];
            vc.bindingSuccessBlock = ^{
                @strongify(self);
                [self fetchBindingAlipayRequest];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _footerView;
}
-(void)fetchBindingAlipayRequest{
    BindingAliPayListRequest*request=[BindingAliPayListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[BindingAliPayListInfo class] success:^(NSArray* response) {
        self.alipayInfoItems=response;
        if (self.alipayInfoItems.count>0) {
            self.footerView.tipsLabel.text=NSLocalizedString(@"Add other Alipay accounts", 添加其他支付宝账号);
        }else{
            self.footerView.tipsLabel.text= NSLocalizedString(@"Add Alipay", 添加支付宝);
        }
        [self.tableView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
@end
