//
//  ViewTransactionsVC.m
//  ICan
//
//  Created by Sathsara Dharmarathna on 2023-06-27.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ViewTransactionsVC.h"
#import "TransactionCell.h"
#import "BillPageViewController.h"

@interface ViewTransactionsVC ()
@property (weak, nonatomic) IBOutlet UIView *selectTypeBgView;
@property (weak, nonatomic) IBOutlet UILabel *transLbl;
@property(nonatomic, strong) BillPageViewController *billPageVc;
@end

@implementation ViewTransactionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.selectTypeBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    self.billPageVc =  [[BillPageViewController alloc]init];
    self.billPageVc.isFromOrganization = YES;
    self.billPageVc.memberInfo = self.memberInfo;
    [self addChildViewController:self.billPageVc];
    self.billPageVc.view.frame = CGRectMake(0, NavBarHeight+35, ScreenWidth, ScreenHeight-35-NavBarHeight);
    [self.billPageVc didMoveToParentViewController:self];
    [self.view addSubview:self.billPageVc.view];
    [self.billPageVc reloadVc];
    self.transLbl.text = @"Transactions".icanlocalized;
}

@end
