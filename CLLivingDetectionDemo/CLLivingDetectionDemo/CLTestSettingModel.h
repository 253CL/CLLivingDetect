//
//  CLTestSettingModel.h
//  CLLivingDetectionDemo
//
//  Created by chuangLan on 2022/11/9.
//

#import <Foundation/Foundation.h>
#import <CLLivingDetectSDK/CLLivingDetectSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLTestSettingModel : NSObject<NSCoding>

@property (nonatomic,assign)BOOL returnImage;

@property (nonatomic,assign)BOOL returnVideo;

@property (nonatomic,assign)NSInteger action;

@property (nonatomic,strong)NSString * colorStr;

@property (nonatomic,assign)CGFloat timeout;

- (void)cl_save;
+ (CLTestSettingModel *)cl_cacheModel;

+ (CLLvingConfig *)configWith:(CLTestSettingModel *)model;

@end

NS_ASSUME_NONNULL_END
