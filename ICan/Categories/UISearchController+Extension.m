//
//  UISearchController+Extension.m
//  SearchControllerTestDemo
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 DW. All rights reserved.
//

#import "UISearchController+Extension.h"
#define KButtonAbleColor RGBColor(62, 174, 41)

@implementation UISearchController (Extension)

+ (UISearchController *)searchControllerWithResultVC:(UIViewController *)resultVC target:(id)target placeHolder:(NSString *)placeHolder {
    
    UISearchController *searchController = [[UISearchController alloc]initWithSearchResultsController:resultVC];
    searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
    
    //修改搜索框cancelbutton的颜色
//    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:KButtonAbleColor,NSForegroundColorAttributeName,nil] forState: UIControlStateNormal];
//    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:NSLocalizedString(@"Cancel", nil)];
    
    
    [searchController.searchBar sizeToFit];
    searchController.searchBar.placeholder = placeHolder;
    searchController.delegate = target;
    searchController.searchResultsUpdater = target;
//     设置遮盖
    searchController.dimsBackgroundDuringPresentation = true;
    
    return searchController;
}


@end
