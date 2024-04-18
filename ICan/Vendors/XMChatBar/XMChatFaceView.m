//
//  XMChatFaceView.m
//  XMChatBarExample
//
//  Created by shscce on 15/8/21.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "XMChatFaceView.h"
#import "XMFaceManager.h"
#import "SwipeView.h"
#import "XMNFacePageView.h"


@interface XMChatFaceView ()<UIScrollViewDelegate,SwipeViewDelegate,SwipeViewDataSource,XMNFacePageViewDelegate>

@property (nonatomic, strong) SwipeView *swipeView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) UIView *bottomView;
/**< 显示最近表情的button */
@property (weak, nonatomic) UIButton *recentButton ;
/**< 显示emoji表情Button */
@property (weak, nonatomic) UIButton *emojiButton ;
/**< 每行显示的表情数量,6,6plus可能相应多显示  默认emoji5s显示7个 最近表情显示4个  gif表情显示4个 */
@property (assign, nonatomic) NSUInteger columnPerRow;
/**< 每页显示的行数 默认emoji3行  最近表情2行  gif表情2行 */
@property (assign, nonatomic) NSUInteger maxRows;
@property (nonatomic, assign ,readonly) NSUInteger itemsPerPage;
@property (nonatomic, assign) NSUInteger pageCount;

@property (nonatomic, strong) NSMutableArray *faceArray;

@end

@implementation XMChatFaceView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - SwipeViewDelegate & SwipeViewDataSource

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    XMNFacePageView *facePageView = (XMNFacePageView *)view;
    if (!view) {
        facePageView = [[XMNFacePageView alloc] initWithFrame:swipeView.frame];
    }
    [facePageView setColumnsPerRow:self.columnPerRow];
    if ((index + 1) * self.itemsPerPage  >= self.faceArray.count) {
        [facePageView setDatas:[self.faceArray subarrayWithRange:NSMakeRange(index * self.itemsPerPage, self.faceArray.count - index * self.itemsPerPage)]];
    }else {
        [facePageView setDatas:[self.faceArray subarrayWithRange:NSMakeRange(index * self.itemsPerPage, self.itemsPerPage)]];
    }
    facePageView.delegate = self;
    return facePageView;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return self.pageCount ;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView {
    self.pageControl.currentPage = swipeView.currentPage;
}

#pragma mark - XMNFacePageViewDelegate
- (void)selectedFaceImageWithFaceID:(NSUInteger)faceID {
    NSString *faceName = [XMFaceManager faceNameWithFaceID:faceID];
    if (faceID != 999) {
        [XMFaceManager saveRecentFace:@{@"face_id":[NSString stringWithFormat:@"%ld",faceID],@"face_name":faceName}];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceViewSendFace:)]) {
        [self.delegate faceViewSendFace:faceName];
    }
}

#pragma mark - Private Methods

- (void)setup{
    
    [self addSubview:self.swipeView];
    [self addSubview:self.pageControl];
    [self addSubview:self.bottomView];
    
    self.faceArray = [NSMutableArray array];
    self.faceViewType = XMShowEmojiFace;
    [self setupFaceView];
    
    self.userInteractionEnabled = YES;
}

- (void)setupFaceView{
    [self.faceArray removeAllObjects];
    if (self.faceViewType == XMShowEmojiFace) {
        [self setupEmojiFaces];
    }else if (self.faceViewType == XMShowRecentFace){
        [self setupRecentFaces];
    }
    [self.swipeView reloadData];
    
}

/**
 *  初始化最近使用的表情数组
 */
- (void)setupRecentFaces{
    
    self.maxRows = 3;
    self.columnPerRow = [UIScreen mainScreen].bounds.size.width > 320 ? 8 : 7;
    
    //计算每一页最多显示多少个表情  - 1(删除按钮)
    NSInteger pageItemCount = self.itemsPerPage - 1;
    [self.faceArray addObjectsFromArray:[XMFaceManager recentFaces]];
    //获取所有的face表情dict包含face_id,face_name两个key-value
    NSMutableArray *allFaces = [NSMutableArray arrayWithArray:[XMFaceManager recentFaces]];
    //计算页数
    self.pageCount = [allFaces count] % pageItemCount == 0 ? [allFaces count] / pageItemCount : ([allFaces count] / pageItemCount) + 1;
    
    //配置pageControl的页数
    self.pageControl.numberOfPages = self.pageCount;
    
    //循环,给每一页末尾加上一个delete图片,如果是最后一页直接在最后一个加上delete图片
    for (int i = 0; i < self.pageCount; i++) {
        if (self.pageCount - 1 == i) {
            [self.faceArray addObject:@{@"face_id":@"999",@"face_name":@"删除"}];
        }else{
            [self.faceArray insertObject:@{@"face_id":@"999",@"face_name":@"删除"} atIndex:(i + 1) * pageItemCount + i];
        }
    }
    
}

/**
 *  初始化所有的emoji表情数组,添加删除按钮
 */
- (void)setupEmojiFaces{
    self.maxRows = 3;
    self.columnPerRow = [UIScreen mainScreen].bounds.size.width > 320 ? 8 : 7;
    //计算每一页最多显示多少个表情  - 1(删除按钮)
    NSInteger pageItemCount = self.itemsPerPage - 1;
    [self.faceArray addObjectsFromArray:[XMFaceManager emojiFaces]];
    //获取所有的face表情dict包含face_id,face_name两个key-value
    NSMutableArray *allFaces = [NSMutableArray arrayWithArray:[XMFaceManager emojiFaces]];
    
    //计算页数
    self.pageCount = [allFaces count] % pageItemCount == 0 ? [allFaces count] / pageItemCount : ([allFaces count] / pageItemCount) + 1;
    
    //配置pageControl的页数
    self.pageControl.numberOfPages = self.pageCount;
    
    //循环,给每一页末尾加上一个delete图片,如果是最后一页直接在最后一个加上delete图片
    for (int i = 0; i < self.pageCount; i++) {
        if (self.pageCount - 1 == i) {
            [self.faceArray addObject:@{@"face_id":@"999",@"face_name":@"删除"}];
        }else{
            [self.faceArray insertObject:@{@"face_id":@"999",@"face_name":@"删除"} atIndex:(i + 1) * pageItemCount + i];
        }
    }

}

- (void)sendAction:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceViewSendFace:)]) {
        [self.delegate faceViewSendFace:@"发送"];
    }
}

- (void)changeFaceType:(UIButton *)button{
    self.faceViewType = button.tag;
    [self setupFaceView];
}

#pragma mark - Setters

- (void)setFaceViewType:(XMShowFaceViewType)faceViewType {
    if (_faceViewType != faceViewType) {
        _faceViewType = faceViewType;
        self.emojiButton.selected = _faceViewType == XMShowEmojiFace;
        self.recentButton.selected = _faceViewType == XMShowRecentFace;
    }
}

#pragma mark - Getters

- (SwipeView *)swipeView {
    if (!_swipeView) {
        _swipeView = [[SwipeView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 60)];
        _swipeView.delegate = self;
        _swipeView.dataSource = self;
    }
    return _swipeView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.swipeView.frame.size.height, self.frame.size.width, 20)];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 0, 60, 40)];
//        sendButton.backgroundColor = KButtonAbleColor;
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        
        [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      
        [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:sendButton.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5 , 5)];
        CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];
        fieldLayer.frame = sendButton.bounds;
        fieldLayer.path = fieldPath.CGPath;
        sendButton.layer.mask = fieldLayer;
        [_bottomView addSubview:self.sendButton = sendButton];
        UIButton *recentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recentButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_recent_normal"] forState:UIControlStateNormal];
        [recentButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_recent_highlight"] forState:UIControlStateHighlighted];
        [recentButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_recent_highlight"] forState:UIControlStateSelected];
        recentButton.tag = XMShowRecentFace;
        [recentButton addTarget:self action:@selector(changeFaceType:) forControlEvents:UIControlEventTouchUpInside];
        [recentButton sizeToFit];
        [_bottomView addSubview:self.recentButton = recentButton];
        [recentButton setFrame:CGRectMake(0, _bottomView.frame.size.height/2-recentButton.frame.size.height/2, recentButton.frame.size.width, recentButton.frame.size.height)];
        
        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_emoji_normal"] forState:UIControlStateNormal];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_emoji_highlight"] forState:UIControlStateHighlighted];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_emoji_highlight"] forState:UIControlStateSelected];
        emojiButton.tag = XMShowEmojiFace;
        emojiButton.selected = true;
        [emojiButton addTarget:self action:@selector(changeFaceType:) forControlEvents:UIControlEventTouchUpInside];
        [emojiButton sizeToFit];
        [_bottomView addSubview:self.emojiButton = emojiButton];
        [emojiButton setFrame:CGRectMake(recentButton.frame.size.width, _bottomView.frame.size.height/2-emojiButton.frame.size.height/2, emojiButton.frame.size.width, emojiButton.frame.size.height)];
        
    }
    return _bottomView;
}

/**
 *  每一页显示的表情数量 = M每行数量*N行
 */
- (NSUInteger)itemsPerPage {
    return self.maxRows * self.columnPerRow;
}

@end
    
