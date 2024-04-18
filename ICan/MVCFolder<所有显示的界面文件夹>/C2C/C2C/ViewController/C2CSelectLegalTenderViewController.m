//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/11/2021
- File name:  C2CSelectLegalTenderViewController.m
- Description:
- Function List:
*/
        

#import "C2CSelectLegalTenderViewController.h"
#import "C2CSelectLegalTenderTableViewCell.h"
#import "C2CSelectLegalTenderHeadView.h"
#import "UITableView+SCIndexView.h"
#import "C2CSelectLegalTenderSectionHeadView.h"
#import "C2CCollectLegalTenderViewController.h"
@interface C2CSelectLegalTenderViewController ()<SCIndexViewDelegate>
/** 支持的全部法币 */
@property (nonatomic, strong) NSArray<CurrencyInfo*> *legalTenderItems;
@property (nonatomic, strong) NSArray<CurrencyInfo*> *showLegalTenderItems;
@property (nonatomic, strong) C2CSelectLegalTenderHeadView *headView;

@property(nonatomic,strong)  NSMutableArray<CurrencyInfo*> *friendItem;

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)  NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)  NSMutableArray *letterResultArr;
@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic, strong) dispatch_group_t group;
@end

@implementation C2CSelectLegalTenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"C2CSelectLegalTenderViewControllerTitle".icanlocalized;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type contains [cd] %@ ",@"LegalTender"];
    self.legalTenderItems =  [C2CUserManager.shared.allSupportedCurrencyItems filteredArrayUsingPredicate:predicate];
    self.showLegalTenderItems = _legalTenderItems;
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.group = dispatch_group_create();
    [self sortObjectsAccordingToInitialWith:self.showLegalTenderItems];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"collect".icanlocalized target:self action:@selector(goCollectVc)];
}
-(void)goCollectVc{
    C2CCollectLegalTenderViewController*vc = [[C2CCollectLegalTenderViewController alloc]init];
    vc.changeBlock = ^{
        [self.tableView reloadData];
    };
    vc.selectBlock = ^(CurrencyInfo * _Nonnull info) {
        !self.selectBlock?:self.selectBlock(info);
//        [self.navigationController popViewControllerAnimated:YES];
    };
    [[AppDelegate shared]pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.tableHeaderView = self.headView;
    [self.tableView registerNib:[UINib nibWithNibName:@"C2CSelectLegalTenderSectionHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"C2CSelectLegalTenderSectionHeadView"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:kC2CSelectLegalTenderTableViewCell];
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
        for (CurrencyInfo *personModel in arr) {
            //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
            NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:@selector(code)];
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
            CurrencyInfo*info=array.firstObject;
            [index addObject:[NSString firstCharactorWithString:info.code]];
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
    C2CSelectLegalTenderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kC2CSelectLegalTenderTableViewCell];
    CurrencyInfo * info = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    cell.currencyInfo = info;
    cell.selectBlock = ^(BOOL select) {
        [self collectOrCancelCollect:select code:info.code];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyInfo* info = [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    C2CUserManager.shared.currentCurrencyInfo = info;
    !self.selectBlock?:self.selectBlock(info);
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)collectOrCancelCollect:(BOOL)select code:(NSString*)code{
    if (select) {
        PostC2CCollectCurrencyRequest * request = [PostC2CCollectCurrencyRequest request];
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/currency/collect/%@",code];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
            
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            
        }];
    }else{
        DeleteC2CCollectCurrencyRequest * request = [DeleteC2CCollectCurrencyRequest request];
        request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/currency/collect/%@",code];
        [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id  _Nonnull response) {
            
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            
        }];
    }
    
}
-(C2CSelectLegalTenderHeadView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"C2CSelectLegalTenderHeadView" owner:self options:nil].firstObject;
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 95);
        @weakify(self);
        _headView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            [self searFriendWithText:search];
        };
        _headView.tapBlock = ^{
            C2CCollectLegalTenderViewController*vc = [[C2CCollectLegalTenderViewController alloc]init];
            vc.changeBlock = ^{
                @strongify(self);
                [self.tableView reloadData];
            };
            vc.selectBlock = ^(CurrencyInfo * _Nonnull info) {
                @strongify(self);
                !self.selectBlock?:self.selectBlock(info);
                [self.navigationController popViewControllerAnimated:YES];
            };
            [[AppDelegate shared]pushViewController:vc animated:YES];
        };
    }
    return _headView;
}
-(void)searFriendWithText:(NSString*)searchText{
    
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"nameCn CONTAINS[c] %@ || nameEn CONTAINS[c] %@ || code CONTAINS[c] %@ ",searchText,searchText,searchText];
    NSArray*array = [self.legalTenderItems filteredArrayUsingPredicate:gpredicate];
    [self sortObjectsAccordingToInitialWith:array];
    if ([NSString isEmptyString:searchText]) {
        [self sortObjectsAccordingToInitialWith:self.showLegalTenderItems];
    }
    
   
}

@end
