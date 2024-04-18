//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 2/12/2021
- File name:  C2CUserReceiveEvaluateViewController.m
- Description:
- Function List:
*/
        

#import "C2CUserReceiveEvaluateViewController.h"
#import "C2CUserReceiveEvaluateTableViewCell.h"
@interface C2CUserReceiveEvaluateViewController ()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;

@property(nonatomic, strong) C2CGetEvaluateRequest *request;
@end

@implementation C2CUserReceiveEvaluateViewController
-(IBAction)allBtnAction{
    self.allBtn.selected = YES;
    self.goodBtn.selected = NO;
    self.badBtn.selected  = NO;
    [self.allBtn setBackgroundColor:UIColorThemeMainColor];
    [self.goodBtn setBackgroundColor:UIColorBg243Color];
    [self.badBtn setBackgroundColor:UIColorBg243Color];
    [self resetFetchList];
}
-(IBAction)goodBtnAction{
    self.allBtn.selected = NO;
    self.goodBtn.selected = YES;
    self.badBtn.selected  = NO;
    [self.allBtn setBackgroundColor:UIColorBg243Color];
    [self.goodBtn setBackgroundColor:UIColorThemeMainColor];
    [self.badBtn setBackgroundColor:UIColorBg243Color];
    [self resetFetchList];
}
-(IBAction)badBtnAction{
    self.allBtn.selected = NO;
    self.goodBtn.selected = NO;
    self.badBtn.selected  = YES;
    [self.allBtn setBackgroundColor:UIColorBg243Color];
    [self.goodBtn setBackgroundColor:UIColorBg243Color];
    [self.badBtn setBackgroundColor:UIColorThemeMainColor];
    [self resetFetchList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.iconImageView setDZIconImageViewWithUrl:self.userInfo.headImgUrl gender:@""];
    self.nicknameLabel.text = self.userInfo.nickname;
    self.allBtn.selected = YES;
    [self.allBtn setTitleColor:UIColor102Color forState:UIControlStateNormal];
    [self.allBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [self.goodBtn setTitleColor:UIColor102Color forState:UIControlStateNormal];
    [self.goodBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [self.badBtn setTitleColor:UIColor102Color forState:UIControlStateNormal];
    [self.badBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    float evluateRate = (self.userInfo.praiseCount*1.0)/((self.userInfo.praiseCount+self.userInfo.negativeCount)*1.0)*100;
    if (self.userInfo.praiseCount==0) {
        self.goodRateLabel.text = [NSString stringWithFormat:@"100%@",@"%"];
    }else{
        self.goodRateLabel.text = [NSString stringWithFormat:@"%.2f%@",evluateRate,@"%"];
    }
    [self.allBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"C2CAllTitle".icanlocalized,self.userInfo.praiseCount+self.userInfo.negativeCount] forState:UIControlStateNormal];
    [self.allBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"C2CAllTitle".icanlocalized,self.userInfo.praiseCount+self.userInfo.negativeCount] forState:UIControlStateSelected];
    [self.goodBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"C2CSaleSuccessViewControllerGoodLabel".icanlocalized,self.userInfo.praiseCount] forState:UIControlStateNormal];
    [self.goodBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"C2CSaleSuccessViewControllerGoodLabel".icanlocalized,self.userInfo.praiseCount] forState:UIControlStateSelected];
    [self.badBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"C2CSaleSuccessViewControllerBadLabel".icanlocalized,self.userInfo.negativeCount] forState:UIControlStateNormal];
    [self.badBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",@"C2CSaleSuccessViewControllerBadLabel".icanlocalized,self.userInfo.negativeCount] forState:UIControlStateSelected];

    self.listClass = [C2COrderListInfo class];
    self.title = @"C2CMineViewControllerReceiveEvaluateLabel".icanlocalized;
    [self resetFetchList];
}
//重置搜索条件
-(void)resetFetchList{
    self.request = [C2CGetEvaluateRequest request];
    self.request.pathUrlString = [self.request.baseUrlString stringByAppendingFormat:@"/api/adOrder/evaluate/%@",self.userInfo.userId];
    if (self.goodBtn.selected) {
        self.request.trueOrFalse = @(1);
    }
    if (self.badBtn.selected) {
        self.request.trueOrFalse = @(0);
    }
    self.listRequest = self.request;
    [self refreshList];
}
- (IBAction)backAction {
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kC2CUserReceiveEvaluateTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(self.mas_topLayoutGuide).offset(92);
    }];
}


-(void)layoutTableView{
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
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
    return self.listItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    C2CUserReceiveEvaluateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CUserReceiveEvaluateTableViewCell];
    cell.c2cOrderInfo = self.listItems[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
