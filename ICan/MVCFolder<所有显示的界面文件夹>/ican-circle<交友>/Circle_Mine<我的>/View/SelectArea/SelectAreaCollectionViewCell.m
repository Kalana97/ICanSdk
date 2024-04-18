//
/**
- Copyright © 2021 limao01. All rights reserved.
- Author: Created  by DZL on 11/1/2021
- File name:  SelectAreaCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "SelectAreaCollectionViewCell.h"
@interface SelectAreaCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
@implementation SelectAreaCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lineView layerWithCornerRadius:2.5 borderWidth:0 borderColor:nil];
}

-(void)setCurrentAreaitems:(NSArray *)currentAreaitems{
    _currentAreaitems=currentAreaitems;
    AreaInfo*selectInfo;
    NSString*title;
    //判断当前列表数组是否有选中的的地区 如果有  那么title就显示areaName
    
    NSPredicate * gpredicate = [NSPredicate predicateWithFormat:@"select = %d ",YES];
    NSArray<AreaInfo*>*selectImtes=[currentAreaitems filteredArrayUsingPredicate:gpredicate];
    if (selectImtes.count>0) {
        selectInfo=selectImtes.firstObject;
        if (BaseSettingManager.isChinaLanguages) {
            title = selectInfo.areaName;
        }else{
            if (selectInfo.areaNameEn) {
                title = selectInfo.areaNameEn;
            }else{
                title = selectInfo.areaName;
            }
        }
        self.titleLabel.text=title;
    }else{
        title=@"ShowSelectAddressView.pleasSelect".icanlocalized;
        self.titleLabel.text=title;
    }
}
@end
