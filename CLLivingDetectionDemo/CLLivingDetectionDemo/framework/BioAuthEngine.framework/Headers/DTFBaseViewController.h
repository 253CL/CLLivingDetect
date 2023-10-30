//
//  APFViewController.h
//  APFaceDetectBiz
//
//  Created by 晗羽 on 8/25/16.
//  Copyright © 2016 DTF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APBTaskContext.h"

@interface DTFBaseViewController : UIViewController

@property(nonatomic, assign) BOOL isClose;
@property(nonatomic, strong) NSString *platformInfo;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property(nonatomic, weak) APBTaskContext *context;

- (void)addWebGuideView:(UIView *)guideView;
- (void)showLoadingView;
- (void)dismissLoadingView;
@end
