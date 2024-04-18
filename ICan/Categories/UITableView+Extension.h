//
//  UITableView+Extension.h
//  GongShuQu
//
//  Created by SevenCat on 16/5/13.
//  Copyright © 2016年 拱墅区. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extension)

/**
 *  注册 Nib cell
 */
- (void)registNibWithNibName:(NSString *)nibName;

#pragma mark -- 注册 classcell --
- (void)registClassWithClassName:(NSString *)className;


/**
 *  -- 设置tableView的属性 --
 */
- (void)setTableViewSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;

/**
 *  -- 设置下拉刷新和上拉加载 --
 */
- (void)setMJRefreshWithTarget:(id)target refreshAction:(SEL)refreshAction loadMoreAction:(SEL)loadMoreAction;
/**
 *  下拉刷新
 */
- (void)setMJRefreshWithTarget:(id)target refreshAction:(SEL)refreshAction;

- (void)setMJRefreshWithTarget:(id)target loadMoreAction:(SEL)loadMoreAction;
/**
 *  结束刷新
 *  @param page 当前页
 */
- (void)endRefreshWithPage:(NSInteger)page;

/**
 *  结束刷新
 *
 *  @param page        当前页
 *  @param headerBlock 下拉刷新
 *  @param footerBlock 上拉加载
 */
- (void)endRefreshWithPage:(NSInteger)page headerBlock:(void(^)(void))headerBlock footerBlock:(void(^)(void))footerBlock;

/**
 *  获取tableView的cell
 *
 *  @param num     cell的数量
 *  @param section 所在的section
 *
 *  @return cell数组
 */
- (NSArray *)getTableViewAllCellWithNumOfRows:(NSInteger)num section:(NSInteger)section;
// 滑动到顶部
-(void)scrollToTopWithAnimated:(BOOL)animated;



-(void)scrollToBottomWithContentOffsetAnimation:(BOOL)animation;
-(void)endHeaderRefreshing;
@end

