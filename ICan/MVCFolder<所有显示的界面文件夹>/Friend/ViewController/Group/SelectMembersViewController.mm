//
//  SelectMembersViewController.m
//  OneChatAPP
//
//  Created by mac on 2016/11/29.
//  Copyright © 2016年 DW. All rights reserved.
//

#import "SelectMembersViewController.h"

#import "WCDBManager+ChatList.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupListInfo.h"
#import "ChatModel.h"
#import "SelectPersonTableViewCell.h"

//搜索库 可以实现字体颜色匹配
#import "SearchCoreManager.h"
#import "WebSocketManager.h"


#import "ChatUtil.h"

#import "UITableView+SCIndexView.h"

#import "SearchHeadView.h"
#import "FriendListFirstHeaderView.h"
#import "GroupListViewController.h"
@interface SelectMembersHeaderView:UIView
@property(nonatomic, strong) UIControl *gotoNewChatCon;
@property(nonatomic, strong) UILabel *creatLabel;
@property(nonatomic, strong) UIImageView *arrowImageView;
@property(nonatomic, copy) void (^gotoNewChatBlock)(void);
@end
@implementation SelectMembersHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.backgroundColor= UIColorViewBgColor;
    }
    return self;
}
-(void)setUpView{
    [self addSubview:self.gotoNewChatCon];
    [self.gotoNewChatCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.gotoNewChatCon addSubview:self.creatLabel];
    [self.creatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.gotoNewChatCon.mas_centerY);
    }];
    [self.gotoNewChatCon addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.gotoNewChatCon.mas_centerY);
        make.width.equalTo(@8);
        make.height.equalTo(@16);
    }];
}
-(UIControl *)gotoNewChatCon{
    if (!_gotoNewChatCon) {
        _gotoNewChatCon=[[UIControl alloc]init];
        [_gotoNewChatCon addTarget:self action:@selector(gotoNewChat) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoNewChatCon;
}
-(UILabel *)creatLabel{
    if (!_creatLabel) {
        _creatLabel=[UILabel leftLabelWithTitle:@"SelectGroup".icanlocalized font:16 color:UIColor252730Color];
    }
    return _creatLabel;
}
-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_arrow_right_line")];
    }
    return _arrowImageView;
}
-(void)gotoNewChat{
    if (self.gotoNewChatBlock) {
        self.gotoNewChatBlock();
    }
}
@end
@interface SelectMembersCollectionViewCell:UICollectionViewCell
@property(nonatomic, strong) DZIconImageView *iconImageView;
@end
@implementation SelectMembersCollectionViewCell
-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        [_iconImageView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
        _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    return self;
}

@end
@interface SelectMembersViewController ()<QMUITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)  NSMutableArray *choseArray;
@property(strong, nonatomic) UIButton *sureBtn;
@property(strong ,nonatomic) UIButton *cancelBtn;
/** 邀请或者创建群聊的时候的好友数组  */
@property(nonatomic,strong)  NSMutableArray<UserMessageInfo*> * friendItems;
@property(nonatomic,strong)  NSMutableArray<UserMessageInfo*> * friendItems2;

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)  NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)  NSMutableArray *letterResultArr;
@property(nonatomic,strong) SelectMembersHeaderView *headView;

@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
//搜索框
@property(nonatomic, weak) IBOutlet  UIImageView *searchTipsImageView;
@property(nonatomic, weak) IBOutlet QMUITextField *searTextField;
@property(nonatomic, weak) IBOutlet UIView *bgView;
@property(nonatomic, weak) IBOutlet UIView *topLineView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *collectViewWidth;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *searchLeftConstraint;


@end

@implementation SelectMembersViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.selectMemberType) {
        case SelectMenbersType_kickOut:
            self.title = NSLocalizedString(@"DeleteMembers", 踢除群成员);
            break;
        case SelectMembersType_chatList:
        case SelectMembersType_addMember:
        case SelectMembersType_ChatDetail:
        case SelectMenbersType_Timelines:
        case SelectMenbersType_Transpond:
            self.title = [@"friend.selectMember.title" icanlocalized:@"选择联系人"];;
            break;
        default:
            break;
            
    }
    [self.collectionView registClassWithClassName:@"SelectMembersCollectionViewCell"];
    self.searTextField.backgroundColor= [UIColor clearColor];
    self.searTextField.textColor=UIColorThemeMainTitleColor;
    self.searTextField.placeholder=[@"friend.search.tipText" icanlocalized:@"搜索联系人"];
    self.searTextField.placeholderColor=UIColor153Color;
    //这句代码可以解决6s plus 10.3.3系统的 一些UI界面问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.sureBtn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancelBtn];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    if (self.selectMemberType == SelectMenbersType_kickOut) {
        for (GroupMemberInfo*info in self.removeInGroupMembers) {
            info.isSelect = NO;
            info.canEnabled = YES;
        }
        if ([self.groupDetailInfo.role isEqualToString:@"1"]) {//管理员
            NSMutableArray*members=[NSMutableArray array];
            for (GroupMemberInfo*info in self.removeInGroupMembers) {
                info.isSelect=NO;
                if ([info.role isEqualToString:@"2"]) {
                    [members addObject:info];
                }
            }
            self.removeInGroupMembers=[NSMutableArray arrayWithArray:members];
        }
        [self sortObjectsAccordingToInitialWith:self.removeInGroupMembers group:YES block:^{
            [self.tableView reloadData];
        }];
    }else{
        [self loadCacheData];
        
    }
    
}
-(void)cancelAction{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initTableView{
    [super initTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    [self.tableView registNibWithNibName:kSelectPersonTableViewCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(self.bgView.mas_bottom);
    }];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    if (self.selectMemberType==SelectMenbersType_Transpond) {
        self.tableView.tableHeaderView=self.headView;
    }
}
-(void)loadCacheData{
//    self.friendItems = [NSMutableArray arrayWithArray:[[WCDBManager sharedManager]fetchFriendList]];
    if(self.friendItems.count == 0) {
        [self loadFriendsRequest];
    }
    NSLog(@"PPPPPPPPPP: %lu", (unsigned long)self.friendItems.count);
    for (UserMessageInfo*info in self.friendItems) {
        info.canEnabled = YES;
    }
    [self restartsortObjects];
    
}
-(void)layoutTableView{
    
}
//如果邀请人进去，在群里的好友不能再次邀请 SelectMembersType_addMember
-(void)screenMenbers{
    for (UserMessageInfo * info in self.friendItems) {
        info.canEnabled = YES;
    }
    [self sortObjectsAccordingToInitialWith:self.friendItems group:NO block:^{
        for (GroupMemberInfo * model in self.inGroupMember) {
            for (UserMessageInfo * friendInfo  in self.friendItems) {
                if ([friendInfo.userId isEqualToString:model.userId]) {
                    friendInfo.canEnabled = NO;
                    break;
                }
            }
        }
        [self.tableView reloadData];
    }];
}
//从聊天详情页面进来并且是创建群聊  Enter from the chat details page and create a group chat
-(void)removeCurrentMember{
    [self sortObjectsAccordingToInitialWith:self.friendItems group:NO block:^{
        for (UserMessageInfo * info in self.friendItems) {
            if ([info.userId isEqualToString:self.userMessageInfo.userId]) {
                info.canEnabled =NO;
                info.isSelect=YES;
                break;
            }
        }
        [self.tableView reloadData];
    }];
}


// 按首字母分组排序数组
-( void)sortObjectsAccordingToInitialWith:(NSArray *)arr group:(BOOL)group  block:(void (^)(void))block{
    dispatch_group_t sortGroup=dispatch_group_create();
    dispatch_queue_t sortQueue= dispatch_queue_create("com.SerialQueue", NULL);
    
    NSDate *startTime = [NSDate date];
    dispatch_group_async(sortGroup, sortQueue, ^{
        
        // 初始化UILocalizedIndexedCollation
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        //得出collation索引的数量，这里是27个（26个字母和1个#）
        NSInteger sectionTitlesCount = [[collation sectionTitles] count];
        //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组] , ... @[以#(其它)开头的数据数组]]Used to store the final data, the final data model we want should be in the form of @[@[data array starting with A], @[data array starting with B], @[data array starting with C]
        NSMutableArray *newSectionsArray= [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
        
        //初始化27个空数组加入newSectionsArray
        for (NSInteger index = 0; index < sectionTitlesCount; index++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [newSectionsArray addObject:array];
        }
        //是群聊 is a group chat
        if (group) {
            for (GroupMemberInfo * memberInfo in arr) {
                //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
                NSInteger sectionNumber = [collation sectionForObject:memberInfo collationStringSelector:memberInfo.groupRemark? @selector(groupRemark):@selector(nickname)];
                //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
                NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
                [sectionNames addObject:memberInfo];
            }
        }else{
            //assign each name to a 个section下
            for (UserMessageInfo *personModel in arr) {
                //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
                NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:personModel.remarkName? @selector(remarkName):@selector(nickname)];
                //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
                NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
                [sectionNames addObject:personModel];
            }
            
        }
        //delete empty array
        NSMutableArray *finalArr = [NSMutableArray new];
        NSMutableArray*index=[NSMutableArray array];
        for (NSInteger index = 0; index < sectionTitlesCount; index++) {
            if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
                [finalArr addObject:newSectionsArray[index]];
            }
        }
        if (group) {
            for (NSArray*array in finalArr) {
                GroupMemberInfo*info=array.firstObject;
                [index addObject:[NSString firstCharactorWithString:info.groupRemark?info.groupRemark:info.nickname]];
            }
        }else{
            for (NSArray*array in finalArr) {
                UserMessageInfo*info=array.firstObject;
                [index addObject:[NSString firstCharactorWithString:info.remarkName?info.remarkName:info.nickname]];
            }
        }
        self.letterResultArr =[NSMutableArray arrayWithArray:finalArr];
        self.indexArray=[NSMutableArray arrayWithArray:index];
    });
    dispatch_group_notify(sortGroup,sortQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLogInfo(@"Time: %f", -[startTime timeIntervalSinceNow])  ;
            self.tableView.sc_indexViewDataSource = self.indexArray.copy;
            SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
            self.tableView.sc_indexViewConfiguration = configuration;
            if (block) {
                block();
            }
        });
    });
}


-(void)searFriendWithText:(NSString*)searchText{
    //如果是退出群聊 那么里面的选择都是群成员
    if (self.selectMemberType==SelectMenbersType_kickOut) {
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"groupRemark CONTAINS[c] %@ || nickname CONTAINS[c] %@",searchText,searchText];
        NSArray*searArray= [self.removeInGroupMembers filteredArrayUsingPredicate:gpredicate];
        [self sortObjectsAccordingToInitialWith:searArray group:YES block:^{
            [self.tableView reloadData];
        }];
    }else{
        NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nickname CONTAINS[c] %@ || remarkName CONTAINS[c] %@",searchText,searchText];
        NSArray*searArray= [self.friendItems filteredArrayUsingPredicate:gpredicate];
        [self sortObjectsAccordingToInitialWith:searArray group:NO block:^{
            [self.tableView reloadData];
        }];
    }
    
    if ([NSString isEmptyString:searchText]) {
        [self restartsortObjects];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectMemberRowAtIndexPath:indexPath];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.letterResultArr.count;
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)[self.letterResultArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectPersonTableViewCell];
    if (self.selectMemberType==SelectMenbersType_kickOut) {
        cell.groupMemberInfo=[self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
        
    }else{
        cell.userMessageInfo = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    }
    @weakify(self);
    cell.buttonBlock = ^{
        @strongify(self);
        [self didSelectMemberRowAtIndexPath:indexPath];
    };
    return cell;
    
}

-(void)didSelectMemberRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectMemberType == SelectMenbersType_kickOut) {
        GroupMemberInfo*memberInfo=[self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
        memberInfo.isSelect=!memberInfo.isSelect;
        if (memberInfo.isSelect) {
            [self.choseArray addObject:self.letterResultArr[indexPath.section][indexPath.row]];
        }else{
            [self.choseArray removeObject:self.letterResultArr[indexPath.section][indexPath.row]];
        }
    }else{
        UserMessageInfo*memberInfo = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
        if (memberInfo.canEnabled) {
            memberInfo.isSelect=!memberInfo.isSelect;
            if (memberInfo.isSelect) {
                [self.choseArray addObject:memberInfo];
            }else{
                [self.choseArray removeObject:memberInfo];
            }
        }
    }
    self.searTextField.text = @"";
    [self changeCollectUI];
    [self.tableView reloadData];
    
}
-(void)restartsortObjects{
    __block int i = 0;
    switch (self.selectMemberType) {
        case SelectMembersType_ChatDetail:
            [self removeCurrentMember];
            break;
        case SelectMembersType_addMember:
            [self screenMenbers];
            break;
        case SelectMenbersType_kickOut:{
            [self sortObjectsAccordingToInitialWith:self.removeInGroupMembers group:YES block:^{
                [self.tableView reloadData];
            }];
        }
            break;
        case SelectMenbersType_Timelines:{
            
            [self sortObjectsAccordingToInitialWith:self.friendItems group:NO block:^{
                for (UserMessageInfo * model in self.friendItems) {
                    for (UserMessageInfo * friendInfo  in self.currentSelectAtUser) {
                        if ([friendInfo.userId isEqualToString:model.userId]) {
                            model.canEnabled = YES;
                            model.isSelect=YES;
                            [self.choseArray addObject:model];
                            break;
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self changeCollectUI];
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                });
               
            }];
        }
            break;
        case SelectMembersType_chatList:
            NSLog(@"PPPPPPPPPP: %lu", (unsigned long)self.friendItems.count);
        case SelectMenbersType_Transpond:{
            for (i = 0; i < self.friendItems.count; i++) {
                if(self.friendItems[i].beBlock == YES){
                    [self.friendItems removeObjectAtIndex:i];
                }
            }
            if(i == self.friendItems.count){
                [self sortObjectsAccordingToInitialWith:self.friendItems group:NO block:^{
                    [self.tableView reloadData];
                }];
            }
        }
            break;
        default:
            break;
    }
}
-(void)changeCollectUI{
    [self.collectionView reloadData];
    self.collectionView.hidden = self.choseArray.count>0?NO:YES;
    self.searchTipsImageView.hidden = self.choseArray.count>0;
    if (self.choseArray.count>0) {
        CGFloat width=self.choseArray.count*50;
        if (width>ScreenWidth-100) {
            width=ScreenWidth-100;
        }
        self.collectViewWidth.constant = width;
        self.searchLeftConstraint.constant = 10;

        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.choseArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }else{
        self.collectViewWidth.constant = 0;
        self.searchLeftConstraint.constant = 35;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FriendListFirstHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
    view.titleLabel.text=self.indexArray[section];
    return view;
    
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.choseArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectMembersCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"SelectMembersCollectionViewCell" forIndexPath:indexPath];
    if (self.selectMemberType==SelectMenbersType_kickOut) {
        GroupMemberInfo*memberInfo=[self.choseArray objectAtIndex:indexPath.item];
        [cell.iconImageView setDZIconImageViewWithUrl:memberInfo.headImgUrl gender:memberInfo.gender];
    }else{
        UserMessageInfo*memberInfo=[self.choseArray objectAtIndex:indexPath.item];
        [cell.iconImageView setDZIconImageViewWithUrl:memberInfo.headImgUrl gender:memberInfo.gender];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectMemberType==SelectMenbersType_kickOut) {
        GroupMemberInfo*memberInfo=[self.choseArray objectAtIndex:indexPath.item];
        memberInfo.isSelect=NO;
    }else{
        UserMessageInfo*memberInfo=[self.choseArray objectAtIndex:indexPath.item];
        memberInfo.isSelect=NO;
    }
    [self.choseArray removeObjectAtIndex:indexPath.item];
    [self.tableView reloadData];
    [self changeCollectUI];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40,40);
    
    
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searFriendWithText:self.searTextField.text];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)searTextFieldDidChange{
    if (!self.searTextField.markedTextRange) {
        [self searFriendWithText:self.searTextField.text];
    }
    
}

#pragma mark 懒加载

-(NSMutableArray *)friendItems{
    if (!_friendItems) {
        _friendItems=[[NSMutableArray alloc]init];
    }
    return _friendItems;
}

-(NSMutableArray *)choseArray{
    if (!_choseArray) {
        _choseArray = [NSMutableArray array];
    }
    return _choseArray;
}

//不可点击时候绿色 ace4c1 白色 c5ebd2
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sureBtn setFrame:(CGRectMake(0, 0, 50, 30))];
        [_sureBtn setTitle:NSLocalizedString(@"Done", 完成) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:UIColorNavBarBackColor forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(creatAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setFrame:(CGRectMake(0, 0, 50, 30))];
        [_cancelBtn setTitle:@"UIAlertController.cancel.title".icanlocalized forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorNavBarBackColor forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _cancelBtn;
}
-(SelectMembersHeaderView *)headView{
    if (!_headView) {
        _headView=[[SelectMembersHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        @weakify(self);
        _headView.gotoNewChatBlock = ^{
            @strongify(self);
            GroupListViewController*vc=[[GroupListViewController alloc]init];
            vc.selectBlock = ^(NSArray * _Nonnull selectGroupArray) {
                if (self.transpondBlock) {
                    self.transpondBlock(selectGroupArray);
                }
            };
            vc.fromTranpond = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    return _headView;
}

-(void)loadFriendsRequest{
    GetFriendsListRequest * request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray<UserMessageInfo*>* response) {
        self.friendItems =[NSMutableArray arrayWithArray:response];
        for (UserMessageInfo*info in self.friendItems) {
            info.canEnabled = YES;
        }
        [self restartsortObjects];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(void)creatGroupRequest{
    CreateGroupRequest * request= [CreateGroupRequest request];
    NSMutableArray * array = [NSMutableArray array];
    NSMutableString * groupName = [NSMutableString new];
    for (int i = 0; i<self.choseArray.count; i++) {
        UserMessageInfo *model = self.choseArray[i];
        if (i!= 0) {
            [groupName appendString:@", "];
        }
        [array addObject:model.userId];
        [groupName appendString:model.nickname];
    }
    if (groupName.length>15) {
        request.name = [groupName substringWithRange:NSMakeRange(0, 15)];
    }else{
        request.name =groupName;
    }
    request.inviterIds = array;
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showLoadingWihtMessage:NSLocalizedString(@"Create...", 创建中...) inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[CreateGroupInfo class] contentClass:[CreateGroupInfo class] success:^(CreateGroupInfo* response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Successfully created", 成功创建) inView:self.view];
        [[WebSocketManager sharedManager]subscriptionGroupWihtGroupId:response.groupId];
        if (self.selectMemberType == SelectMenbersType_Transpond) {
            if (self.transpondBlock) {
                GroupListInfo*info = [[GroupListInfo alloc]init];
                info.name = groupName;
                info.groupId = response.groupId;
                info.userCount = [NSString stringWithFormat:@"%ld",self.choseArray.count];
                self.transpondBlock(@[info]);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            if (self.createGroupSuccessBlock) {
                self.createGroupSuccessBlock(response.groupId,groupName);
            }
            ChatModel*model=[[ChatModel alloc]init];
            model.chatID=response.groupId;
            model.showName = groupName;
            model.chatType =GroupChat ;
            [[NSNotificationCenter defaultCenter]postNotificationName:KCreatGroupSuccessNotification object:model];
            [self dismissViewControllerAnimated:YES completion:nil];
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getGroupList];
            });
        }
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)creatAction{
    if(self.choseArray.count > 0){
        switch (self.selectMemberType) {
            case SelectMembersType_chatList:{
                if (self.choseArray.count==1){
                    ChatModel*model=[[ChatModel alloc]init];
                    UserMessageInfo * userMessageInfo = self.choseArray.lastObject;
                    model.chatID=userMessageInfo.userId;
                    model.showName = userMessageInfo.nickname;
                    model.chatType =UserChat ;
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    if (self.chatWithFriendSuccessBlock) {
                        self.chatWithFriendSuccessBlock(model);
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:kChatWithFriendNotification object:model];
                    
                }else if (self.choseArray.count>1) {//创建群聊
                    [self creatGroupRequest];
                }
            }
                
                break;
            case SelectMembersType_ChatDetail:{
                if (self.choseArray.count>0) {
                    [self.choseArray addObject:self.userMessageInfo];
                    [self creatGroupRequest];
                }
                
            }
                break;
            case SelectMembersType_addMember:{
                if (self.choseArray.count > 0) {
                    InviteGroupRequest*request=[InviteGroupRequest request];
                    request.groupId = @([self.groupId integerValue]);
                    request.joinType = @"Invite";
                    request.inviterId = @([[UserInfoManager sharedManager].userId integerValue]);
                    NSMutableArray * array = [NSMutableArray array];
                    for (UserMessageInfo *model in self.choseArray) {
                        [array addObject:model.userId];
                    }
                    request.userIds = array;
                    request.parameters=[request mj_JSONString];
                    [QMUITipsTool showLoadingWihtMessage:NSLocalizedString(@"In invitation...", 邀请中...) inView:self.view];
                    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(id response) {
                        if (!self.groupDetailInfo.joinGroupReview) {
                            [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Successful invitation", 成功邀请) inView:self.view];
                            if (self.addMemberSuccessBlock) {
                                self.addMemberSuccessBlock(nil);
                            }
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }else{
                            [QMUITipsTool showSuccessWithMessage:@"Thereviewsubmitted".icanlocalized inView:nil];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        
                        
                    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                    }];
                }
                
            }
                
                break;
            case SelectMenbersType_kickOut:{
                if (self.choseArray.count > 0) {
                    KickOutGroupRequest * request = [KickOutGroupRequest request];
                    NSMutableArray * array = [NSMutableArray array];
                    for (GroupMemberInfo *model in self.choseArray) {
                        [array addObject:@([model.userId integerValue])];
                    }
                    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/group/remove/%@",self.groupId];
                    request.parameters=[array mj_JSONString];
                    [QMUITipsTool showLoadingWihtMessage:NSLocalizedString(@"Kicking people...", 踢人中...) inView:self.view];
                    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(id response) {
                        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Successfully kicked out", 成功踢出) inView:self.view];
                        if (self.quitMemberSuccessBlock) {
                            self.quitMemberSuccessBlock(nil);
                        }
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                    }];
                }
                
            }
                
                break;
            case SelectMenbersType_Timelines:{
                if (self.choseArray.count > 0) {
                    [self dismissViewControllerAnimated:NO completion:^{
                        if (self.addTimelinesAtMemberSuccessBlock) {
                            self.addTimelinesAtMemberSuccessBlock(self.choseArray);
                        }
                    }];
                }
            }
                break;
            case SelectMenbersType_Transpond:{
                if (self.choseArray.count>2) {
                    [self creatGroupRequest];
                }else{
                    if (self.transpondBlock) {
                        self.transpondBlock(self.choseArray);
                    }
                    
                }
                
            }
                break;
            default:
                break;
        }
    }else{
        [UIAlertController alertControllerWithTitle:nil message:@"Please select at least one user".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"Know".icanlocalized] handler:^(int index) {
        }];
    }
}
#pragma mark -- 获取群聊列表
-(void)getGroupList {
    GetGroupListRequest*request=[GetGroupListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupListInfo class] success:^(NSArray<GroupListInfo*>* response) {
        for (GroupListInfo*info in response) {
            [[WCDBManager sharedManager]updateGroupAllShutUp:info.groupId allShutUp:info.allShutUp];
        }
        [[WCDBManager sharedManager]insertOrUpdateGroupListInfoWithArray:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
@end
