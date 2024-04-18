//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 2/4/2020
 - File name:  ChatRedPacketTipsTableViewCell.m
 - Description:
 - Function List:
 */


#import "ChatRedPacketTipsTableViewCell.h"
@interface ChatRedPacketTipsTableViewCell()
@property(nonatomic, strong) ChatModel *chatModel;
@property (weak, nonatomic) IBOutlet UILabel *twoTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *jiangeView;

@end
@implementation ChatRedPacketTipsTableViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.lineView.hidden = YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.titleLabel addGestureRecognizer:tap];
    self.titleLabel.userInteractionEnabled = YES;
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.twoTimeLabel.textColor = UIColorThemeMainSubTitleColor;
    self.titleLabel.textColor = UIColorThemeMainSubTitleColor;
    self.jiangeView.backgroundColor = [UIColor clearColor];
}
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowSegmentationTime:(BOOL)isShowSegmentationTime{
    _chatModel=currentChatModel;
    self.twoTimeLabel.hidden = self.jiangeView.hidden = !isShowSegmentationTime;
    self.twoTimeLabel.text = [GetTime timeStringWithTimeInterval:currentChatModel.messageTime];
    self.titleLabel.text = currentChatModel.showMessage;
    if (currentChatModel.showMessage) {
        if ([currentChatModel.messageType isEqualToString:Notice_JoinGroupApplyType]) {
            //去确认需要变颜色
            if (currentChatModel.isShowOpenRedView) {
                //                @"ToConfirm".icanlocalized
                NSMutableAttributedString*attstr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",currentChatModel.showMessage]];
                [attstr addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(attstr.length-@"ToConfirm".icanlocalized.length, @"ToConfirm".icanlocalized.length)];
                self.titleLabel.attributedText=attstr;
            }else{
                NSMutableAttributedString*attstr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",currentChatModel.showMessage]];
                [attstr addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(attstr.length-@"HasConfirm".icanlocalized.length, @"HasConfirm".icanlocalized.length)];
                self.titleLabel.attributedText=attstr;
            }
        }else{
            NSMutableAttributedString*attstr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",currentChatModel.showMessage]];
            [attstr addAttribute:NSForegroundColorAttributeName value:UIColorMake(250, 156, 63) range:NSMakeRange(attstr.length-@"showReceiveRedPacketTip".icanlocalized.length, @"showReceiveRedPacketTip".icanlocalized.length)];
            //NSTextAttachment可以将要插入的图片作为特殊字符处理
            NSTextAttachment*attch1 = [[NSTextAttachment alloc]init];
            //定义图片内容及位置和大小qmui_imageWithClippedCornerRadius
            attch1.image=[UIImage imageNamed:@"icon_red_tipcell_grabred"];
            attch1.bounds=CGRectMake(0, -2,15*44/53,15);
            //创建带有图片的富文本
            NSAttributedString*string1 = [NSAttributedString attributedStringWithAttachment:attch1];
            //将图片放在第一位
            [attstr insertAttributedString:string1 atIndex:0];
            self.titleLabel.attributedText=attstr;
        }
        
    }
    
}
-(void)tapAction{
    if (self.tapBlock) {
        self.tapBlock(self.chatModel);
    }
}
@end
