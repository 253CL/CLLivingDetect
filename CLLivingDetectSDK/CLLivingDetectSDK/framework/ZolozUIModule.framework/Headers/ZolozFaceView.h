//
//  ZolozFaceView.h
//  MultiFactorFacade
//
//  Created by mengbingchuan on 2022/6/22.
//  Copyright © 2022 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZolozFaceViewProtocol.h"

typedef NS_ENUM(NSInteger, ZolozAuthScene) {
    ZolozAuthSceneFace =        1,  //刷脸
    ZolozAuthSceneMultiFactor = 2,  //意愿
};

@interface ZolozFaceView : UIView<ZolozFaceViewProtocol>

- (instancetype)initWithAuthScene:(ZolozAuthScene)authScene;

@end
