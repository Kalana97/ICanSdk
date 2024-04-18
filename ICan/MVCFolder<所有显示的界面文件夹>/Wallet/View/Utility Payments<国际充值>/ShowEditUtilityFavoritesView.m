
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 29/6/2021
- File name:  ShowEditUtilityFavoritesView.m
- Description:
- Function List:
*/
        

#import "ShowEditUtilityFavoritesView.h"

@interface ShowEditUtilityFavoritesView ()
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameTipsLabel;

@property (weak, nonatomic) IBOutlet UILabel *mobileTipsLabel;

@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *notBtn;
@property (weak, nonatomic) IBOutlet UIStackView *bgView;
@end

@implementation ShowEditUtilityFavoritesView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.bgView layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
    [self.typeImgView layerWithCornerRadius:40 borderWidth:1 borderColor:UIColorBg243Color];
    [self.favoriteBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
    //    "ShowUtilityFavoritesView.addtopTipsLabel"="添加到收藏夹";
    //    "ShowUtilityFavoritesView.addTipsLabel"="将充值信息保存为模板";
    //    "ShowUtilityFavoritesView.mobileTipsLabel"="名字";
    //    "ShowUtilityFavoritesView.nameTextFieldpla"="编辑的名字";
    //    "ShowUtilityFavoritesView.favoriteBtn"="添加到收藏夹";
    //    "ShowUtilityFavoritesView.notBtn"="取消";
      
        self.nameTipsLabel.text=@"ShowUtilityFavoritesView.mobileTipsLabel".icanlocalized;
    self.mobileTipsLabel.text=@"ShowEditUtilityFavoritesView.mobileTipsLabel".icanlocalized;
    self.mobileTextField.placeholder=@"ShowEditUtilityFavoritesView.mobileTextField".icanlocalized;
        [self.favoriteBtn setTitle:@"ShowEditUtilityFavoritesView.favoriteBtn".icanlocalized forState:UIControlStateNormal];
        [self.notBtn setTitle:@"ShowUtilityFavoritesView.notBtn".icanlocalized forState:UIControlStateNormal];
        self.nameTextField.placeholder=@"ShowUtilityFavoritesView.nameTextFieldpla".icanlocalized;
//    //添加键盘通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
- (IBAction)favoriteAction {
    if (self.sureBlock) {
        self.sureBlock();
    }
}
- (IBAction)notAction:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self hiddenEditUtilityFavoritesView];
}
#pragma mark - Setter
-(void)setInfo:(DialogListInfo *)info{
    _info=info;
    self.nameTextField.text=info.nickname;
    self.mobileTextField.text=info.accountNumber;
    [self.typeImgView setImageWithString:info.logo placeholder:nil];
}
#pragma mark - Public
-(void)showEditUtilityFavoritesView{
    [kKeyWindow addSubview:self];
}
-(void)hiddenEditUtilityFavoritesView{
    [self removeFromSuperview];
}

@end
