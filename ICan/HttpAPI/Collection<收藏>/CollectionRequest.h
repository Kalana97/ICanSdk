//
//  CollectionRequest.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/26.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN
@interface PoiInfo : NSObject

@property(nonatomic,copy)NSString * longitude;

@property(nonatomic,copy)NSString * latitude;

@property(nonatomic,copy)NSString * address;

@property(nonatomic,copy)NSString * name;

@end
/**
 收藏多个
 /favorites/batch
 */
@interface CollectionMoreRequest:BaseRequest

@end

@interface CollectionRequest : BaseRequest
//类型
@property(nonatomic,copy)NSString * favoriteType;
//业务id(朋友圈id)
@property(nonatomic,copy,nullable)NSString * busId;
//视频地址
@property(nonatomic,copy,nullable)NSString * videoUrl;
//语音地址
@property(nonatomic,copy,nullable)NSString * voiceUrl;
//文件地址
@property(nonatomic,copy,nullable)NSString * fileUrl;
//名片（用户id）
@property(nonatomic,copy,nullable)NSString * userCardId;
//文字
@property(nonatomic,copy,nullable)NSString * content;
//图片
@property(nonatomic,copy,nullable)NSString * imageUrl;
//来源的群id
@property(nonatomic,copy,nullable)NSString * originGroupId;
//来源的用户id
@property(nonatomic,copy,nullable)NSString * originUserId;

@property(nonatomic,copy,nullable)NSString * messageId;
@property(nonatomic,strong,nullable)PoiInfo * poi;
@end



@interface CollectionListRequest : ListRequest

@end

@interface DeleteCollectionRequest : BaseRequest

@end

NS_ASSUME_NONNULL_END
