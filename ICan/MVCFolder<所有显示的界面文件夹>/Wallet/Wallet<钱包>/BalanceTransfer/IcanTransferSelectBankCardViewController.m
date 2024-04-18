//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 18/2/2022
 - File name:  IcanTransferSelectBankCardViewController.m
 - Description:
 - Function List:
 */


#import "IcanTransferSelectBankCardViewController.h"
#import "IcanTransferSelectBankCardCell.h"
#import "UITableView+SCIndexView.h"
#import "C2CSelectLegalTenderSectionHeadView.h"
#import "IcanTransferSelectBankCardHeadView.h"
@interface IcanTransferSelectBankCardViewController ()<SCIndexViewDelegate>
@property(nonatomic, strong) NSArray<CommonBankCardsInfo*> *allBankItems;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)  NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)  NSMutableArray *letterResultArr;
@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic, strong) dispatch_group_t group;
@property(nonatomic, strong) IcanTransferSelectBankCardHeadView *headView;
@end

@implementation IcanTransferSelectBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    "Pleaseenterbankname"="请输入银行名称";
    self.title = @"Selectanaccountbank".icanlocalized;
    self. queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.group = dispatch_group_create();
    [self fetchAllBankCardRequest];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.tableHeaderView = self.headView;
    [self.tableView registerNib:[UINib nibWithNibName:@"C2CSelectLegalTenderSectionHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"C2CSelectLegalTenderSectionHeadView"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kIcanTransferSelectBankCardCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

// 按首字母分组排序数组
-( void)sortObjectsAccordingToInitialWith:(NSArray *)arr {
    /*任务a */
    dispatch_group_enter(self.group);
    dispatch_group_async(self.group, self.queue, ^{
        // 初始化UILocalizedIndexedCollation
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        //得出collation索引的数量，这里是27个（26个字母和1个#）
        NSInteger sectionTitlesCount = [[collation sectionTitles] count];
        //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
        //
        NSMutableArray *newSectionsArray= [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
        //初始化27个空数组加入newSectionsArray
        for (NSInteger index = 0; index < sectionTitlesCount; index++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [newSectionsArray addObject:array];
        }
        
        //将每个名字分到某个section下
        for (CommonBankCardsInfo *personModel in arr) {
            //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
            NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:@selector(name)];
            //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
            NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
            [sectionNames addObject:personModel];
        }
        NSMutableArray *finalArr = [NSMutableArray new];
        NSMutableArray*index=[NSMutableArray array];
        for (NSInteger index = 0; index < sectionTitlesCount; index++) {
            if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
                [finalArr addObject:newSectionsArray[index]];
            }
        }
        for (NSArray*array in finalArr) {
            CommonBankCardsInfo*info=array.firstObject;
            [index addObject:[NSString firstCharactorWithString:info.name]];
        }
        self.letterResultArr =[NSMutableArray arrayWithArray:finalArr];
        self.indexArray=[NSMutableArray arrayWithArray:index];
        dispatch_group_leave(self.group);
    });
    dispatch_group_notify(self.group,self.queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.sc_indexViewDataSource = self.indexArray.copy;
            SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
            self.tableView.sc_indexViewConfiguration = configuration;
            self.tableView.sc_indexView.delegate=self;
            [self.tableView reloadData];
        });
        
    });
    
}
-(void)indexView:(SCIndexView *)indexView didSelectAtSection:(NSUInteger)section{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}
/**
 当滑动tableView时，索引位置改变，你需要自己返回索引位置时，实现此方法。
 不实现此方法，或者方法的返回值为 SCIndexViewInvalidSection 时，索引位置将由控件内部自己计算。
 
 @param indexView 索引视图
 @param tableView 列表视图
 @return          索引位置
 */
- (NSUInteger)sectionOfIndexView:(SCIndexView *)indexView tableViewDidScroll:(UITableView *)tableView{
    NSInteger firstVisibleSection = self.tableView.indexPathsForVisibleRows.firstObject.section;
    return firstVisibleSection;
}

-(void)layoutTableView{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    C2CSelectLegalTenderSectionHeadView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"C2CSelectLegalTenderSectionHeadView"];
    view.titleLabel.text=self.indexArray[section];
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 37;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 37;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.letterResultArr[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.indexArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IcanTransferSelectBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:kIcanTransferSelectBankCardCell];
    CommonBankCardsInfo * info = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    cell.cardInfo = info;
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonBankCardsInfo* info = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    !self.selectBlock?:self.selectBlock(info);
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)fetchAllBankCardRequest{
    IcanAllBankCardsRequest * request = [IcanAllBankCardsRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CommonBankCardsInfo class] success:^(NSArray* response) {
        self.allBankItems = response;
        [self sortObjectsAccordingToInitialWith:self.allBankItems];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(IcanTransferSelectBankCardHeadView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"IcanTransferSelectBankCardHeadView" owner:self options:nil].firstObject;
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 65);
        @weakify(self);
        _headView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searFriendWithText:search];
        };
        
    }
    return _headView;
}
-(void)searFriendWithText:(NSString*)searchText{
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",searchText];
    NSArray*array = [self.allBankItems filteredArrayUsingPredicate:gpredicate];
    [self sortObjectsAccordingToInitialWith:array];
    if ([NSString isEmptyString:searchText]) {
        [self sortObjectsAccordingToInitialWith:self.allBankItems];
    }
    
   
}
@end
