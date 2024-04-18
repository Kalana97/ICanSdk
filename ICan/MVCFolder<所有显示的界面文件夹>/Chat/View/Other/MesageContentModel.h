//
//  MesageContentModel.h
//  ICan
//
//  Created by Sathsara on 2022-10-04.
//  Copyright © 2022 dzl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MesageContentModel : NSObject

@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSString *time;

@end

NS_ASSUME_NONNULL_END
