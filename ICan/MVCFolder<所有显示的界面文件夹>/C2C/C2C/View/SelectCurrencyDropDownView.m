//
//  SelectCurrencyDropDownView.m
//  ICan
//  Created by Kalana Rathnayaka on 12/03/2024.
//  Copyright © 2024 dzl. All rights reserved.
//

#import "SelectCurrencyDropDownView.h"
#import "SelectCurrencyDropDownTableViewCell.h"
@interface SelectCurrencyDropDownView()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation SelectCurrencyDropDownView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kSelectCurrencyItemCell];
    self.tableView.scrollEnabled = NO;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
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
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {;
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCurrencyDropDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectCurrencyItemCell];
    C2CExchangeRateInfo * info = [self.data objectAtIndex:indexPath.row];
    cell.currencyName.text = info.virtualCurrency;
    if ([info.virtualCurrency isEqual:@"USDT"]) {
        cell.currencyIcon.image = [UIImage imageNamed:@"usdt"];
    }else if ([info.virtualCurrency isEqual:@"CNT"]) {
        cell.currencyIcon.image = [UIImage imageNamed:@"CNT Transfer"];
    }
    if ([self.selectedC isEqual:@""]) {
        cell.tickImage.hidden = NO;
    }else if ([self.selectedC isEqual:info.virtualCurrency]){
        cell.tickImage.hidden = NO;
    }else {
        cell.tickImage.hidden = YES;
    }
    @weakify(self);
    cell.hiddenBlock = ^{
        @strongify(self);
        !self.selectBlock?:self.selectBlock(indexPath.row, info.virtualCurrency);
        [self hiddenView];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
}

@end
