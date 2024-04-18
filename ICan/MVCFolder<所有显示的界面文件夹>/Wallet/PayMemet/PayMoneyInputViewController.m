
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 30/8/2021
 - File name:  PayMoneyInputViewController.m
 - Description:
 - Function List:
 */


#import "PayMoneyInputViewController.h"
#import "RechargeAmountCollectionCell.h"
#import "PayMoneyViewController.h"
#import "DecimalKeyboard.h"
@interface PayMoneyInputViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UILabel * yangLabel;
@property (nonatomic,strong) UITextField * amountTextField;

@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UIView * bottomView;
@property (nonatomic,strong) UILabel * allmAmountLabel;
@property (nonatomic,strong) UILabel * amountLabel;


@property (nonatomic,strong) NSIndexPath * selectIndexPath;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * rechargeChanelItems;


@property(nonatomic, strong) UIButton *footerButton;

@property(nonatomic, strong) GetPaymentListInfo *paymentInfo;
@end

@implementation PayMoneyInputViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =NSLocalizedString(@"payment", 付款);
    [self setUpView];
    [self getPaymentRequest];
}
-(void)setUpView{
    self.view.backgroundColor = UIColorViewBgColor;
    [self.view addSubview:self.yangLabel];
    [self.yangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.height.equalTo(@50);
        make.top.equalTo(@(NavBarHeight));
    }];
    [self.view addSubview:self.amountTextField];
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.height.equalTo(@50);
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.yangLabel);
    }];
    [self.view addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.equalTo(@(ScreenWidth-20));
        make.height.equalTo(@0.5);
        make.top.equalTo(self.amountTextField.mas_bottom);
    }];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.amountTextField.mas_bottom).offset(15);
        make.right.equalTo(@-10);
        make.height.equalTo(@80);
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@10);
        make.top.equalTo(self.collectionView.mas_bottom).offset(10);
    }];
    [self.view addSubview:self.allmAmountLabel];
    [self.allmAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.bottomView.mas_bottom);
        make.height.equalTo(@50);
    }];
    [self.view addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.allmAmountLabel.mas_centerY);
        make.height.equalTo(@50);
    }];
    [self.view addSubview:self.footerButton];
    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@44);
        make.top.equalTo(self.amountLabel.mas_bottom).offset(20);
    }];
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.amountTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField.inputView = decimalKeyboard;
    [self.amountTextField addTarget:self action:@selector(textFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.paymentInfo.list.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RechargeAmountCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:KIDRechargeAmountCollectionCell forIndexPath:indexPath];
    NSNumber * amountString = self.paymentInfo.list[indexPath.item];
    cell.amountLabel.text=amountString.stringValue;
    if (indexPath==self.selectIndexPath) {
        cell.contentView.backgroundColor = UIColorThemeMainColor;
        cell.amountLabel.textColor = [UIColor whiteColor];
    }else{
        cell.contentView.backgroundColor = UIColor10PxClearanceBgColor;
        cell.amountLabel.textColor = UIColorThemeMainSubTitleColor;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndexPath!=indexPath) {
        self.selectIndexPath=indexPath;
        NSNumber * amountString = self.paymentInfo.list[indexPath.item];
        self.amountTextField.text=amountString.stringValue;
        float amount = [amountString floatValue];
        self.amountLabel.text=[NSString stringWithFormat:@"¥%.2f",amount];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenWidth-60)/3,35);
    
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置section的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Lazy
-(UILabel *)yangLabel{
    if (!_yangLabel) {
        _yangLabel=[UILabel leftLabelWithTitle:@"￥" font:20 color:UIColorThemeMainTitleColor];
        _yangLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _yangLabel;
}
-(UITextField *)amountTextField{
    if (!_amountTextField) {
        _amountTextField=[[UITextField alloc]init];
        _amountTextField.keyboardType=UIKeyboardTypeDecimalPad;
        _amountTextField.font=[UIFont boldSystemFontOfSize:25];
        _amountTextField.text=@"100";
        _amountTextField.textColor =UIColorThemeMainTitleColor;
        _amountTextField.delegate=self;
        _amountTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        
    }
    return _amountTextField;
}
-(UILabel *)allmAmountLabel{
    if (!_allmAmountLabel) {
        _allmAmountLabel=[UILabel rightLabelWithTitle:NSLocalizedString(@"TotalAmount",合计金额) font:15 color:UIColorThemeMainSubTitleColor];
    }
    return _allmAmountLabel;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel=[UILabel rightLabelWithTitle:@"¥100.00" font:17 color:UIColorThemeMainColor];
    }
    return _amountLabel;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[UIView alloc]init];
        _bottomView.backgroundColor= UIColor10PxClearanceBgColor;
    }
    return _bottomView;
}
-(UIButton *)footerButton{
    if (!_footerButton) {
        _footerButton=[UIButton dzButtonWithTitle:@"Confirm".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:16 titleColor:UIColor.whiteColor target:self action:@selector(topUpWithChannelWay)];
        _footerButton.enabled=YES;
        [_footerButton setEnabledBGColor:UIColorThemeMainColor unEnabledBGColoor:UIColor153Color];
        [_footerButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    }
    return _footerButton;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=UIColorSeparatorColor;
    }
    return _lineView;
}
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout*lay=[[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection=UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _collectionView.dataSource                      = self;
        _collectionView.delegate                        = self;
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.showsHorizontalScrollIndicator  = NO;
        _collectionView.scrollEnabled                   = YES;
        _collectionView.backgroundColor                 = UIColorViewBgColor;
        [_collectionView registerNib:[UINib nibWithNibName:KIDRechargeAmountCollectionCell bundle:nil] forCellWithReuseIdentifier:KIDRechargeAmountCollectionCell];
        
    }
    return _collectionView;
}
#pragma mark - Event
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)textFieldValueChanged {
    float amount = [self.amountTextField.text floatValue];
    self.amountLabel.text=[NSString stringWithFormat:@"¥%.2f",amount];
    NSLog(@"Text field value changed: %@", self.amountTextField.text);
}
-(void)topUpWithChannelWay{
    double money=self.amountTextField.text.doubleValue;
    if (self.paymentInfo.moneyMin<=money&&money<=self.paymentInfo.moneyMax) {
        PayMoneyViewController*vc=[[PayMoneyViewController alloc]init];
        vc.amount=self.amountTextField.text;
        vc.info=self.paymentInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString*tipsStr=[NSString stringWithFormat:@"%@￥%.2f,%@￥%.2f",@"MaximumAmount".icanlocalized,self.paymentInfo.moneyMax,@"MinimumAmount".icanlocalized,self.paymentInfo.moneyMin];
        [UIAlertController alertControllerWithTitle:@"Attention".icanlocalized message:tipsStr target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            
        }];
    }
   
}
-(void)textChangeAction:(NSNotification*)noti{
    float amount = [self.amountTextField.text floatValue];
    self.amountLabel.text=[NSString stringWithFormat:@"¥%.2f",amount];
    self.selectIndexPath=NULL;
    [self.collectionView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    //第一个参数，被替换字符串的range，第二个参数，即将键入或者粘贴的string，返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //正则表达式
    if (checkStr.length>8) {
        return NO;
    }
    
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    return [self isValid:checkStr withRegex:regex];
}
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}
-(void)reloadUI{
    [self.collectionView reloadData];
    CGFloat height= self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.amountTextField.mas_bottom).offset(15);
        make.right.equalTo(@-10);
        make.height.equalTo(@(height));
    }];
}
#pragma mark - Networking
-(void)getPaymentRequest{
    GetPayQRCodePaymentListRequest*request=[GetPayQRCodePaymentListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetPaymentListInfo class] contentClass:[GetPaymentListInfo class] success:^(GetPaymentListInfo* response) {
        self.paymentInfo=response;
        [self reloadUI];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
@end
