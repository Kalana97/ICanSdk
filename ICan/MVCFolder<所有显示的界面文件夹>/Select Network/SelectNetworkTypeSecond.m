//
//  SelectNetworkTypeSecond.m
//  ICan
//
//  Created by Sathsara on 2022-10-11.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "SelectNetworkTypeSecond.h"
#import "IcanWalletSelectAddressViewTableViewCell.h"
#import "IcanWalletSelecMainNetworkSectionHead.h"
#import <QuartzCore/QuartzCore.h>

@interface SelectNetworkTypeSecond () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property(nonatomic, strong) IcanWalletSelecMainNetworkSectionHead *headView;
@property(nonatomic, strong) NSString *isAnySelected;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *btnBgView;
@end

@implementation SelectNetworkTypeSecond

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.confirmBtn setTitle:@"CommonButton.Confirm".icanlocalized forState:UIControlStateNormal];
    self.confirmBtn.layer.cornerRadius = 20;
    self.confirmBtn.layer.masksToBounds = YES;
    self.btnBgView.layer.cornerRadius = 20;
    self.btnBgView.layer.masksToBounds = YES;
    self.confirmBtn.enabled = NO;
    [self.tableView registNibWithNibName:kIcanWalletSelectAddressViewTableViewCell];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
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
    cell.typeDirected = @"ShouldColor";
    cell.didSelectBlock = ^{
        self.indexId = indexPath;
        for (ICanWalletMainNetworkInfo* currentObj in self.mainNetworkItems){
            currentObj.isSelected = NO;
        }
        self.mainNetworkItems[indexPath.row].isSelected = YES;
        self.isAnySelected = @"Yes";
        if ([self.isAnySelected  isEqual: @"Yes"]){
            self.confirmBtn.enabled = YES;
        }else{
            self.confirmBtn.enabled = NO;
        }
        [self.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)didSelectItem:(id)sender {
    !self.selectBlock?:self.selectBlock(self.mainNetworkItems[self.indexId.row]);
    [self hiddenView];
    
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
