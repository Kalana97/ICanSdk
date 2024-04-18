//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletSelectAddressView.m
- Description:
- Function List:
*/
        

#import "IcanWalletSelecMainNetworkPopView.h"
#import "IcanSelectMainNetworkPopViewTableViewCell.h"

@interface IcanWalletSelecMainNetworkPopView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end
@implementation IcanWalletSelecMainNetworkPopView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.tableView registNibWithNibName:@"IcanSelectMainNetworkPopViewTableViewCell"];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
//    "MainNetworkViewTitle"="选择主网";
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
//    self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.2);
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.shadowColor = UIColor.blackColor.CGColor;
    //阴影偏移
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    self.bgView.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    self.bgView.layer.shadowRadius = 5;
}

-(void)setMainNetworkItems:(NSArray<ICanWalletMainNetworkInfo *> *)mainNetworkItems{
    _mainNetworkItems = mainNetworkItems;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    self.tableViewHeight.constant = self.tableView.contentSize.height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mainNetworkItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IcanSelectMainNetworkPopViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IcanSelectMainNetworkPopViewTableViewCell"];
    cell.mainNetworkInfo = self.mainNetworkItems[indexPath.row];
    cell.didSelectBlock = ^{
        !self.selectBlock?:self.selectBlock(self.mainNetworkItems[indexPath.row]);
        [self hiddenView];
    };
    return cell;
}

-(void)hiddenView{
    self.hidden = YES;
}
-(void)showViewWithY:(CGFloat)y{
    self.hidden = NO;
    self.topConstraint.constant = y;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
@end
