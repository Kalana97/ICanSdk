//
//  DecimalKeyboard.m
//  ICan
//
//  Created by Kalana Rathnayaka on 08/12/2023.
//  Copyright © 2023 dzl. All rights reserved.

#import "DecimalKeyboard.h"

@implementation DecimalKeyboard {
    UITextField *_targetTextField;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect defaultFrame = CGRectMake(0, 0, ScreenWidth, (ScreenHeight/3));
    self = [super initWithFrame:defaultFrame inputViewStyle:UIInputViewStyleKeyboard];
    if (self) {
        [self setupKeyboard];
    }
    return self;
}

- (void)setupKeyboard {
    CGFloat topMargin = 5.0;
    CGFloat leftMargin = 5.0;
    CGFloat spacing = 5.0;
    CGFloat buttonWidth = (self.bounds.size.width - 3 * spacing - leftMargin) / 3;
    CGFloat buttonHeight = (self.bounds.size.height - 4 * spacing - topMargin) / 4;

    NSArray *buttonTitles = @[@"1", @"2\nABC", @"3\nDEF",
                                  @"4\nGHI", @"5\nJKL", @"6\nMNO",
                                  @"7\nPQRS", @"8\nTUV", @"9\nWXYZ",
                                  @".", @"0", @"⌫"];

    for (NSInteger i = 0; i < buttonTitles.count; i++) {
        NSInteger row = i / 3;
        NSInteger col = i % 3;

        CGFloat x = leftMargin + col * (buttonWidth + spacing);
        CGFloat y = topMargin + row * (buttonHeight + spacing);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
        button.titleLabel.numberOfLines = 0; // Allow multiple lines
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
        // Create an attributed string with the original string
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:buttonTitles[i]];
        // Set the font for the first character in the attributed string
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28.0] range:NSMakeRange(0, 1)];
        [button setAttributedTitle:attributedString forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        
        if ((i == buttonTitles.count - 3) || (i == buttonTitles.count - 1) ) {
            [button setBackgroundColor:[UIColor clearColor]];
        }else {
            [button setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]]; // Light gray background
        }
        // Add additional styling to match the iOS decimal keyboard
        button.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor]; // Light gray border
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 8.0;
        button.clipsToBounds = YES;

        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:button];
    }
}

- (void)setTargetTextField:(UITextField *)textField {
    _targetTextField = textField;
}

- (void)buttonPressed:(UIButton *)sender {
    NSAttributedString *attributedTitle = [sender attributedTitleForState:UIControlStateNormal];
    NSString *buttonTitle = [[attributedTitle string] substringToIndex:1];
    
    if (_targetTextField) {
        NSString *currentText = _targetTextField.text;
        
        if ([buttonTitle isEqualToString:@"⌫"]) {
            // Backspace button pressed
            if (currentText.length > 0) {
                currentText = [currentText substringToIndex:currentText.length - 1];
            }
        } else if ([buttonTitle isEqualToString:@"."]) {
            // Decimal point button pressed
            if (![currentText containsString:@"."]) {
                currentText = [currentText stringByAppendingString:buttonTitle];
            }
        } else {
            // Digit button pressed
            currentText = [currentText stringByAppendingString:buttonTitle];
        }
        
        // Update the text field with the modified text
        _targetTextField.text = currentText;
        [_targetTextField sendActionsForControlEvents:UIControlEventEditingChanged];
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:_targetTextField];
    }
}
@end
