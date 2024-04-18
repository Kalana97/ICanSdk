//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2021
- File name:  C2COrderPageViewController.m
- Description:
- Function List:
*/
        

#import "C2COrderPageViewController.h"
#import "UIViewController+Extension.h"
#import "C2COrderPendingViewController.h"
#import "C2COrderCompletedViewController.h"
@interface C2COrderPageViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedCon;
@property (nonatomic, strong) C2COrderPendingViewController *orderPendingVc;
@property (nonatomic, strong) C2COrderCompletedViewController *orderCompletedVc;
@end

@implementation C2COrderPageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"C2COptionalSaleViewController",@"C2CPConfirmOrderViewController",@"C2CPConfirmOrderViewController"]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (IBAction)segmentedConAction:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex==0) {
        self.orderPendingVc.view.hidden = NO;
        self.orderCompletedVc.view.hidden = YES;
    }else{
        self.orderPendingVc.view.hidden = YES;
        self.orderCompletedVc.view.hidden = NO;
    }
    
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
- (IBAction)backAction:(id)sender {
    if (self.shoulPopToRoot) {
        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderPendingVc =  [[C2COrderPendingViewController alloc]init];
    [self addChildViewController:self.orderPendingVc];
    self.orderPendingVc.view.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight);
    self.orderPendingVc.view.hidden = NO;
    [self.orderPendingVc didMoveToParentViewController:self];
    [self.view addSubview:self.orderPendingVc.view];
  
    self.orderCompletedVc =  [[C2COrderCompletedViewController alloc]init];
    [self addChildViewController:self.orderCompletedVc];
    self.orderCompletedVc.view.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight);
    self.orderCompletedVc.view.hidden = YES;
    [self.orderCompletedVc didMoveToParentViewController:self];
    [self.view addSubview:self.orderCompletedVc.view];
    [self.segmentedCon setTitle:@"C2COrderPending".icanlocalized forSegmentAtIndex:0];
    [self.segmentedCon setTitle:@"C2COrderStateCompleted".icanlocalized forSegmentAtIndex:1];
   
}



@end
