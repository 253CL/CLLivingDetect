//
//  CLNetWorking.h
//  CLLivingDetectionSDK
//
//  Created by chuangLan on 2022/10/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//#define CLLivingBaseURLString    @"http://172.16.43.56:7777/"  //stable
//#define CLLivingBaseURLString    @"http://api.sit.253.com/"  //sit
//#define CLLivingBaseURLString    @"http://172.16.40.148:7777/"  //sit
//#define CLLivingBaseURLString    @"http://172.18.108.194:7777/" //本地
#define CLLivingBaseURLString    @"https://api.253.com/" //生产
#define CLLivingInitURLQuery     @"sdk/liveSDK/init/v2"
#define CLLivingCertifyQuery     @"sdk/faceSDK/getCertifyId"


@interface CLLivingNetWorking : NSObject

+ (void)requestInitWithURLString:(NSString *)URLString
                    timeInterval:(NSTimeInterval)timeInterval
                      parameters:(NSDictionary *)parameters
                      completion:(void(^)(id data , NSError * _Nullable error))handle;

+ (void)requestWithURLString:(NSString *)URLString
                timeInterval:(NSTimeInterval)timeInterval
                  parameters:(NSDictionary *)parameters
                  completion:(void(^)(NSError * error ,id data))handle;

@end



@interface CLLivingTool : NSObject

+ (NSString *)getBundleId;
+ (NSString *)getDevice;
+ (NSString *)getDeviceModel;
+ (NSString *)getDeviceName;
+ (NSString *)getRandomString;
+ (NSString *)getTimeStamp;
+ (NSNumber *)getCurrentTime;

+ (NSString *)secretLoginAndMachineCheckuuidString;
+ (nullable NSString *)stringByAddingPercentEncodingWithAllowedCharacters:(NSString *)string;
+ (NSString *)secretLoginAndMachineCheckhmacsha1:(NSString *)text key:(NSString *)secret;
+ (nullable NSString *)md5:(nullable NSString *)str;

+(NSNumber * _Nullable)clCodeWithError:(NSError * )error;
+(NSString * _Nullable)clDescripetionWithError:(NSError * )error;
@end


NS_ASSUME_NONNULL_END
