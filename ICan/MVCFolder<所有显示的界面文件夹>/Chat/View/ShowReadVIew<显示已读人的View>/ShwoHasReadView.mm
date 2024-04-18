//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 27/12/2019
 - File name:  ShwoHasReadView.m
 - Description:
 - Function List:
 */


#import "ShwoHasReadView.h"
#import "ShowHasReadTableViewCell.h"
#import "FriendDetailViewController.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+GroupListInfo.h"
@interface HeadView:UIView
@property(nonatomic, strong) UILabel *topLabel;
@end

@implementation HeadView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor= UIColorViewBgColor;
        [self addSubview:self.topLabel];
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.bottom.equalTo(@0);
            
        }];
    }
    return self;
}
-(UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel=[UILabel leftLabelWithTitle:@"" font:13 color:UIColorThemeMainSubTitleColor];
    }
    return _topLabel;
}
@end

@interface ShwoHasReadView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) HeadView *headView;
@end
@implementation ShwoHasReadView
-(void)showSurePaymentView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
        [window addSubview:self];
        
    });
}
-(void)hiddenSurePaymentView{
    [self removeFromSuperview];
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.tableView];
        self.backgroundColor = UIColorMakeWithRGBA(83, 83, 83, 0.5);
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSurePaymentView)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
    
}
-(HeadView *)headView{
    if (!_headView) {
        _headView=[[HeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    }
    return _headView;
}
-(void)setGroupHasReadUserItems:(NSArray *)groupHasReadUserItems{
    _groupHasReadUserItems=groupHasReadUserItems;
    if (groupHasReadUserItems.count>5) {
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.scrollEnabled = NO;
    }
//    "Readusers"="已读用户";
//    "Numberoftimesread"="已读次数";
    CGFloat tableViewHeight=groupHasReadUserItems.count<=5?50*groupHasReadUserItems.count+50:300;
    if (self.isGroup) {
        self.headView.topLabel.text=[NSString stringWithFormat:@"%@ %ld",@"Numberoftimesread".icanlocalized,groupHasReadUserItems.count];
    }else{
        tableViewHeight=100;
        self.headView.topLabel.text = @"Readusers".icanlocalized;
    }
    if (self.convertRect.origin.y-NavBarHeight-tableViewHeight>0) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@35);
            make.right.equalTo(@-5);
            make.bottom.equalTo(@(-(ScreenHeight-self.convertRect.origin.y+3)));
            make.height.equalTo(@(tableViewHeight));
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@35);
            make.right.equalTo(@-5);
            make.top.equalTo(@((self.convertRect.origin.y+25)));
            make.height.equalTo(@(tableViewHeight));
        }];
    }
    
    [self.tableView reloadData];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        [_tableView registNibWithNibName:kShowHasReadTableViewCell];
        _tableView.tableHeaderView =self.headView;
        
    }
    return _tableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupHasReadUserItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightShowHasReadTableViewCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowHasReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowHasReadTableViewCell];
    cell.isGroup=self.isGroup;
    cell.groupId=self.groupId;
    cell.dict=self.groupHasReadUserItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupListInfo*groupListInfo=[[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:self.groupId];
    FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
    vc.friendDetailType=FriendDetailType_popChatView;
    [self hiddenSurePaymentView];
    NSDictionary*dict=[self.groupHasReadUserItems objectAtIndex:indexPath.row];
    NSString*userId=dict[@"id"];
    vc.userId=userId;
    if (groupListInfo.showUserInfo) {
        [[AppDelegate shared]pushViewController:vc animated:YES];
    }else{
        if ([groupListInfo.role isEqualToString:@"2"]) {
            [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:self.groupId userId:userId successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
                if ([memberInfo.role isEqualToString:@"0"]||[memberInfo.role isEqualToString:@"1"]) {
                    [[AppDelegate shared]pushViewController:vc animated:YES];
                }
            }];
        }else{
            [[AppDelegate shared]pushViewController:vc animated:YES];
        }
        
    }
    
    
}
@end
