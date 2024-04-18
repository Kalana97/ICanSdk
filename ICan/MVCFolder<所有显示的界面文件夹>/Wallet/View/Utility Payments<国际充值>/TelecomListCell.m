//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 23/4/2021
 - File name:  TelecomListCell.m
 - Description:
 - Function List:
 */


#import "TelecomListCell.h"
@interface TelecomListCell()
@property (weak, nonatomic) IBOutlet UIImageView *typeImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *favoriteBtnWidth;
@end
@implementation TelecomListCell
-(void)setDialogInfo:(DialogListInfo *)dialogInfo{
    _dialogInfo=dialogInfo;
    [self.typeImageVIew setImageWithString:dialogInfo.logo placeholder:nil];
    self.titleLabel.text=dialogInfo.name;
    [self checkIsLike];
    
  
}
-(void)checkIsLike{
//    [self.favoriteBtn setTitle:@"CircleCommonListTableViewCell.favoriteBtn.Follow".icanlocalized forState:UIControlStateNormal];
//    [self.favoriteBtn setTitle:@"CircleCommonListTableViewCell.favoriteBtn.Followed".icanlocalized forState:UIControlStateSelected];
    self.favoriteBtn.selected=self.dialogInfo.isFavorite;
    if (self.dialogInfo.isFavorite) {
        CGFloat width=[NSString widthForString:@"TelecomListCell.favorited".icanlocalized withFontSize:14 height:20];
        self.favoriteBtnWidth.constant=width+30;
        [self.favoriteBtn setBackgroundColor:UIColorBg243Color];
    }else{
        CGFloat width=[NSString widthForString:@"TelecomListCell.favorite".icanlocalized withFontSize:14 height:20];
        self.favoriteBtnWidth.constant=width+30;
        [self.favoriteBtn setBackgroundColor:UIColorThemeMainColor];

    }
}
- (IBAction)favoriteAction {
    PutDialogFavoritesRequest*request=[PutDialogFavoritesRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/dialog/favorites/%@",self.dialogInfo.ID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KClickDialogFavoriteButotnNotification object:nil userInfo:nil];
        self.dialogInfo.isFavorite=!self.dialogInfo.isFavorite;
        !self.favoriteBlock?:self.favoriteBlock();
        [self checkIsLike];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.typeImageVIew layerWithCornerRadius:22.5 borderWidth:1 borderColor:UIColorBg243Color];
    [self.favoriteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [self.favoriteBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.favoriteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.favoriteBtn setTitle:@"TelecomListCell.favorite".icanlocalized forState:UIControlStateNormal];
    
    [self.favoriteBtn setTitleColor:UIColor153Color forState:UIControlStateSelected];
    [self.favoriteBtn setTitle:@"TelecomListCell.favorited".icanlocalized forState:UIControlStateSelected];
    //    "TelecomListCell.favorite"="收藏";
    //    "TelecomListCell.favorited"="已收藏";
}


@end
