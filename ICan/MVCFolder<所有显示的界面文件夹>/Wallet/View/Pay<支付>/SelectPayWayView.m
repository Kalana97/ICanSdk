
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 11/6/2021
- File name:  SelectPayWayView.m
- Description:
- Function List:
*/
        

#import "SelectPayWayView.h"
#import "SelectPayWayViewTableViewCell.h"
@interface SelectPayWayView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property(nonatomic, strong) RechargeChannelInfo *selectChannelInfo;

@end

@implementation SelectPayWayView
- (void)awakeFromNib{
    [super awakeFromNib];
//    SelectPaymentMode 选择支付方式
    self.titleLabel.text=@"SelectPaymentMode".icanlocalized;
    [self.tableView registNibWithNibName:kSelectPayWayViewTableViewCell];
    [self.bgContentView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.sureButton.hidden=YES;
    
}
- (IBAction)sureButtonAction {
    if (self.sureButtonBlock) {
        self.sureButtonBlock(self.selectChannelInfo);
    }
    self.hidden=YES;
}
#pragma mark - Setter
-(void)setChannelItems:(NSArray<RechargeChannelInfo *> *)channelItems{
    _channelItems=channelItems;
    CGFloat height=channelItems.count*50+50;
    if (height>350) {
        height=350;
    }
    self.bgHeight.constant=height;
    [self.tableView reloadData];
    
}
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

- (IBAction)closeAction:(id)sender {
    RechargeChannelInfo*info;
    for (RechargeChannelInfo*cinof in self.channelItems) {
        if ([cinof.payType isEqualToString:@"Banlance"]) {
            cinof.select=YES;
            info=cinof;
        }else{
            cinof.select=NO;
        }
        
    }
    [self.tableView reloadData];
    if (self.selectChannelInfoBlock) {
        self.selectChannelInfoBlock(info);
    }
    self.hidden=YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channelItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectPayWayViewTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kSelectPayWayViewTableViewCell];
    RechargeChannelInfo*info=self.channelItems[indexPath.row];
    cell.channelInfo=info;
    cell.tapBlock = ^{
        if ([info.payType isEqualToString:@"Banlance"]) {
            for (RechargeChannelInfo*cinof in self.channelItems) {
                cinof.select=NO;
            }
            self.sureButton.hidden=YES;
            info.select=YES;
            [tableView reloadData];
            if (self.selectChannelInfoBlock) {
                self.selectChannelInfoBlock(info);
            }
            self.hidden=YES;
        }else{
            for (RechargeChannelInfo*cinof in self.channelItems) {
                cinof.select=NO;
            }
            self.selectChannelInfo=info;
            info.select=YES;
            [tableView reloadData];
            self.sureButton.hidden=NO;
        }
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}
@end
