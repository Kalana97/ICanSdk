//
//  CustomScreenSplash.m
//  ICan
//
//  Created by Sathsara on 2022-12-06.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "CustomScreenSplash.h"
#import "FLAnimatedImage.h"


@interface CustomScreenSplash ()
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UILabel *icanName;
@property (weak, nonatomic) IBOutlet UIImageView *appLogo;
@property (weak, nonatomic) IBOutlet UIStackView *logoStack;
@end

@implementation CustomScreenSplash

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.logoStack.hidden = self.icanName.hidden = self.appLogo.hidden = YES;
        [self.gifView setImageWithString:@"LogoCN" placeholder:@"LogoCN"];
        [self.view setBackgroundColor:UIColorMake(1, 123, 253)];
    }
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        self.icanName.text = @"iCan";
        self.appLogo.image = [UIImage imageNamed:@"applogo"];
        self.appLogo.layer.cornerRadius = 5;
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ICan" withExtension:@"gif"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        imageView.animatedImage = image;
        imageView.frame = CGRectMake(0.0, 0.0, 300.0, 300.0);
        [self.gifView addSubview:imageView];
    }
}
@end
