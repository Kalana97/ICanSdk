
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 29/6/2021
- File name:  ShowUtilityFavoritesView.m
- Description:
- Function List:
*/
        

#import "ShowUtilityFavoritesView.h"

@interface ShowUtilityFavoritesView ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *addtopTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileTipsLabel;

@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *notBtn;
@property (weak, nonatomic) IBOutlet UIStackView *bgView;
@end

@implementation ShowUtilityFavoritesView
-(void)awakeFromNib{
    [super awakeFromNib];
    [IQKeyboardManager sharedManager].enable=YES;
//    "ShowUtilityFavoritesView.addtopTipsLabel"="添加到收藏夹";
//    "ShowUtilityFavoritesView.addTipsLabel"="将充值信息保存为模板";
//    "ShowUtilityFavoritesView.mobileTipsLabel"="名字";
//    "ShowUtilityFavoritesView.nameTextFieldpla"="编辑的名字";
//    "ShowUtilityFavoritesView.favoriteBtn"="添加到收藏夹";
//    "ShowUtilityFavoritesView.notBtn"="取消";
    self.addtopTipsLabel.text=@"ShowUtilityFavoritesView.addtopTipsLabel".icanlocalized;
    self.addTipsLabel.text=@"ShowUtilityFavoritesView.addTipsLabel".icanlocalized;
    self.mobileTipsLabel.text=@"ShowUtilityFavoritesView.mobileTipsLabel".icanlocalized;
    [self.favoriteBtn setTitle:@"ShowUtilityFavoritesView.favoriteBtn".icanlocalized forState:UIControlStateNormal];
    [self.notBtn setTitle:@"ShowUtilityFavoritesView.notBtn".icanlocalized forState:UIControlStateNormal];
    self.nameTextField.placeholder=@"ShowUtilityFavoritesView.nameTextFieldpla".icanlocalized;
    [self.bgView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    [self.typeImgView layerWithCornerRadius:40 borderWidth:1 borderColor:UIColorBg243Color];
    [self.favoriteBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
    //添加键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
- (IBAction)favoriteAction {
    if (self.sureBlock) {
        self.sureBlock();
    }
//    [self removeFromSuperview];
}
- (IBAction)notAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self hiddenFavoritesView];
}
#pragma mark - Setter
-(void)setInfo:(DialogListInfo *)info{
    _info=info;
    [self.typeImgView setImageWithString:info.logo placeholder:nil];
}
#pragma mark - Public
-(void)showFavoritesView{
    [kKeyWindow addSubview:self];
}
-(void)hiddenFavoritesView{
    [self removeFromSuperview];
}
#pragma mark - Private
- (void)kbWillShow:(NSNotification *)noti {
    //显示的时候改变bottomContraint
    
    // 获取键盘高度
//    CGFloat kbHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    self.bgView.centerY = (self.height - self.containBgView.height) / 2 > kbHeight ? self.centerY : self.height - kbHeight - self.containBgView.height / 2;
}

- (void)kbWillHide:(NSNotification *)noti {
//    self.bgView.centerY = self.centerY;
}

#pragma mark - Lazy
#pragma mark - Event

@end
