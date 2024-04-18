//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 14/1/2022
- File name:  IcanWalletSelectAddressView.m
- Description:
- Function List:
*/
        

#import "IcanWalletSelecMainNetworkView.h"
#import "IcanWalletSelectAddressViewTableViewCell.h"
#import "IcanWalletSelecMainNetworkSectionHead.h"
@interface IcanWalletSelecMainNetworkView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property(nonatomic, strong) IcanWalletSelecMainNetworkSectionHead *headView;
@end
@implementation IcanWalletSelecMainNetworkView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.tableView registNibWithNibName:kIcanWalletSelectAddressViewTableViewCell];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
//    "MainNetworkViewTitle"="选择主网";
   
    self.titleLabel.text = @"MainNetworkViewTitle".icanlocalized;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    self.bottomConstraint.constant = -380;
}
-(IcanWalletSelecMainNetworkSectionHead *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"IcanWalletSelecMainNetworkSectionHead" owner:self options:nil].firstObject;
    }
    return _headView;
}
-(void)setMainNetworkItems:(NSArray<ICanWalletMainNetworkInfo *> *)mainNetworkItems{
    _mainNetworkItems = mainNetworkItems;
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mainNetworkItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightIcanWalletSelectAddressViewTableViewCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IcanWalletSelectAddressViewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIcanWalletSelectAddressViewTableViewCell];
    cell.mainNetworkInfo = self.mainNetworkItems[indexPath.row];
    cell.didSelectBlock = ^{
        !self.selectBlock?:self.selectBlock(self.mainNetworkItems[indexPath.row]);
        [self hiddenView];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
-(void)hiddenView{
    self.bottomConstraint.constant = -380;
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
