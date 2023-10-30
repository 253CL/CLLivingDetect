//
//  DTFSDKConfiguration.h
//  DTFUtility
//
//  Created by 汪澌哲 on 2023/5/22.
//  Copyright © 2023 com.alipay.iphoneclient.zoloz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTFSDKConfiguration : NSObject

//原数据
@property (nonatomic, copy) NSString *NEED_BACKUP_URL;
@property (nonatomic, copy) NSString *LOG_UPLOAD;
@property (nonatomic, copy) NSString *LOG_DEBUG_UPLOAD;
@property (nonatomic, copy) NSString *FORCE_MODEL_DOWNLOAD;
@property (nonatomic, copy) NSString *URLSESSION_DEGRADE;
@property (nonatomic, copy) NSArray *MODEL_FILES;

//处理后数据
@property (nonatomic, assign) BOOL urlSessionDegrade;

- (void)setConfigString:(NSString *)string;

- (void)updateConfig;

@end

