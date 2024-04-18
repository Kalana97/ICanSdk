//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 18/11/2019
 - File name:  SelectMobileCodeViewController.m
 - Description:
 - Function List:
 */


#import "SelectMobileCodeViewController.h"
#import "RightArrowTableViewCell.h"
#import "UITableView+SCIndexView.h"
#import "FriendListFirstHeaderView.h"
#import "SelectMobileCodeSectionHeader.h"
#import "SearchHeadView.h"
#import "RegisterViewController.h"
@interface SelectMobileCodeViewController ()<QMUISearchControllerDelegate>
@property (nonatomic,strong) NSMutableArray<AllCountryInfo*> * countryItems;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong) NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong) NSMutableArray *letterResultArr;

@property(nonatomic, strong) SearchHeadView *chatListSearchHeadView;
@property(nonatomic, strong) NSIndexPath *selectIndexPath;
@property(nonatomic, strong) UIButton *rightButton;
@end

@implementation SelectMobileCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isSelectArea) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    }else{
        self.navigationItem.leftBarButtonItem=[UIBarButtonItem qmui_itemWithTitle:@"UIAlertController.cancel.title".icanlocalized target:self action:@selector(cancelAction)];
    }
    if(self.isRecharge == YES){
        [self getCountriesAvailableData];
        NSLog(@"Other");
    }else if(self.isTopUp == YES){
        [self getEnabledCountryRequest];
    }else{
        [self getAllCountryRequest];
    }
    if (self.isSelectArea) {
        self.title =@"SelectMobileTitle".icanlocalized;
    }
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton dzButtonWithTitle:@"NextStep".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:14 titleColor:UIColor252730Color target:self action:@selector(rightBarButtonItemAction)];
    }
    return _rightButton;
}

-(void)getEnabledCountryRequest{
  [self.countryItems addObjectsFromArray:self.sentListOfCountries];
  [self sortCountrys:self.countryItems];
}

-(void)rightBarButtonItemAction{
    if (!self.selectIndexPath) {
        [QMUITipsTool showOnlyTextWithMessage:@"SelectMobileTitle".icanlocalized inView:self.view];
    }else{
        AllCountryInfo * info = [self.letterResultArr objectAtIndex:self.selectIndexPath.section][self.selectIndexPath.row];
        [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@",@"SureSelect".icanlocalized,BaseSettingManager.isChinaLanguages?info.nameCn:info.nameEn] message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index == 1) {
                [UserInfoManager sharedManager].areaNum = info.phoneCode;
                RegisterViewController*vc=[[RegisterViewController alloc]init];
                vc.selectCountryInfo = info;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        
    }
}
-(void)sortCountrys:(NSArray*)countrysListCoreDataArray{
    NSMutableDictionary*countryDict=[NSMutableDictionary dictionary];
    for (AllCountryInfo * info in countrysListCoreDataArray) {
        NSMutableArray*array=[countryDict objectForKey:[NSString firstCharactorWithString:BaseSettingManager.isChinaLanguages?info.nameCn: info.nameEn]];
        if (!array) {
            array=[NSMutableArray array];
            [countryDict setObject:array forKey:[NSString firstCharactorWithString:BaseSettingManager.isChinaLanguages?info.nameCn: info.nameEn]];
        }
        [array addObject:info];
    }
    //获取排序之后的字母
    NSArray *sortArray=  [countryDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return  [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    self.indexArray=[NSMutableArray arrayWithArray:sortArray];
    self.letterResultArr=[NSMutableArray array];
    for (NSString * key in self.indexArray) {
        
        [self.letterResultArr addObject:[countryDict objectForKey:key]];
    }
    self.tableView.sc_indexViewDataSource = self.indexArray.copy;
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
    self.tableView.sc_indexViewConfiguration = configuration;
    [self.tableView reloadData];
    
    
}
-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
    }];
    [self.tableView registNibWithNibName:kRightArrowTableViewCell];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    
    if (self.isSelectArea) {
        SelectMobileCodeSectionHeader *header=[[NSBundle mainBundle]loadNibNamed:@"SelectMobileCodeSectionHeader" owner:self options:@{}].firstObject;
        header.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            [self searFriendWithText:search];
        };
        self.tableView.tableHeaderView = header;
        [self.tableView.tableHeaderView layoutIfNeeded];
        CGFloat height = header.scollview.contentSize.height;
        header.frame = CGRectMake(0, 0, ScreenWidth, height);
        self.tableView.tableHeaderView = header;
    }else{
        self.tableView.tableHeaderView=self.chatListSearchHeadView;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FriendListFirstHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FriendListFirstHeaderView"];
    view.titleLabel.text=self.indexArray[section];
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.indexArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)self.letterResultArr[section] count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightRightArrowTableViewCell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RightArrowTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kRightArrowTableViewCell];
    AllCountryInfo * info = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    if (BaseSettingManager.isChinaLanguages) {
        cell.titleLabel.text=info.nameCn;
    }else{
        cell.titleLabel.text=info.nameEn;
    }
    if (indexPath == self.selectIndexPath) {
        cell.titleLabel.textColor = UIColorThemeMainColor;
    }else{
        cell.titleLabel.textColor=UIColorThemeMainTitleColor;
    }
    cell.flagImg.hidden = NO;
    if(info.flagUrl != nil && ![info.flagUrl isEqualToString:@""]) {
        [cell.flagImg sd_setImageWithURL:[NSURL URLWithString:info.flagUrl]];
    }else {
        cell.flagImg.hidden = YES;
    }
    cell.flagImg.layer.borderWidth = 1.0;
    cell.flagImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.titleLabel.font = [UIFont systemFontOfSize:17];
    cell.descriptionLabel.font = [UIFont systemFontOfSize:16];
    cell.descriptionLabel.text=info.phoneCode;
    cell.arrowImageView.hidden=YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSelectArea) {
        self.selectIndexPath = indexPath;
        [self.rightButton setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        [self.tableView reloadData];
    }else{
        AllCountryInfo * info = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
        UserInfoManager.sharedManager.areaNum = info.phoneCode;
        if (self.selectAreaBlock) {
            self.selectAreaBlock(info);
        }
        !self.selectCodeBlock?:self.selectCodeBlock(info.phoneCode);
        [self cancelAction];
    }
}
-(SearchHeadView *)chatListSearchHeadView{
    if (!_chatListSearchHeadView) {
        _chatListSearchHeadView=[[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _chatListSearchHeadView.searchTextFiledPlaceholderString = NSLocalizedString(@"Search",搜索);
        _chatListSearchHeadView.shouShowKeybord=YES;
        ViewRadius(_chatListSearchHeadView.bgView, 15.0);
        @weakify(self);
        _chatListSearchHeadView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searFriendWithText:search];
        };
        
    }
    return _chatListSearchHeadView;
}
-(void)searFriendWithText:(NSString*)searchText{
    //如果是退出群聊 那么里面的选择都是群成员
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nameCn CONTAINS[c] %@ || nameEn CONTAINS[c] %@ || phoneCode CONTAINS[c] %@",searchText,searchText,searchText];
    NSArray*searArray= [self.countryItems filteredArrayUsingPredicate:gpredicate];
    [self sortCountrys:searArray];
    if ([NSString isEmptyString:searchText]) {
        self.selectIndexPath = nil;
        [self sortCountrys:self.countryItems];
    }
}
-(NSMutableArray *)countryItems{
    if (!_countryItems) {
        _countryItems=[NSMutableArray array];
    }
    return _countryItems;
}
-(void)getAllCountryRequest{
    GetAllCountriesRequest*request = [GetAllCountriesRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[AllCountryInfo class] success:^(NSArray* response) {
        [self.countryItems addObjectsFromArray:response];
        [self sortCountrys:self.countryItems];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
}

-(void)getCountriesAvailableData{
    GetCountriesAvailableDataRequest*request = [GetCountriesAvailableDataRequest request];
    request.dialogClass = self.dialogClass;
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[AllCountryInfo class] success:^(NSArray* response) {
        [QMUITips hideAllTips];
        [self.countryItems addObjectsFromArray:response];
        [self sortCountrys:self.countryItems];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}
@end
