//
//  TimelinesDynamicMessageDataViewCell.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-09-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "TimelinesDynamicMessageDataViewCell.h"

@implementation TimelinesDynamicMessageDataViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.dataListImg layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.dataListImg.contentMode = UIViewContentModeScaleAspectFill;
    self.cellViewContainer.layer.masksToBounds = NO;
    self.cellViewContainer.layer.shadowColor = UIColor.lightGrayColor.CGColor;
    self.cellViewContainer.layer.shadowOpacity = 0.1;
    self.cellViewContainer.layer.shadowOffset = CGSizeMake(0, 4.26);
    self.cellViewContainer.layer.shadowRadius = 5;
    self.cellcontentStack.layer.cornerRadius = 5;
    self.cellcontentStack.layer.masksToBounds = NO;
}

-(void)setDataList:(DynamicMessageDataList *)dataList{
    _dataList = dataList;
    self.dataListTitle.text = dataList.title;
    [self.dataListImg sd_setImageWithURL:[[NSURL alloc]initWithString:dataList.imageURL] placeholderImage:UIImageMake(@"thumbnail_default_placeholder")];
    self.dataListSubTitle.text = @"More";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
