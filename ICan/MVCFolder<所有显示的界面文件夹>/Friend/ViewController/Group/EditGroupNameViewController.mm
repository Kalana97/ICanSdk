//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 30/9/2019
 - File name:  EidtGroupNameViewController.m
 - Description:
 - Function List:
 - History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
 */


#import "EditGroupNameViewController.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatList.h"
@interface EditGroupNameViewController ()<QMUITextFieldDelegate>
@property (nonatomic,strong) QMUITextField * textField;
@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic, strong) NSString *content;
@end

@implementation EditGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.editNameType) {
        case EditNameType_GroupName:
            self.title=NSLocalizedString(@"Change group name", 修改群名称);
            self.textField.text=self.groupDetailInfo.name;
            self.rightBtn.enabled=NO;
            break;
        case EditNameType_UserRemark:
            self.title=@"ChangeAlias".icanlocalized;
            self.textField.text=self.userMessageInfo.remarkName;
            self.rightBtn.enabled=NO;
            break;
        default:
            self.title=NSLocalizedString(@"Change group nickname", 修改群昵称);
            self.textField.text=self.groupDetailInfo.groupRemark;
            self.rightBtn.enabled=YES;
            [self.rightBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
            break;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NavBarHeight+10));
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@45);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.editNameType==EditNameType_GroupName) {
        NSString * toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSUInteger length=[toString charactorNumber];
        return length<=40;
    }
    return YES;
}

-(void)textFieldDidChange:(NSNotification*)nofication{
    if (self.textField.text.length>0&&!self.textField.markedTextRange) {
        self.rightBtn.enabled = YES;
        [self.rightBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    }else if(self.textField.text.length == 0){
        self.rightBtn.enabled = YES;
        [self.rightBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    }else{
        if (self.editNameType!=EditNameType_GroupNickname) {
            self.rightBtn.enabled = NO;
            [self.rightBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
        }
    }
}

-(void)buttonAction{
    if (self.editNameType != EditNameType_UserRemark) {
        if (self.editNameType != EditNameType_GroupNickname) {
            if (self.textField.text.length==0) {
                [QMUITipsTool showOnlyTextWithMessage:@"请输入信息" inView:self.view];
                return;
            }
        }
    }
    
    NSString* content=self.textField.text;
    self.content = content.trimmingwhitespaceAndNewline;
    switch (self.editNameType) {
        case EditNameType_GroupName:
            if (content.length>0) {
                [self editName];
            }else{
                [QMUITipsTool showOnlyTextWithMessage:@"Group name cannot be empty".icanlocalized inView:self.view];
            }
            
            break;
        case EditNameType_GroupNickname:
            if (content.length>0) {
                [self editMyNameInGroupRequest];
            }else{
                [QMUITipsTool showOnlyTextWithMessage:@"Group nickname cannot be empty".icanlocalized inView:self.view];
            }
            
            break;
        case EditNameType_UserRemark:
            [self setUserRemark];
            break;
        default:
            if (content.length>0) {
                [self setUserRemark];
            }else{
                [QMUITipsTool showOnlyTextWithMessage:@"Remarks cannot be empty".icanlocalized inView:self.view];
            }
            
            break;
    }
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton dzButtonWithTitle:@"UIAlertController.sure.title".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:18 titleColor:UIColor153Color target:self action:@selector(buttonAction)];
    }
    return _rightBtn;
}

-(QMUITextField *)textField{
    if (!_textField) {
        _textField=[[QMUITextField alloc]init];
        _textField.delegate=self;
        
        switch (self.editNameType) {
            case EditNameType_GroupName:
                _textField.placeholder=NSLocalizedString(@"EnterGroupName", 请输入群名称);
                break;
            case EditNameType_GroupNickname:
                _textField.maximumTextLength=15;
                _textField.placeholder=NSLocalizedString(@"EnterGroupNickname", 请输入群昵称);
                break;
                
            default:
                _textField.maximumTextLength=15;
                _textField.placeholder=NSLocalizedString(@"Please enter comments", 请输入备注);
                
                break;
        }
        _textField.placeholderColor=UIColor153Color;
        _textField.textColor=UIColor102Color;
        _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        ViewRadius(_textField, 5);
        ViewBorder(_textField, UIColorSeparatorColor, 1);
    }
    return _textField;
}

-(void)editName{
    EditGroupNameRequest*request=[EditGroupNameRequest request];
    request.groupId=self.groupDetailInfo.groupId;
    
    request.groupName=self.content;
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [[WCDBManager sharedManager]updateShowName:self.textField.text chatId:self.groupDetailInfo.groupId chatType:GroupChat];
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Group name modified successfully", 成功修改群名称) inView:self.view];
        [[WCDBManager sharedManager]updateGroupNameWithGroupId:self.groupDetailInfo.groupId groupName:self.content];
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateGroupMessageNotification object:self.groupDetailInfo.groupId userInfo:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

//修改自己在群中的昵称可以设置为空
-(void)editMyNameInGroupRequest{
    EditgroupUserNicknameRequest*request=[EditgroupUserNicknameRequest request];
    request.groupId=self.groupDetailInfo.groupId;
    if (self.content.length>0) {
        request.groupUserNickname=self.content;
    }else{
        request.groupUserNickname=@"";
    }
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:nil inView:self.view];
        if (self.editSuccessBlock) {
            self.editSuccessBlock(self.content);
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateGroupMessageNotification object:self.groupDetailInfo.groupId userInfo:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(void)setUserRemark{
    SetFriendRemarknameRequest*request=[SetFriendRemarknameRequest request];
    if([self.content isEqualToString:@""]){
        request.remark=nil;
    }else{
        request.remark=self.content;
    }
    request.userId=@([self.userMessageInfo.userId integerValue]);
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Modified success", 成功修改) inView:self.view];
        [[WCDBManager sharedManager]updateFriendRemarkNameWithUserId:self.userMessageInfo.userId remark:self.content];
        [[WCDBManager sharedManager]updateShowName:self.textField.text chatId:self.userMessageInfo.userId chatType:UserChat];
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateFriendRemarkNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.editSuccessBlock) {
            self.editSuccessBlock(self.content);
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
@end
