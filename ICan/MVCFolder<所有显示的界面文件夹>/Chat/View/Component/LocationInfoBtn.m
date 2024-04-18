
#import "LocationInfoBtn.h"
#import "ShowAppleMapLocationViewController.h"
#import "ChatModel.h"

@interface LocationInfoBtn ()

@property (strong, nonatomic) UIImageView *mapImgView;
@property (strong, nonatomic) UIButton *redPinBtn;
@property(nonatomic,strong) UILabel *timeLabelDown;

@end

@implementation LocationInfoBtn

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initUI];
    self.backgroundColor=UIColorBg243Color;
    [self layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self addTarget:self action:@selector(toLocationViewController) forControlEvents:UIControlEventTouchUpInside];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=UIColorBg243Color;
        [self layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        [self initUI];
        [self addTarget:self action:@selector(toLocationViewController) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setChatModel:(ChatModel *)chatModel{
    _chatModel=chatModel;
    LocationMessageInfo*info=[LocationMessageInfo mj_objectWithKeyValues:chatModel.messageContent];
    [self.mapImgView setImageWithString:info.mapUrl placeholder:nil];
    NSDate*date=[GetTime dateConvertFromTimeStamp:self.chatModel.messageTime];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self addSubview:self.timeLabelDown];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@120);
        make.right.equalTo(@-6);
    }];
}

- (void)toLocationViewController {
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    LocationMessageInfo *info = [LocationMessageInfo mj_objectWithKeyValues:self.chatModel.messageContent];
    ShowAppleMapLocationViewController *locatinVC = [ShowAppleMapLocationViewController new];
    locatinVC.locationMessageInfo = info;
    [[AppDelegate shared] pushViewController:locatinVC animated:true];
}

- (void)initUI
{
    [self insertSubview:self.mapImgView atIndex:0];
    [self.mapImgView addSubview:self.redPinBtn];
    [self.mapImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(@0);
        
    }];
    [self.redPinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mapImgView.mas_centerX);
        make.centerY.equalTo(self.mapImgView.mas_centerY);
        make.height.equalTo(@(self.redPinBtn.currentImage.size.height));
        make.width.equalTo(@(self.redPinBtn.currentImage.size.width));
    }];
}

- (UIImageView *)mapImgView
{
    if (!_mapImgView) {
        _mapImgView=[UIImageView new];
        [_mapImgView setBackgroundColor:[UIColor clearColor]];
        _mapImgView.clipsToBounds = YES;
        _mapImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _mapImgView;
}

- (UIButton *)redPinBtn
{
    if (!_redPinBtn) {
        _redPinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *redPinImg = [UIImage imageNamed:@"location_red_icon_center"];
        [_redPinBtn setImage:redPinImg forState:UIControlStateNormal];
        [_redPinBtn setImage:redPinImg forState:UIControlStateHighlighted];
        _redPinBtn.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
    }
    return _redPinBtn;
}
-(UILabel *)timeLabelDown{
    if (!_timeLabelDown) {
        _timeLabelDown = [UILabel leftLabelWithTitle:nil font:10 color:UIColor.darkGrayColor];
    }
    return _timeLabelDown;
}
@end
