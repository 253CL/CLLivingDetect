//
//  FaceViewProviderProtocol.h
//  ZolozUIModule
//
//  Created by mengbingchuan on 2022/8/29.
//  Copyright © 2022 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZolozFaceViewProtocol.h"

@protocol ZolozViewProviderProtocol <NSObject>

- (id<ZolozFaceViewProtocol>)viewForFace;

@end
