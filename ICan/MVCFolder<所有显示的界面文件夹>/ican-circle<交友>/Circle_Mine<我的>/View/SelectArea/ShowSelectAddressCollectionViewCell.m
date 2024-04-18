//
/**
 - Copyright © 2021 limao01. All rights reserved.
 - Author: Created  by DZL on 11/1/2021
 - File name:  ShowSelectAddressCollectionViewCell.m
 - Description:
 - Function List:
 */


#import "ShowSelectAddressCollectionViewCell.h"
#import "ShowSelectAddressTableViewCell.h"
#import "FriendListFirstHeaderView.h"
#import "UITableView+SCIndexView.h"
@interface ShowSelectAddressCollectionViewCell()<UITableViewDelegate,UITableViewDataSource,SCIndexViewDelegate>

@property(weak, nonatomic) IBOutlet QMUITextField *searchTextField;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSIndexPath *selectIndexPath;
@property(nonatomic, strong) NSMutableArray *searchItems;
@property(nonatomic, assign) BOOL search;
@property(weak, nonatomic)   IBOutlet UIView *bgContentView;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)  NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic, strong)  NSMutableArray<NSArray*> *letterResultArr;
@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic, strong) dispatch_group_t group;

@end
@implementation ShowSelectAddressCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView registerClass:[FriendListFirstHeaderView class] forHeaderFooterViewReuseIdentifier:@"FriendListFirstHeaderView"];
    [self.tableView registNibWithNibName:kShowSelectAddressTableViewCell];
    [self.bgContentView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    //    "ShowSelectAddressView.seatchTitle"="请输入要搜索的地区";
    self.searchTextField.placeholder=@"ShowSelectAddressView.seatchTitle".icanlocalized;
    self.searchTextField.placeholderColor=UIColor153Color;
    self.contentView.backgroundColor=UIColor.whiteColor;
    self.tableView.sectionFooterHeight=0.1;
    self.tableView.sectionHeaderHeight=0.1;
    self.tableView.tableHeaderView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.tableFooterView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
}
-(NSMutableArray *)searchItems{
    if (!_searchItems) {
        _searchItems=[NSMutableArray array];
    }
    return _searchItems;
}
-(void)textDidChange{
    if (self.searchTextField.text.length>0&&!self.searchTextField.markedTextRange) {
        self.search=YES;
        [self.searchItems removeAllObjects];
        NSPredicate * cpredicate = [NSPredicate predicateWithFormat:@"areaName contains [cd] %@ ",self.searchTextField.text];
        self.searchItems=[NSMutableArray arrayWithArray:[self.areaItems filteredArrayUsingPredicate:cpredicate]];
        [self sortObjectsAccordingToInitialWith:self.searchItems];
    }else{
        self.search=NO;
        [self.searchItems removeAllObjects];
        [self.tableView reloadData];
        [self sortObjectsAccordingToInitialWith:self.areaItems];
    }
    
}
-(void)setAreaItems:(NSArray *)areaItems{
    self.search=NO;
    _areaItems=areaItems;
    [self sortObjectsAccordingToInitialWith:areaItems];
    [self.tableView reloadData];
}

// 按首字母分组排序数组
-( void)sortObjectsAccordingToInitialWith:(NSArray *)arr {
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
    for (AreaInfo *personModel in arr) {
        personModel.pinyinName = [personModel.areaName transformToPinyin];
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector: @selector(areaName)];
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
        AreaInfo*info=array.firstObject;
        [index addObject:[NSString firstCharactorWithString:info.areaName]];
    }
    self.letterResultArr =[NSMutableArray arrayWithArray:finalArr];
    NSMutableArray*newArray=[NSMutableArray array];
    for (NSArray*array in self.letterResultArr) {
        NSArray* sortArray=[array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            AreaInfo*info1=obj1;
            AreaInfo*info2=obj2;
            //比较排序
            return [info1.pinyinName compare:info2.pinyinName];
        }];
        [newArray addObject:sortArray];
    }
    self.letterResultArr=newArray;
    self.indexArray=[NSMutableArray arrayWithArray:index];
    self.tableView.sc_indexViewDataSource = self.indexArray.copy;
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
    self.tableView.sc_indexViewConfiguration = configuration;
    self.tableView.sc_indexView.delegate=self;
    [self.tableView reloadData];
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.indexArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.letterResultArr[section] count];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShowSelectAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowSelectAddressTableViewCell];
    AreaInfo*info= [self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
    cell.areaInfo=info;
    cell.selectImgView.hidden=!info.select;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.search) {
        AreaInfo*info=[self.letterResultArr objectAtIndex:indexPath.section][indexPath.row];
        if (self.addressViewType == AddressViewType_SetUserMessage) {
            if (info.level == 1) {
                return;
            }
        }
        for (AreaInfo*dinfo in self.areaItems) {
            dinfo.select=NO;
        }
        
        info.select=YES;
        [self.tableView reloadData];
        !self.selectBlock?:self.selectBlock(info);
        self.searchTextField.text=@"";
        self.search=NO;
    }else{
        AreaInfo*info=self.letterResultArr[indexPath.section][indexPath.row];
        if (self.addressViewType == AddressViewType_SetUserMessage) {
            if (info.level == 1) {
                return;
            }
        }
        for (AreaInfo*dinfo in self.areaItems) {
            dinfo.select=NO;
        }
        info.select=YES;
        [self.tableView reloadData];
        !self.selectBlock?:self.selectBlock(info);
    }
    
    
}

@end
