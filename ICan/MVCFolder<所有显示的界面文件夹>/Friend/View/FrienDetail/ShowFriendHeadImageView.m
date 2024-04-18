//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - AUthor: Created  by DZL on 2020/2/6
 - ICan
 - File name:  ShowFriendHeadImageView.m
 - Description:
 - Function List:
 */


#import "ShowFriendHeadImageView.h"
#import "HJCActionSheet.h"
#import "PrivacyPermissionsTool.h"
#import "SaveViewManager.h"
@interface ShowFriendHeadImageView()<HJCActionSheetDelegate>
@property (nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@end

@implementation ShowFriendHeadImageView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}


-(void)initUI{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(ScreenWidth));
    }];
    
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressSave:)];
    longPress.minimumPressDuration = 0.5;
    [self.iconImageView addGestureRecognizer:longPress];
    
    
}


-(void)tapAction{
    [self removeFromSuperview];
}
-(void)showView{
    UIWindow*window=[UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
}

-(void)longPressSave:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.hjcActionSheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:NSLocalizedString(@"Cancel", nil) OtherTitles:@"Save Image".icanlocalized, nil];
        self.hjcActionSheet.tag = 101;
        [self.hjcActionSheet setBtnTag:1 TextColor:UIColor102Color textFont:14.0f enable:YES];
        [self.hjcActionSheet show];
    }
    
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
            
            [SaveViewManager captureImageFromView:self.iconImageView success:^{
                
                [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Save Sucess",保存成功) inView:nil];
            } failed:^{
                
                [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"SaveFailed",保存失败) inView:nil];
            }];
            
        } failure:^{
            
        }];
        
    }
}


-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc]init];
        _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
        _iconImageView.userInteractionEnabled = YES;
        
    }
    return _iconImageView;
}

@end
