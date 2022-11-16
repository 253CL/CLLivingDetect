//
//  CLLivingResult.h
//  CLLivingDetectionSDK
//
//  Created by chuangLan on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CLLivingDetectResponse;

@interface CLLivingResult : NSObject

/**
 SDK返回外层码
 10000 ：刷脸成功
 10001：校验失败
 10002：验签失败
 10003：网络异常
 10004：本地异常
 */
@property (nonatomic, assign, readonly)NSInteger code;
/// SDK返回响应描述
@property (nonatomic, strong, readonly)NSString * message;
/// SDK内层码
@property (nonatomic, assign )NSInteger  innerCode;
/// SDK内层描述，可查看具体原因
@property (nonatomic, strong )NSString * innerMessage;
/// SDK报错，返回错误信息
@property (nonatomic, strong, readonly)NSError * error;
@property (nonatomic, strong)id ext;
/// SDK 活体检测后返回详细信息
@property (nonatomic, strong)CLLivingDetectResponse * response;

- (instancetype)initWithCode:(NSInteger)code
                     message:(NSString *)message
                         ext:(nullable id)ext
                       error:(nullable NSError *)error;
+ (instancetype)initWithResponse:(CLLivingDetectResponse *)response;
-(void)fillPropertyInfo;
@end


@interface CLLivingDetectResponse : NSObject

/// 如果采用视频返回，这个字段返回视频的路径,否则为空
@property(nonatomic, strong, nullable) NSString *videoFilePath;
/// 如果设置支持照片返回，则返回照片，否则为空
@property(nonatomic, strong, nullable) NSData   *imageContent;
/// 验证id，可用户服务器查询标识
@property(nonatomic, strong, nullable) NSString * certifyId;
/// 设备信息
@property(nonatomic, strong, nullable) NSString * deviceToken;

+ (instancetype)initWithData:(id)data image:(BOOL)image;

@end

NS_ASSUME_NONNULL_END
