//
//  CLLvingConfig.m
//  CLLivingDetectSDK
//
//  Created by chuangLan on 2022/10/20.
//

#import "CLLvingConfig.h"

@implementation CLLvingConfig

+ (CLLvingConfig *)defaultConfig{
    return [[CLLvingConfig alloc] init];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.returnVideo = @(NO);
        self.vertifyAction     = CLLivingVerifyActionLiveness;
        self.vertifyOutTime    = @(5.0f);
        self.returnImage = @(NO);
    }
    return self;
}

@end
