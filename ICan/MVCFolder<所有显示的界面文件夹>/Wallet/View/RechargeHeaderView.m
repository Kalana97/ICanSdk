//
//  RechargeHeaderView.m
//  fortune
//
//  Created by lidazhi on 2019/1/17.
//  Copyright © 2019 DW. All rights reserved.
//

#import "RechargeHeaderView.h"
#import "RechargeAmountCollectionCell.h"
@interface RechargeHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UILabel * yangLabel;

@property (nonatomic,strong) UIView * lineView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UIView * bottomView;
@property (nonatomic,strong) UILabel * allmAmountLabel;
@property (nonatomic,strong) UILabel * amountLabel;
@property (nonatomic,strong) NSArray * amountArray;

@property (nonatomic,strong) NSIndexPath * selectIndexPath;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * rechargeChanelItems;

@end
@implementation RechargeHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.selectIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChangeAction:) name:UITextFieldTextDidChangeNotification object:self.amountTextField];
    }
    return self;
}
-(void)setUpView{
    self.backgroundColor= UIColorViewBgColor;
    [self addSubview:self.yangLabel];
    [self.yangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.height.equalTo(@50);
        make.top.equalTo(@5);
    }];
    [self addSubview:self.amountTextField];
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.height.equalTo(@50);
        make.right.equalTo(@-10);
        make.top.equalTo(@5);
    }];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.equalTo(@(ScreenWidth-20));
        make.height.equalTo(@0.5);
        make.top.equalTo(@55);
    }];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(self.amountTextField.mas_bottom).offset(15);
        make.right.equalTo(@-10);
        make.bottom.equalTo(@-65);
    }];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@10);
        make.bottom.equalTo(@-50);
    }];
    [self addSubview:self.allmAmountLabel];
    [self.allmAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.bottom.equalTo(@0);
        make.height.equalTo(@50);
    }];
    [self addSubview:self.amountLabel];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.bottom.equalTo(@0);
        make.height.equalTo(@50);
    }];
}

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
        _allmAmountLabel=[UILabel rightLabelWithTitle:NSLocalizedString(@"TotalAmount",合计金额) font:15 color:UIColorMake(153, 153, 153)];
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
        _bottomView.backgroundColor=UIColor10PxClearanceBgColor;
    }
    return _bottomView;
}
-(void)textChangeAction:(NSNotification*)noti{
    if (!self.amountTextField.markedTextRange) {
        float amount = [self.amountTextField.text floatValue];
        self.amountLabel.text=[NSString stringWithFormat:@"¥%.2f",amount];
        self.selectIndexPath=NULL;
        [self.collectionView reloadData];
    }
    
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
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=UIColorSeparatorColor;
    }
    return _lineView;
}
-(NSArray *)amountArray{
    return @[@"100",@"200",@"300",@"500",@"1000",@"2000"];
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
        _collectionView.backgroundColor                 = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:KIDRechargeAmountCollectionCell bundle:nil] forCellWithReuseIdentifier:KIDRechargeAmountCollectionCell];
        
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.amountArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RechargeAmountCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:KIDRechargeAmountCollectionCell forIndexPath:indexPath];
    cell.amountLabel.text=self.amountArray[indexPath.item];
    if (indexPath==self.selectIndexPath) {
        cell.contentView.backgroundColor = UIColorThemeMainColor;
        cell.amountLabel.textColor = [UIColor whiteColor];
    }else{
        cell.contentView.backgroundColor = UIColorBg243Color;
        cell.amountLabel.textColor = UIColorMake(153, 153, 153);
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndexPath!=indexPath) {
        self.selectIndexPath=indexPath;
        self.amountTextField.text=self.amountArray[indexPath.item];
        
        
        NSString * amountString = self.amountArray[indexPath.item];
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


@end
