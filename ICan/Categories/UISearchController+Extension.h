//
//  UISearchController+Extension.h
//  SearchControllerTestDemo
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 DW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISearchController (Extension)


+ (UISearchController *)searchControllerWithResultVC:(UIViewController *)resultVC target:(id)target placeHolder:(NSString *)placeHolder;

@end
