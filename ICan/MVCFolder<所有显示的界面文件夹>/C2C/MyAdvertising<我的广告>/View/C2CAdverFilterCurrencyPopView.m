//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "C2CAdverFilterCurrencyPopView.h"
#import "C2CAdverFilterCurrencyPopViewCurrencyCell.h"
@interface C2CAdverFilterCurrencyPopView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *allCurrencyBgView;
@property (weak, nonatomic) IBOutlet UILabel *allCurrencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allStateImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<CurrencyInfo*> *currencyItmes;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@end
@implementation C2CAdverFilterCurrencyPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.allCurrencyLabel.text = @"C2CAdverFilterCurrencyPopViewAllCurrency".icanlocalized;
    
    UITapGestureRecognizer * tap15 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.allCurrencyBgView addGestureRecognizer:tap15];
   
    [self.tableView registNibWithNibName:kC2CAdverFilterCurrencyPopViewCurrencyCell];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type contains [cd] %@ ",@"VirtualCurrency"];
    self.currencyItmes =  [C2CUserManager.shared.allSupportedCurrencyItems filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
    CGFloat height = self.currencyItmes.count*60;
    if (height>250) {
        height = 240;
    }
    self.tableViewHeight.constant = height;
    //设置默认值
    self.allStateImgView.hidden = NO;
    self.allCurrencyLabel.textColor = UIColorThemeMainColor;
    self.selectIndexPath = nil;
    self.hidden = YES;
}

-(void)tapAction:(UITapGestureRecognizer*)gest{
    
    !self.selectBlock?:self.selectBlock(@"C2CAdverFilterCurrencyPopViewAllCurrency".icanlocalized);
    self.allStateImgView.hidden = NO;
    self.allCurrencyLabel.textColor = UIColorThemeMainColor;
    self.selectIndexPath = nil;
    [self.tableView reloadData];
    [self hiddenView];
}

-(void)hiddenView{
    self.hidden = YES;
    !self.hiddenBlock?:self.hiddenBlock();
    [self removeFromSuperview];
}
-(void)showView{
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
//隔断手势的传递链，不再向下传递，并且让cell成为响应者
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        // cell 不需要响应 父视图的手势，保证didselect 可以正常
        return NO;
    }
    return YES;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
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
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.currencyItmes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CAdverFilterCurrencyPopViewCurrencyCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CAdverFilterCurrencyPopViewCurrencyCell];
    cell.currencyInfo = self.currencyItmes[indexPath.row];
    if (self.selectIndexPath) {
        cell.allStateImgView.hidden = self.selectIndexPath!=indexPath;
        cell.allStateLabel.textColor = self.selectIndexPath!=indexPath?UIColor252730Color:UIColorThemeMainColor;
    }else{
        cell.allStateImgView.hidden = YES;
        cell.allStateLabel.textColor = UIColor252730Color;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.allStateImgView.hidden = YES;
    self.allCurrencyLabel.textColor = UIColor252730Color;
    if (self.selectIndexPath == indexPath) {
        return;
    }
    self.selectIndexPath = indexPath;
    !self.selectBlock?:self.selectBlock(self.currencyItmes[indexPath.row].code);
    [self.tableView reloadData];
    [self hiddenView];
    
    
}


@end
