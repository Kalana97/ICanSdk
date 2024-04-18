//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 21/5/2021
 - File name:  CircleSelectHobbyViewController.m
 - Description:
 - Function List:
 */


#import "CircleSelectHobbyViewController.h"
#import "CircleSelectHobbyTbleViewCell.h"
@interface CircleSelectHobbyViewController ()
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) NSArray<HobbyTagsInfo*> *hobbyItems;

@property(nonatomic, strong) NSMutableArray<HobbyTagsInfo*> *currentSelectItems;
/**
 当前是否正在搜索
 */
@property(nonatomic, assign) BOOL search;
@property(nonatomic, strong) UIView *searchBgView;
@property(nonatomic, strong) QMUITextField *searchTextField;
/**
 搜索结果的数组
 */
@property(nonatomic, strong) NSArray<HobbyTagsInfo*> *searchHobbyItems;
@property(nonatomic, copy) NSString *searchText;
@end

@implementation CircleSelectHobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    "CircleSelectHobbyViewController.title"="兴趣爱好";
    //    "CircleSelectHobbyViewController.rightButton"="确认";
    self.title=@"CircleSelectHobbyViewController.title".icanlocalized;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChang) name:UITextFieldTextDidChangeNotification object:nil];
    [self getHobbyRequest];
    
}
-(void)initTableView{
    [super initTableView];
    [self.view addSubview:self.searchBgView];
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.mas_equalTo(-20);
        make.height.equalTo(@60);
        make.top.equalTo(@(NavBarHeight+10));
    }];
    [self.searchBgView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.mas_equalTo(-10);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.searchBgView.mas_centerY);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(@0);
        make.top.equalTo(self.searchBgView.mas_bottom).offset(10);
    }];
    [self.tableView registNibWithNibName:kCircleSelectHobbyTbleViewCell];
    
}

-(void)layoutTableView{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.search) {
        return self.searchHobbyItems.count;
    }
    return self.hobbyItems.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleSelectHobbyTbleViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kCircleSelectHobbyTbleViewCell];
    if (self.search) {
        cell.hobbyInfo=self.searchHobbyItems[indexPath.row];
    }else{
        cell.hobbyInfo=self.hobbyItems[indexPath.row];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.search) {
        HobbyTagsInfo*info=[self.searchHobbyItems objectAtIndex:indexPath.row];
        info.select=!info.select;
        if (info.select) {
            [self.currentSelectItems addObject:info];
        }else{
            [self.currentSelectItems removeObject:info];
        }
    }else{
        HobbyTagsInfo*info=[self.hobbyItems objectAtIndex:indexPath.row];
        info.select=!info.select;
        if (info.select) {
            [self.currentSelectItems addObject:info];
        }else{
            [self.currentSelectItems removeObject:info];
        }
    }
    
    [self.tableView reloadData];
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton dzButtonWithTitle:@"CircleSelectHobbyViewController.rightButton".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:16 titleColor:UIColorThemeMainColor target:self action:@selector(rightBarButtonItemAction)];
    }
    return _rightButton;
}
-(NSMutableArray<HobbyTagsInfo *> *)currentSelectItems{
    if (!_currentSelectItems) {
        _currentSelectItems=[NSMutableArray array];
    }
    return _currentSelectItems;
}
-(void)rightBarButtonItemAction{
    //如果当前存在搜索字符串
    if (self.searchText.length>0) {
//        并且搜索数组的数量大于0
        if (self.searchHobbyItems.count>0) {
            NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"select = %d ",YES];
            NSArray*selectImtes=[self.searchHobbyItems filteredArrayUsingPredicate:gpredicate];
            //如果当前的搜索结果存在选中的爱好，那么不添加新标签
            if (selectImtes.count>0) {
                [self success];
            }else{
                self.rightButton.hidden=YES;
            }
        }else{
            self.rightButton.hidden=YES;
        }
        
    }else{
        [self success];
    }
}
-(void)success{
    if (self.selectHobbyBlock) {
        self.selectHobbyBlock(self.currentSelectItems);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)searchBgView{
    if (!_searchBgView) {
        _searchBgView=[[UIView alloc]init];
        [_searchBgView layerWithCornerRadius:10 borderWidth:1 borderColor:UIColorMake(163, 168, 178)];
    }
    return _searchBgView;
}
-(QMUITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField=[[QMUITextField alloc]init];
//        "CircleSelectHobbyViewController.searchTextField"="创建自己的标签/搜索标签";
        _searchTextField.placeholder=@"CircleSelectHobbyViewController.searchTextField".icanlocalized;
        _searchTextField.placeholderColor=UIColor252730Color;
        _searchTextField.font=[UIFont systemFontOfSize:14];
    }
    return _searchTextField;
}
-(void)textFieldDidChang{
    self.searchText=self.searchTextField.text.trimmingwhitespaceAndNewline;
    if (self.searchText.length>0&&!self.searchTextField.markedTextRange) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@ OR nameEn CONTAINS[c] %@",self.searchText,self.searchText];
        self.searchHobbyItems= [self.hobbyItems filteredArrayUsingPredicate:predicate];
        self.search=YES;
        self.rightButton.hidden=self.searchHobbyItems.count==0;
    }else{
        self.rightButton.hidden=NO;
        self.search=NO;
    }
    [self.tableView reloadData];
}
-(void)getHobbyRequest{
    GetHobbyTagsRequest*request=[GetHobbyTagsRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[HobbyTagsInfo class] success:^(NSArray<HobbyTagsInfo*>* response) {
        self.hobbyItems=response;
        for (HobbyTagsInfo*info in self.selectHobbyItems) {
            for (HobbyTagsInfo*rInfo in response) {
                if (info.hobbyTagId==rInfo.hobbyTagId) {
                    rInfo.select=YES;
                    [self.currentSelectItems addObject:rInfo];
                    break;
                }
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)createNewHobbyTags{
    PostHobbyTagsRequest*request=[PostHobbyTagsRequest request];
    request.name=self.searchText;
    request.parameters=[request mj_JSONObject];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[HobbyTagsInfo class] contentClass:[HobbyTagsInfo class] success:^(HobbyTagsInfo* response) {
        response.select=YES;
        [self.currentSelectItems addObject:response];
        [self success];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
@end
