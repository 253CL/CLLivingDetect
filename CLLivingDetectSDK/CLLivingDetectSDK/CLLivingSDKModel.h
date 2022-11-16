//
//  CLLivingSDKModel.h
//  CLLivingDetectSDK
//
//  Created by chuangLan on 2022/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLLivingSDKModel : NSObject<NSCoding>

@property(nonatomic, assign)NSInteger  code;
@property(nonatomic, strong)NSString * message;

@property(nonatomic, strong)NSDictionary * data;

@property(nonatomic, assign)NSInteger vertityAction;
@property(nonatomic, assign)double     currentTime;

@property(nonatomic, strong)NSString * certifyId;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)cl_save;
+ (void)cl_remove;
+ (CLLivingSDKModel *)cl_cacheModel;
@end

NS_ASSUME_NONNULL_END
