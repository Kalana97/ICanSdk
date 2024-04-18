//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 18/9/2020
- File name:  EmojyShowView.m
- Description:
- Function List:
*/
        

#import "EmojyShowView.h"
#import "EmojyCollectionViewCell.h"
#import "CatogoryCollectionViewCell.h"
@interface EmojyShowView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UICollectionView *catogoryCollectionView;
@property(nonatomic, strong) NSArray *allEmojiArray;
@property(nonatomic, strong) NSArray *allCategoryItems;
@property(nonatomic, strong) NSMutableArray *selectIndexPath;
@property(nonatomic, strong) UIView *lineView;

@end
@implementation EmojyShowView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled=YES;
    self.backgroundColor=UIColor.clearColor;
    NSIndexPath*inde=[NSIndexPath indexPathForItem:0 inSection:0 ];
    [self.selectIndexPath addObject:inde];
    self.allCategoryItems=@[@"icon_expression_big",@"icon_expression_ball",@"icon_expression_food",@"icon_expression_animal",@"icon_expression_house_car",@"icon_expression_bulbs",@"icon_expression_Symbol",@"icon_expression_flag"];
    NSString*qizhiStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"qizhi" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString*huodongStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"huodong" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString*xiaolianStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"xiaolian" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString*lvyouStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lvyou" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString*fuhaoStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"fuhao" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString*meishiStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"meishi" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString*wupinStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"wupin" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSString*dongwuStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"dongwu" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    self.allEmojiArray=@[[xiaolianStr componentsSeparatedByString:@" "],
                         [huodongStr componentsSeparatedByString:@" "],
                         [meishiStr componentsSeparatedByString:@" "],
                         [dongwuStr componentsSeparatedByString:@" "],
                         [lvyouStr componentsSeparatedByString:@" "],
                         [wupinStr componentsSeparatedByString:@" "],
                         [fuhaoStr componentsSeparatedByString:@" "],
                         [qizhiStr componentsSeparatedByString:@" "]
                         ];
   
    [self addSubview:self.catogoryCollectionView];
    [self.catogoryCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@40);
    }];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.catogoryCollectionView.mas_bottom).offset(0);
        make.bottom.equalTo(@(-0));
    }];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(self.catogoryCollectionView.mas_bottom).offset(0.5);
    }];
    [self addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
        if (isIPhoneX) {
            make.bottom.equalTo(@-37);
        }else{
            make.bottom.equalTo(@(-10));
        }
        
    }];
    [self addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-95);
        make.height.equalTo(@40);
        make.width.equalTo(@80);
        if (isIPhoneX) {
            make.bottom.equalTo(@-37);
        }else{
            make.bottom.equalTo(@(-10));
        }
    }];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.userInteractionEnabled=YES;
        self.backgroundColor=UIColor.clearColor;
        NSIndexPath*inde=[NSIndexPath indexPathForItem:0 inSection:0 ];
        [self.selectIndexPath addObject:inde];
        self.allCategoryItems=@[@"icon_expression_big",@"icon_expression_ball",@"icon_expression_food",@"icon_expression_animal",@"icon_expression_house_car",@"icon_expression_bulbs",@"icon_expression_Symbol",@"icon_expression_flag"];
        NSString*qizhiStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"qizhi" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSString*huodongStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"huodong" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSString*xiaolianStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"xiaolian" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSString*lvyouStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lvyou" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSString*fuhaoStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"fuhao" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSString*meishiStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"meishi" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSString*wupinStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"wupin" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSString*dongwuStr=[NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"dongwu" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        self.allEmojiArray=@[[xiaolianStr componentsSeparatedByString:@" "],
                             [huodongStr componentsSeparatedByString:@" "],
                             [meishiStr componentsSeparatedByString:@" "],
                             [dongwuStr componentsSeparatedByString:@" "],
                             [lvyouStr componentsSeparatedByString:@" "],
                             [wupinStr componentsSeparatedByString:@" "],
                             [fuhaoStr componentsSeparatedByString:@" "],
                             [qizhiStr componentsSeparatedByString:@" "]
                             ];
       
        [self addSubview:self.catogoryCollectionView];
        [self.catogoryCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.height.equalTo(@40);
        }];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.top.equalTo(self.catogoryCollectionView.mas_bottom).offset(0);
            make.bottom.equalTo(@(-0));
        }];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@0.5);
            make.top.equalTo(self.catogoryCollectionView.mas_bottom).offset(0.5);
        }];
        [self addSubview:self.sendButton];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.height.equalTo(@40);
            make.width.equalTo(@80);
            if (isIPhoneX) {
                make.bottom.equalTo(@-37);
            }else{
                make.bottom.equalTo(@(-10));
            }
            
        }];
        [self addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-95);
            make.height.equalTo(@40);
            make.width.equalTo(@80);
            if (isIPhoneX) {
                make.bottom.equalTo(@-37);
            }else{
                make.bottom.equalTo(@(-10));
            }
        }];
    }
    return self;
}
-(void)setSendButtonHidden:(BOOL)hidden{
    if (hidden) {
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.height.equalTo(@0);
            make.width.equalTo(@0);
            if (isIPhoneX) {
                make.bottom.equalTo(@-37);
            }else{
                make.bottom.equalTo(@(-10));
            }
            
        }];
        [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-10);
            make.height.equalTo(@40);
            make.width.equalTo(@80);
            if (isIPhoneX) {
                make.bottom.equalTo(@-37);
            }else{
                make.bottom.equalTo(@(-10));
            }
        }];
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
        _collectionView.showsHorizontalScrollIndicator  = NO;
        _collectionView.scrollEnabled                   = YES;
        _collectionView.backgroundColor                 = UIColor.clearColor;;
        _collectionView.pagingEnabled=YES;
//        _collectionView.clipsToBounds=YES;
        
    }
    return _collectionView;
}
-(UICollectionView *)catogoryCollectionView{
    if (_catogoryCollectionView==nil) {
        UICollectionViewFlowLayout*lay=[[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _catogoryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _catogoryCollectionView.dataSource                      = self;
        _catogoryCollectionView.delegate                        = self;
        _catogoryCollectionView.showsVerticalScrollIndicator    = NO;
        _catogoryCollectionView.showsHorizontalScrollIndicator  = NO;
        _catogoryCollectionView.scrollEnabled                   = YES;
        _catogoryCollectionView.backgroundColor                 = UIColor.clearColor;
        [_catogoryCollectionView registNibWithNibName:@"CatogoryCollectionViewCell"];
        
    }
    return _catogoryCollectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView==self.collectionView) {
        return self.allEmojiArray.count;
    }
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.catogoryCollectionView) {
        CatogoryCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CatogoryCollectionViewCell" forIndexPath:indexPath];
        cell.catImageView.image=UIImageMake(self.allCategoryItems[indexPath.row]);
        if ([self.selectIndexPath containsObject:indexPath]) {
            cell.bgView.backgroundColor=UIColorMake(232, 232, 232);
            [cell.bgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        }else{
            cell.bgView.backgroundColor=UIColorViewBgColor;
            [cell.bgView layerWithCornerRadius:0 borderWidth:0 borderColor:nil];
        }
        cell.catogoryTapBlock = ^{
            if (![self.selectIndexPath containsObject:indexPath]) {
                [self.selectIndexPath removeAllObjects];
                [self.selectIndexPath addObject:indexPath];
                [self.catogoryCollectionView reloadData];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionRight) animated:YES];
            }
            
        };
        return cell;
    }
    NSString *identifier=[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    [collectionView registerNib:[UINib nibWithNibName:@"EmojyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    EmojyCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.selectEmojyBlock = ^(NSString * _Nonnull text) {
        [self changeButtonUI:YES];
        if (self.selectEmojyBlock) {
            self.selectEmojyBlock(text);
            
        }
    };
    cell.emojyItmes=self.allEmojiArray[indexPath.row];
    return cell;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UICollectionView*collect=(UICollectionView*)scrollView;
    if (collect==self.collectionView) {
        [self handleScroll];
    }
   
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO) { // scrollView已经完全静止
        UICollectionView*collect=(UICollectionView*)scrollView;
        if (collect==self.collectionView) {
            [self handleScroll];
        }
    }
}
-(void)handleScroll{
    NSArray *visiableCells = [self.collectionView visibleCells];
    EmojyCollectionViewCell*cell=(EmojyCollectionViewCell*)visiableCells.firstObject;
    NSIndexPath*index=[self.collectionView indexPathForCell:cell];
    if (![self.selectIndexPath containsObject:index]) {
        [self.selectIndexPath removeAllObjects];
        [self.selectIndexPath addObject:index];
        [self.catogoryCollectionView reloadData];
    }
    [self.catogoryCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}
#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView==self.catogoryCollectionView) {
        return CGSizeMake(40, 40);
    }
    return CGSizeMake(ScreenWidth,self.bounds.size.height-40);
   
    
    
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==self.catogoryCollectionView) {
        return 0;
    }
    return 0;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==self.catogoryCollectionView) {
        return 15;
    }
    return 0;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView==self.catogoryCollectionView) {
        return UIEdgeInsetsMake(5, 10, 5, 10);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(NSMutableArray *)selectIndexPath{
    if (!_selectIndexPath) {
        _selectIndexPath=[NSMutableArray array];
    }
    return _selectIndexPath;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=UIColorSeparatorColor;
        
    }
    return _lineView;
}
-(void)changeButtonUI:(BOOL)hasText{
    if (hasText) {///是否有图标
        [self.sendButton setBackgroundColor:UIColorThemeMainColor];
        [self.sendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self.deleteButton setBackgroundImage:UIImageMake(@"icon_expression_del_sel") forState:UIControlStateNormal];
        self.deleteButton.enabled=self.sendButton.enabled=YES;
    }else{
        [self.sendButton setBackgroundColor:UIColorBg243Color];
        [self.sendButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [self.deleteButton setBackgroundImage:UIImageMake(@"icon_expression_close_nor") forState:UIControlStateNormal];
        self.deleteButton.enabled=self.sendButton.enabled=NO;
    }
}
-(void)deleteButtonAction{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}
-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.whiteColor titleFont:0 titleColor:nil target:self action:@selector(deleteButtonAction)];
        [_deleteButton setBackgroundImage:UIImageMake(@"icon_expression_del_sel") forState:UIControlStateNormal];
        [_deleteButton setBackgroundImage:UIImageMake(@"icon_expression_close_nor") forState:UIControlStateNormal];
        [_deleteButton layerWithCornerRadius:40/2 borderWidth:0 borderColor:nil];
    }
    return _deleteButton;
}
-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton=[UIButton dzButtonWithTitle:@"Send".icanlocalized image:nil backgroundColor:UIColorThemeMainColor titleFont:17 titleColor:UIColor.whiteColor target:self action:@selector(sendButtonAction)];
        [_sendButton layerWithCornerRadius:40/2 borderWidth:0 borderColor:nil];
        [_sendButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        
    }
    return _sendButton;
}
-(void)sendButtonAction{
    if (self.sendBlock) {
        self.sendBlock();
    }
}
@end
