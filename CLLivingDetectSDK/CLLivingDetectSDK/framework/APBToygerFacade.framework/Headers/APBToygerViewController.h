//
//  APFViewController.h
//  APFaceDetectBiz
//
//  Created by 晗羽 on 8/25/16.
//  Copyright © 2016 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ToygerService/ToygerService.h>
#import <ZolozUIModule/ZolozFaceViewProtocol.h>

NSString *const kAbnormalClose = @"abnormalclose";

@interface APBToygerViewController : UIViewController

@property(nonatomic, strong) ZolozLogMonitor *monitor;
@property(nonatomic, strong) id<ZolozFaceViewProtocol> faceView;
@property(nonatomic, assign) BOOL isClose;

- (void)startFaceRecognition:(AVCaptureVideoPreviewLayer *)layer;
- (void)handleFaceStateChange:(ToygerMessage)state
                    stateTips:(NSString *)tips
                  actionGuide:(NSString *)guide
                     progress:(CGFloat)progress;
- (void)showLoadingView;
- (void)dismissLoadingView;
- (void)setPhotinusColor:(UIColor *)color;
- (void)showBlur:(UIImage *)image;

@end
