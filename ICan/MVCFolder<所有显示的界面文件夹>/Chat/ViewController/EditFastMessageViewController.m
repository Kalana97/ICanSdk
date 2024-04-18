
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 3/9/2021
- File name:  EditFastMessageViewController.m
- Description:
- Function List:
*/
        

#import "EditFastMessageViewController.h"

@interface EditFastMessageViewController ()

@property (weak, nonatomic) IBOutlet QMUITextView *editTextView;
@property (weak, nonatomic) IBOutlet UIView *editBtnView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation EditFastMessageViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.directionInt isEqual: @"Exist"]){
        self.addBtn.hidden = YES;
        self.title = @"QuickMessageEdit".icanlocalized;
        [self.deleteBtn layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
        [self.deleteBtn setTitle:@"Delete".icanlocalized forState:UIControlStateNormal];
        [self.saveBtn layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
        [self.saveBtn setTitle:@"Save".icanlocalized forState:UIControlStateNormal];
    }else {
        self.title = @"QuickMessageNew".icanlocalized;
        self.editBtnView.hidden = YES;
        [self.addBtn setTitle:@"Add".icanlocalized forState:UIControlStateNormal];
        [self.addBtn layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
    }
    
    self.view.backgroundColor = UIColorBg243Color;
    self.editTextView.text = self.info.value;
}

- (IBAction)deleteBtnAction:(id)sender {
    if ([self.directionInt isEqual: @"Exist"]){
        DeleteQuickMessageRequest*request = [DeleteQuickMessageRequest request];
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/quickMessage/%@",self.info.ID];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            [[NSNotificationCenter defaultCenter]postNotificationName:KChangeQuickMessageNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }else{
        self.info.value = @"";
        self.editTextView.text = @"";
    }
}

- (IBAction)saveBtnAction:(id)sender {
    [self saveOrAddMessage];
}

- (IBAction)addBtnAction:(id)sender {
    [self saveOrAddMessage];
}

- (void)saveOrAddMessage {
    if (self.editTextView.text.trimmingwhitespaceAndNewline.length>0) {
        if (self.info) {
            PutQuickMessageRequest*request = [PutQuickMessageRequest request];
            request.value = self.editTextView.text.trimmingwhitespaceAndNewline;
            request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/quickMessage/%@",self.info.ID];
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                [[NSNotificationCenter defaultCenter]postNotificationName:KChangeQuickMessageNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
            }];
        }else{
            PostQuickMessageRequest*request = [PostQuickMessageRequest request];
            request.value = self.editTextView.text.trimmingwhitespaceAndNewline;
            request.parameters = [request mj_JSONObject];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse* response) {
                [[NSNotificationCenter defaultCenter]postNotificationName:KChangeQuickMessageNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
            }];
        }
    }
}

@end
