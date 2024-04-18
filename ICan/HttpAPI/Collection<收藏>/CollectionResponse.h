//
//  CollectionResponse.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/26.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "BaseResponse.h"
#import "CollectionRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionResponse : BaseResponse

@end



@interface CollectionListDetailResponse : IDInfo

//谁的收藏
@property(nonatomic,copy)NSString * user;
//收藏类型
@property(nonatomic,copy)NSString * favoriteType;
//业务id(朋友圈id)
@property(nonatomic,copy,nullable)NSString * busId;
//视频地址
@property(nonatomic,copy,nullable)NSString * videoUrl;
//语音地址
@property(nonatomic,copy,nullable)NSString * voiceUrl;
//文件地址
@property(nonatomic,copy,nullable)NSString * fileUrl;
//文本内容
@property(nonatomic,copy,nullable)NSString * content;
//名片的用户id
@property(nonatomic,copy,nullable)NSString * userCardId;
//名片的numberId
@property(nonatomic,copy,nullable)NSString * userCardNumberId;
//名片的头像
@property(nonatomic,copy,nullable)NSString * userCardHeadImgUrl;

//名片的性别
@property(nonatomic,copy,nullable)NSString * gender;
//图片
@property(nonatomic,copy,nullable)NSString * imageUrl;
//时间
@property(nonatomic,assign)NSInteger createTime;
//来自的群id
@property(nonatomic,copy,nullable)NSString * originGroupId;
//来自的群名
@property(nonatomic,copy,nullable)NSString * originGroupName;
//来自的群头像
@property(nonatomic,copy,nullable)NSString * originGroupHeadImgUrl;
//来自对用户id
@property(nonatomic,copy,nullable)NSString * originUserId;
//来自的用户昵称
@property(nonatomic,copy,nullable)NSString * originNickname;
//来自的用户头像
@property(nonatomic,copy,nullable)NSString * originUserHeadImgUrl;

@property(nonatomic,strong,nullable)PoiInfo * poi;

@property(nonatomic, copy) NSMutableAttributedString *nameLabelText;
@property(nonatomic, copy) NSMutableAttributedString *contentLabelText;

@property(nonatomic,assign)CGFloat cellHeight;
@end

@interface CollectionListResponse : ListInfo

@end

NS_ASSUME_NONNULL_END
