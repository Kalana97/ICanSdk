//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 26/9/2021
- File name:  SelectMobileCodeSectionHeader.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectMobileCodeSectionHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIScrollView *scollview;
@property (nonatomic, copy) void (^searchDidChangeBlock)(NSString*search);
@end

NS_ASSUME_NONNULL_END
