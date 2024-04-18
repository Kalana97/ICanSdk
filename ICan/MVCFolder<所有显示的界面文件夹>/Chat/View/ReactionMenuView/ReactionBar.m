//
//  ReactionBar.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-07-17.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "ReactionBar.h"
@interface ReactionBar()
@property(nonatomic, strong) UILabel *reactionsLabel;
@end
@implementation ReactionBar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    [self layerWithCornerRadius:14 borderWidth:1 borderColor:UIColor.whiteColor];
    [self addSubview:self.reactionsLabel];
    [self.reactionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.mas_left).offset(3).priorityLow(); // Minimum left offset of 3 points
        make.right.lessThanOrEqualTo(self.mas_right).offset(-3).priorityLow(); // Maximum right offset of -3 points
        make.centerX.equalTo(self.mas_centerX).priorityHigh(); // Center horizontally with higher priority
        make.centerY.equalTo(self.mas_centerY); // Center vertically
    }];
    [self.reactionsLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES; // Center horizontally
    [self.reactionsLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES; // Center vertically
}

- (void)setReactions:(ChatModel *)model{
    NSMutableString *keysString = [NSMutableString string];
    NSMutableDictionary *reactions = [NSMutableDictionary dictionary];
    NSMutableArray *arrayForReaction;
    int count = 0;
    if (model.reactions && [model.reactions isKindOfClass:[NSMutableDictionary class]]) {
        reactions = [model.reactions mutableCopy];
    }
    for (NSString *key in model.reactions.allKeys) {
        if (model.reactions[key] != nil) {
            [keysString appendString:key];
            [keysString appendString:@" "];
            arrayForReaction = [reactions[key] mutableCopy];
            count = count + arrayForReaction.count;
        }

    }
    [keysString appendString:[NSString stringWithFormat:@"%d", count]];
    self.reactionsLabel.text = keysString;
}

-(UILabel *)reactionsLabel {
    if (!_reactionsLabel) {
        _reactionsLabel = [[UILabel alloc] init];
        _reactionsLabel.textAlignment = NSTextAlignmentCenter;
        _reactionsLabel.font = [UIFont systemFontOfSize:13];
    }
    return _reactionsLabel;
}

@end
