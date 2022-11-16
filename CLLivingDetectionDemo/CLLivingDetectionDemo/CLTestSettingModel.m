//
//  CLTestSettingModel.m
//  CLLivingDetectionDemo
//
//  Created by chuangLan on 2022/11/9.
//

#import "CLTestSettingModel.h"
#import <MJExtension/MJExtension.h>

@implementation CLTestSettingModel
MJCodingImplementation

+ (CLLvingConfig *)configWith:(CLTestSettingModel *)model{
    if(!model) {
        model = [[CLTestSettingModel alloc] init];
    }
    CLLvingConfig * config = [CLLvingConfig defaultConfig];
    config.returnImage = @(model.returnImage);
    config.returnVideo = @(model.returnVideo);
    config.faceCircleColor = model.colorStr;
    config.vertifyOutTime  = @(model.timeout);
    config.vertifyAction   = model.action;
    return config;
}



- (instancetype)init{
    self = [super init];
    if(self){        
        self.returnImage = NO;
        self.returnVideo = NO;
        self.action      = 1;
        self.colorStr    = @"#cc0000";
        self.timeout     = 5.0f;
    }
    return self;
}

- (void)cl_save{
    NSString * filePath = [CLTestSettingModel getFilePath];
    [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

+ (CLTestSettingModel *)cl_cacheModel{
    NSString * filePath = [CLTestSettingModel getFilePath];
    CLTestSettingModel * model = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return model;
}

+ (NSString *)getFilePath {
    //获取Documents
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"CLLivingTestSettingModel"];
    return filePath;
}

@end
