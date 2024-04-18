
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 8/9/2021
- File name:  MemberCenterNumberIdCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "MemberCenterNumberIdCollectionViewCell.h"

@interface MemberCenterNumberIdCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *numberIdLab;

@end

@implementation MemberCenterNumberIdCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bgView layerWithCornerRadius:5 borderWidth:1 borderColor:UIColorMake(201, 142, 36)
     ];
}
-(void)setIdInfo:(MemberCentreNumberIdSellInfo *)idInfo{
    self.numberIdLab.text = idInfo.numberId.stringValue;
    
    self.moneyLab.text = [NSString stringWithFormat:@"￥%@",idInfo.price.stringValue];
}
#pragma mark - Setter
#pragma mark - Public
#pragma mark - Private
#pragma mark - Lazy
#pragma mark - Event

@end
