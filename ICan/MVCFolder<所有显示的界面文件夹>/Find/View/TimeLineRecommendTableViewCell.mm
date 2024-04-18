//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 21/4/2020
 - File name:  TimeLineRecommendTableViewCell.m
 - Description:
 - Function List:
 */


#import "TimeLineRecommendTableViewCell.h"
#import "TimeLineRecommendCollectionViewCell.h"
#import "FriendDetailViewController.h"
#import "NewFriendRecommendController.h"
#import "FindNearbyPersonsViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
@interface TimeLineRecommendTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *rightButton;
@end
@implementation TimeLineRecommendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
-(void)setItems:(NSArray *)items{
    _items=items;
    id info=items.firstObject;
    if ([info isKindOfClass:[UserRecommendListInfo class]]) {
        self.titleLabel.text=[@"Suggested" icanlocalized:@"推荐的人"];
    }else{
        self.titleLabel.text=[@"find.listView.cell.peopleNearby" icanlocalized:@"附近的人"];
    }
    [self.collectionView reloadData];
}
-(void)setUpUI{
    [super setUpUI];
    self.contentView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F8F8F8"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.equalTo(@15);
        make.top.equalTo(@0);
        
    }];
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.height.equalTo(@40);
        make.top.equalTo(@0);
    }];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@40);
        make.left.right.bottom.equalTo(@0);
    }];
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel leftLabelWithTitle:@"推荐的人" font:15 color:UIColorThemeMainTitleColor];
        _titleLabel.font=[UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton dzButtonWithTitle:[@"See More" icanlocalized:@"更多" ] image:nil backgroundColor:nil titleFont:14 titleColor:UIColorThemeMainColor target:self action:@selector(moreButtonAction)];
        [_rightButton sizeToFit];
    }
    return _rightButton;
}
-(void)moreButtonAction{
    id info=self.items.firstObject;
    if ([info isKindOfClass:[UserRecommendListInfo class]]) {
        NewFriendRecommendController*vc=[[NewFriendRecommendController alloc]init];
        [[AppDelegate shared]pushViewController:vc animated:YES];
    }else{
        FindNearbyPersonsViewController*vc=[[FindNearbyPersonsViewController alloc]init];
        [[AppDelegate shared]pushViewController:vc animated:YES];
        
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
        _collectionView.backgroundColor                 = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:kTimeLineRecommendCollectionViewCell bundle:nil] forCellWithReuseIdentifier:kTimeLineRecommendCollectionViewCell];
        
    }
    return _collectionView;
}
#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(156,255);
    
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置section的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id info=[self.items objectAtIndex:indexPath.row];
    if ([info isKindOfClass:[UserRecommendListInfo class]]) {
        UserRecommendListInfo*recommendInfo=(UserRecommendListInfo*)info;
        [self pushToFriendeInfoWithUserId:recommendInfo.ID];
    }else{
        UserLocationNearbyInfo*nearInfo=(UserLocationNearbyInfo*)info;
        [self pushToFriendeInfoWithUserId:nearInfo.ID];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TimeLineRecommendCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:kTimeLineRecommendCollectionViewCell forIndexPath:indexPath];
    id info=[self.items objectAtIndex:indexPath.item];
    if ([info isKindOfClass:[UserRecommendListInfo class]]) {
        cell.recommendInfo=info;
    }else{
        cell.nearbyInfo=info;
    }
    cell.buttonBlock = ^(id  _Nonnull info, NSInteger tag) {
        if (tag==2) {//添加的是附近的人
            UserLocationNearbyInfo*nearInfo=(UserLocationNearbyInfo*)info;
            if (nearInfo.isFriend) {
                UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:nearInfo.ID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
                 [[AppDelegate shared] pushViewController:vc animated:YES];
            }else{
                [self pushToFriendeInfoWithUserId:nearInfo.ID];
               
            }
            
        }else{
            if (tag==0) {
                UserRecommendListInfo*recommendInfo=(UserRecommendListInfo*)info;
                if (recommendInfo.isFirend) {
                    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:recommendInfo.ID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
                     [[AppDelegate shared] pushViewController:vc animated:YES];
                }else{
                    [self pushToFriendeInfoWithUserId:recommendInfo.ID];
                }
                
            }else{
                NSMutableArray*array=[NSMutableArray arrayWithArray:self.items];
                [array removeObject:info];
                self.items=[array copy];
                [self.collectionView reloadData];
            }
        }
    };
    return cell;
}
-(void)pushToFriendeInfoWithUserId:(NSString*)userId{
    FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
    vc.userId=userId;
    vc.friendDetailType=FriendDetailType_push;
    [[AppDelegate shared]pushViewController:vc animated:YES];
}
@end
