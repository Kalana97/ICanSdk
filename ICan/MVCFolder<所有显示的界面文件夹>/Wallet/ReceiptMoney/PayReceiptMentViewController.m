//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/9/2020
- File name:  PayReceiptMentViewController.m
- Description:
- Function List:
*/
        

#import "PayReceiptMentViewController.h"
#import "PayReceiptMoneyHeaderView.h"
#import "QRCodeController.h"
#import "WebSocketManager.h"
#import "ChatUtil.h"
#import "PayManager.h"
#import "PaySuccessTipView.h"
#import "PaySuccessTipViewController.h"
#import "UIViewController+Extension.h"
#import "ChatModel.h"
@interface PayReceiptMentViewController ()
@property(nonatomic, strong) PayReceiptMoneyHeaderView *headerView;
@property(nonatomic, assign) BOOL paySuccess;
@property(nonatomic, strong) PayManager *payManager;
@end

@implementation PayReceiptMentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"付款".icanlocalized;
    if (!self.isPayment) {
        [self sendPayQRCodeReceiveStart];
    }
    
    self.payManager=[[PayManager alloc]initWithShowViewController:self fetchBalanceSuccessBlock:^(UserBalanceInfo * _Nonnull balance) {
        
    }];
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"QRCodeController"]];
}
-(void)dealloc{
    if (!self.paySuccess) {
        [self sendPayQRCodeReceiveCancel];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSMutableArray*array=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController*vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[QRCodeController class]]) {
            [array removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers=[array copy];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.backgroundColor = UIColorBg243Color;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView=self.headerView;
    
}
-(PayReceiptMoneyHeaderView *)headerView{
    if (!_headerView) {
        _headerView=[[PayReceiptMoneyHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavBarHeight)];
        _headerView.userId=self.userId;
        if ([self.money isEqualToString:@"-1"]) {
        }else{
            _headerView.moneytextField.text=[NSString stringWithFormat:@"%.2f",[self.money doubleValue]];
            _headerView.moneytextField.enabled=NO;
        }
        @weakify(self);
        _headerView.sureButtonBlock = ^{
            @strongify(self);
            if ([self.userId isEqualToString:[UserInfoManager sharedManager].userId]) {
                [QMUITipsTool showOnlyTextWithMessage:@"Paying to myself is not supported".icanlocalized inView:self.view];
            }else{
                if (self.isPayment) {
                    [self payMoneyRequest];
                }else{
                    [self payRequest];
                }
                
            }
            
        };
    }
    return _headerView;
}


-(void)payRequest{
    @weakify(self);
    [self.payManager showPayViewWithAmount:[NSString stringWithFormat:@"%.2f",[self.headerView.moneytextField.text doubleValue]] typeTitleStr:@"ICanPay".icanlocalized SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
        @strongify(self);
        PayQRCodeReceivePaymentRequest*request=[PayQRCodeReceivePaymentRequest request];
        request.receive=self.userId;
        request.code=self.code;
        request.money=@([self.headerView.moneytextField.text doubleValue]);
        if (self.headerView.commentTextView.text.length>0) {
            request.comment=self.headerView.commentTextView.text;
        }
        request.payPassword=password;
        request.parameters=[request mj_JSONObject];
        
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
            NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            NSNumber *statusValue = jsonDictionary[@"status"];
            NSInteger intValue = [statusValue integerValue];
            NSLog(@"Status value as an integer: %ld", (long)intValue);
            [UserInfoManager sharedManager].attemptCount = nil;
            [UserInfoManager sharedManager].isPayBlocked = NO;
            if(intValue == 3 || intValue == 2 ){
                [QMUITipsTool showSuccessWithMessage:@"Pending approval".icanlocalized inView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                   });
            }else{
                DDLogInfo(@"支付成功");
                self.paySuccess=YES;
                PaySuccessTipViewController*vc=[PaySuccessTipViewController new];
                vc.isPay = YES;
                vc.userId=self.userId;
                vc.amountLabel.text=[NSString stringWithFormat:@"￥%.2f",[self.headerView.moneytextField.text doubleValue]];
                [QMUITipsTool showOnlyTextWithMessage:@"payment successful".icanlocalized inView:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            if ([info.code isEqual:@"pay.password.error"]) {
                if (info.extra.isBlocked) {
                    [UserInfoManager sharedManager].isPayBlocked = YES;
                    [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                    [self payRequest];
                } else if (info.extra.remainingCount != 0) {
                    [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                    [self payRequest];
                } else {
                    [UserInfoManager sharedManager].attemptCount = nil;
                }
            }
        }];
    }];
    
}
/**
 发送扫描二维码成功的消息
 */
-(void)sendPayQRCodeReceiveStart{
    Notice_PayQRInfo*info=[[Notice_PayQRInfo alloc]init];
    info.userId=[[UserInfoManager sharedManager].userId integerValue];
    if ([self.money isEqualToString:@"-1"]) {
        
    }else{
        info.money=[self.headerView.moneytextField.text doubleValue];
    }
    info.qrCodeType=@"receivePayment";
    info.code=self.code;
    info.status=1;
    ChatModel*model=[ChatUtil creatChatMessageModelWithChatId:self.userId chatType:UserChat authorityType:AuthorityType_friend circleUserId:nil];
    model.messageType=Notice_PayQRType;
    model.messageContent=[info mj_JSONString];
    [[WebSocketManager sharedManager]sendMessageWithChatModel:model];
    
}
-(void)sendPayQRCodeReceiveCancel{
    Notice_PayQRInfo*info=[[Notice_PayQRInfo alloc]init];
    info.userId=[[UserInfoManager sharedManager].userId integerValue];
    info.qrCodeType=@"receivePayment";
    info.code=self.code;
    info.status=3;
    ChatModel*model=[ChatUtil creatChatMessageModelWithChatId:self.userId chatType:UserChat authorityType:AuthorityType_friend circleUserId:nil];
    model.messageType=Notice_PayQRType;
    model.messageContent=[info mj_JSONString];
    [[WebSocketManager sharedManager]sendMessageWithChatModel:model];
}

-(void)payMoneyRequest{
    PayQRCodePaymentRequest*request=[PayQRCodePaymentRequest request];
    request.code=self.code;
    request.money=@([self.headerView.moneytextField.text doubleValue]);
    if (self.headerView.commentTextView.text.length>0) {
        request.comment=self.headerView.commentTextView.text;
    }
  
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"Successfully Received".icanlocalized inView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
@end
