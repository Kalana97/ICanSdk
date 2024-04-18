//
//  TranslatorViewMenue.h
//  ICan
//
//  Created by Sathsara on 2023-02-28.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TranslatorViewMenueDelegate <NSObject>
- (void)clickChangeLanguage;
- (NSString*)clickUseConvertedTextLanguage;
@end

@interface TranslatorViewMenue : UIView

@property(nonatomic, strong) UILabel *translatedTextLabel;
@property(nonatomic, strong) UILabel *languageNameLabel;
@property(nonatomic, weak) id <TranslatorViewMenueDelegate>delegate;
-(void) showTranslateView;
-(void) hideTranslateView;

@end

NS_ASSUME_NONNULL_END
