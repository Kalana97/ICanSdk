//
/**
- Copyright © 2021 limao01. All rights reserved.
- Author: Created  by DZL on 11/1/2021
- File name:  ShowSelectAddressView.m
- Description:
- Function List:
*/
        

#import "ShowSelectAddressView.h"
#import "ShowSelectAddressCollectionViewCell.h"
#import "SelectAreaCollectionViewCell.h"
@interface ShowSelectAddressView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UIView *bgContentView;
@property(nonatomic, strong) UILabel *titleLabel;
/**
 显示所有地区的collecionView
 */
@property(nonatomic, strong) UICollectionView *collectionView;
/**
 选择之后显示的collectionView
 */
@property(nonatomic, strong) UICollectionView *titleCollectionView;
@property(nonatomic, strong) UIView *topView;
/**
 当前滑动的是第几个cell
 */
@property(nonatomic, strong) NSIndexPath *currentSelectIndexPath;

@end
@implementation ShowSelectAddressView
-(void)didShowSelectAddressView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    self.alpha=0.5;
    [UIView animateWithDuration:0.2 animations:^{
        
    }];
    [self.collectionView reloadData];
}
-(void)hiddenSelectAddressView{
    [self removeFromSuperview];
//    self.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{
       
    }];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //初始化获取本地缓存的所有地区信息
        
        NSString*string=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"area" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];;
        [self.numberItems addObject:[AreaInfo mj_objectArrayWithKeyValuesArray:string.mj_JSONString]];
        self.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
        self.currentSelectIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self addSubview:self.bgContentView];
        [self.bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@200);
            make.left.right.bottom.equalTo(@0);
        }];
        [self.bgContentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.top.equalTo(@20);
        }];
        
        [self.bgContentView addSubview:self.titleCollectionView];
        [self.titleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.height.equalTo(@40);
        }];
        [self.bgContentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
            make.top.equalTo(self.titleCollectionView.mas_bottom).offset(0);
        }];
        [self addTarget:self action:@selector(hiddenSelectAddressView) forControlEvents:UIControlEventTouchUpInside];
        [self.bgContentView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
    }
    return self;
}
-(void)setAddressViewType:(AddressViewType)addressViewType{
    _addressViewType=addressViewType;
    if (addressViewType==AddressViewType_Home) {
        self.sureBtn.hidden=NO;
    }else if (addressViewType==AddressViewType_SetUserMessage){
        if (self.userInfo.countryId) {
            NSArray*countryItems=self.numberItems.firstObject;
            AreaInfo*countryInfo;
            for (AreaInfo*info in countryItems) {
                if (info.areaId==self.userInfo.countryId.integerValue) {
                    info.select=YES;
                    countryInfo=info;
                    [self.selectAreaItems addObject:countryInfo];
                    break;
                }
            }
            //如果存在省份
            AreaInfo*provinceInfo;
            if (self.userInfo.provinceId) {
                NSArray*provinceItems=countryInfo.areas;
                for (AreaInfo*info in provinceItems) {
                    if (info.areaId==self.userInfo.provinceId.integerValue) {
                        info.select=YES;
                        provinceInfo=info;
                        [self.selectAreaItems addObject:provinceInfo];
                        [self.numberItems addObject:provinceItems];
                        break;
                    }
                }
            }
            
            AreaInfo*cityInfo;
            if (self.userInfo.cityId) {
                NSArray*cityItems=provinceInfo.areas;
                for (AreaInfo*info in cityItems) {
                    if (info.areaId==self.userInfo.cityId.integerValue) {
                        info.select=YES;
                        cityInfo=info;
                        [self.selectAreaItems addObject:cityInfo];
                        [self.numberItems addObject:cityItems];
                        break;
                    }
                }
            }
            [self.collectionView reloadData];
            [self.titleCollectionView reloadData];
            self.currentSelectIndexPath=[NSIndexPath indexPathForItem:self.numberItems.count-1 inSection:0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView scrollToItemAtIndexPath:self.currentSelectIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
                [self.titleCollectionView scrollToItemAtIndexPath:self.currentSelectIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            });
            self.userInfo.currentSelectItems=self.selectAreaItems;
            
        }
    }
}
-(UICollectionView *)collectionView{
    if (_collectionView==nil) {
        UICollectionViewFlowLayout*lay=[[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _collectionView.dataSource                      = self;
        _collectionView.delegate                        = self;
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.showsHorizontalScrollIndicator  = YES;
        _collectionView.scrollEnabled                   = YES;
        _collectionView.pagingEnabled=YES;
        _collectionView.backgroundColor                 = [UIColor whiteColor];
        [_collectionView registNibWithNibName:kShowSelectAddressCollectionViewCell];
    }
    return _collectionView;
}
-(UICollectionView *)titleCollectionView{
    if (_titleCollectionView==nil) {
        UICollectionViewFlowLayout*lay=[[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _titleCollectionView.dataSource                      = self;
        _titleCollectionView.delegate                        = self;
        _titleCollectionView.showsVerticalScrollIndicator    = NO;
        _titleCollectionView.showsHorizontalScrollIndicator  = NO;
        _titleCollectionView.scrollEnabled                   = YES;
        _titleCollectionView.backgroundColor                 = [UIColor whiteColor];
        [_titleCollectionView registNibWithNibName:kSelectAreaCollectionViewCell];
    }
    return _titleCollectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView==self.collectionView) {
        return self.numberItems.count;
    }
    return self.numberItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.collectionView) {
        ShowSelectAddressCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kShowSelectAddressCollectionViewCell forIndexPath:indexPath];
        cell.areaItems=[self.numberItems objectAtIndex:indexPath.item];
        cell.addressViewType = self.addressViewType;
        //点击了了tableViewcell的地址
        cell.selectBlock = ^(AreaInfo * _Nonnull areaInfo) {
            //如果是再次编辑设置用户信息 那么国家不能改变了
            if (self.addressViewType==AddressViewType_SetUserMessage) {
                if (self.selectAreaItems.count>0) {
                    if (indexPath.item==0) {
                        return;
                    }
                }
            }
            if (self.selectAreaItems.count>=indexPath.item+1) {
                NSInteger index=indexPath.item;
                NSInteger length=self.selectAreaItems.count-indexPath.item;
                [self.selectAreaItems removeObjectsInRange:NSMakeRange(index, length)];
            }
            [self.selectAreaItems addObject:areaInfo];
            //移除当前选择的地区的最后所有数据
            if (self.numberItems.count>indexPath.item+1) {
                NSInteger index=indexPath.item+1;
                NSInteger length=self.numberItems.count-indexPath.item-1;
                [self.numberItems removeObjectsInRange:NSMakeRange(index, length)];
            }
            if (areaInfo.areas.count>0) {
                [self getNextArea:areaInfo indexPath:indexPath];
            }else{
                [self.collectionView reloadData];
                [self.titleCollectionView reloadData];
                !self.successBlock?:self.successBlock(self.selectAreaItems);
                [self hiddenSelectAddressView];
            }
        };
        return cell;
    }
    SelectAreaCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kSelectAreaCollectionViewCell forIndexPath:indexPath];
    cell.currentAreaitems=[self.numberItems objectAtIndex:indexPath.item];
    cell.lineView.hidden=!(self.currentSelectIndexPath==indexPath);
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==self.collectionView) {
        CGFloat contentOffsetx=scrollView.contentOffset.x;
        NSInteger index=contentOffsetx/ScreenWidth;
        self.currentSelectIndexPath=[NSIndexPath indexPathForItem:index inSection:0];
        [self.titleCollectionView reloadData];
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==self.titleCollectionView) {
        self.currentSelectIndexPath=indexPath;
        [self.titleCollectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.collectionView) {
        return CGSizeMake(ScreenWidth,ScreenHeight-320);
    }
    AreaInfo*selectInfo;
    NSString*title;
    //判断当前列表数组是否有选中的的地区 如果有  那么title就显示areaName
    NSArray*items=[self.numberItems objectAtIndex:indexPath.row];
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"select = %d ",YES];
    NSArray<AreaInfo*>*selectImtes=[items filteredArrayUsingPredicate:gpredicate];
    if (selectImtes.count>0) {
        selectInfo=selectImtes.firstObject;
        if (BaseSettingManager.isChinaLanguages) {
            title=selectInfo.areaName;
        }else{
            title=selectInfo.areaNameEn?:selectInfo.areaName;
        }
       
    }else{
        title=@"ShowSelectAddressView.pleasSelect".icanlocalized;
    }
    CGFloat width=[NSString widthForString:title withFontSize:15 height:20]+30;
    return CGSizeMake(width,40);
    
    
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==self.collectionView) {
        return 0;
    }
    return 0;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==self.collectionView) {
        return 0;
    }
    return 0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(void)getNextArea:(AreaInfo*)areaInfo indexPath:(NSIndexPath*)indexPath{
    [self.numberItems addObject:areaInfo.areas];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    self.currentSelectIndexPath=[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0];
    [self.titleCollectionView reloadData];
}
-(NSMutableArray<AreaInfo *> *)selectAreaItems{
    if (!_selectAreaItems) {
        _selectAreaItems=[NSMutableArray array];
    }
    return _selectAreaItems;
}
-(NSMutableArray<NSArray<AreaInfo *> *> *)numberItems{
    if (!_numberItems) {
        _numberItems=[NSMutableArray array];
    }
    return _numberItems;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel centerLabelWithTitle:@"ShowSelectAddressView.titleLabel".icanlocalized font:17 color:UIColor252730Color];
    }
    return _titleLabel;
}
-(UIView *)bgContentView{
    if (!_bgContentView) {
        _bgContentView=[[UIView alloc]init];
        _bgContentView.backgroundColor=UIColor.whiteColor;
    }
    return _bgContentView;
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn=[UIButton dzButtonWithTitle:@"ShowSelectAddressView.sureBtn".icanlocalized image:nil backgroundColor:UIColor.whiteColor titleFont:16 titleColor:UIColorThemeMainColor target:self action:@selector(sureBtnAction)];
        _sureBtn.hidden=YES;
    }
    return _sureBtn;
}
-(void)sureBtnAction{
    !self.successBlock?:self.successBlock(self.selectAreaItems);
    [self hiddenSelectAddressView];
}

@end
