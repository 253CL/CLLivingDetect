//
//  CLSettingViewController.h
//  CLLivingDetectionDemo
//
//  Created by chuangLan on 2022/11/7.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@class CLTestSettingModel;
@interface CLSettingViewController : UIViewController

@property (nonatomic,copy)void(^settingCompletion)(CLTestSettingModel * model);

@end

NS_ASSUME_NONNULL_END
