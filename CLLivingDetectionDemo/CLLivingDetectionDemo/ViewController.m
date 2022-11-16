//
//  ViewController.m
//  CLLivingDetectionDemo
//
//  Created by chuangLan on 2022/9/28.
//

#import "ViewController.h"
#import "CLSettingViewController.h"
#import <CLLivingDetectSDK/CLLivingDetectSDK.h>
#import "CLTestSettingModel.h"
#import "CLTool.h"

#import <objc/runtime.h>
//#define APPID  @"Hhj6ctbj"   //www.cl.living
//#define APPKEY @"QjHehyy8"

//#define APPID  @"P26AjMYr"   //iostest
//#define APPKEY @"QjHehyy8"

//#define APPID  @"xu1AwOdC"   //com.living.sit
//#define APPKEY @""

#define APPID  @"KQ6WTnju"   //com.living.release
#define APPKEY @""


@interface ViewController ()<UIColorPickerViewControllerDelegate>
@property (nonatomic,strong)NSString * certifyId;

@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [SVProgressHUD setContainerView:self.view];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];

    ///便于demo调整参数设置
    CLTestSettingModel * cacheModel = [CLTestSettingModel cl_cacheModel];
    CLLvingConfig * config = [CLTestSettingModel configWith:cacheModel];
    
    CLConsoleLog(@"app初始化：%@",APPID);
    [CLLivingDetectManager initWithAppId:APPID];
    
    //初始化
    [CLLivingDetectManager setPrintConsoleEnable:YES];
    [CLLivingDetectManager setLivingConfig:config];
    CLConsoleLog(@"SDK配置：%@",[config mj_JSONString]);
      
    [self __initBackgroundView];
    [self __initBottomView];
}

- (void)startLiveDetect:(UIButton *)sender{
    [SVProgressHUD showWithStatus:@"请求中..."];
    sender.enabled = NO; //防止重复点击造成多次请求
    CLConsoleLog(@"SDK开始活体检测...");
    [CLLivingDetectManager startVerifyWithViewController:self completion:^(CLLivingResult * _Nonnull result) {
        CLConsoleLog(@"SDK开始活体检测结果：\n{code:%@,\nmessage:%@,\ninnerCode:%@,\ninnerMessage:%@,\nvideoFilePath:%@,\nimageContent:%@,\ncertifyId:%@}",@(result.code),result.message,@(result.innerCode),result.innerMessage,result.response.videoFilePath,result.response.imageContent,result.response.certifyId);
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"【本地认证结果】%@",result.innerMessage==nil?result.message:result.innerMessage]];
        });
        
        if(result.code == 10000){
            self.certifyId = result.response.certifyId;
        }
    }];
}

- (void)modefySettingEvent:(UIButton *)sender{
    CLSettingViewController * settingVC = [[CLSettingViewController alloc] init];
    settingVC.settingCompletion = ^(CLTestSettingModel * _Nonnull model) {
        CLLvingConfig * config = [CLTestSettingModel configWith:model];
        [CLLivingDetectManager setLivingConfig:config];
    };
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)serverDetect:(UIButton *)sender{
    if(self.certifyId.length  == 0){
        CLConsoleLog(@"验证id为空！请先进行活体检测");
        [SVProgressHUD showErrorWithStatus:@"验证id为空！请先进行活体检测"];
        return;
    }
    sender.enabled = NO;
    [SVProgressHUD showWithStatus:@"请求中..."];
    CLConsoleLog(@"SDK开始服务端校验...");
    CLConsoleLog(@"certify:%@",self.certifyId);
    [self queryVerfyResultWithCertifyId:self.certifyId completion:^(id data, NSError * _Nullable error) {
        CLConsoleLog(@"SDK开始服务端获取认证结果：%@",[data mj_JSONString]);
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
        });
        
        [SVProgressHUD dismiss];
        if(data && data[@"message"]){
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"【服务端查询结果】：%@",data[@"message"]]];
        }else{
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    }];
}

#pragma mark -本地模拟服务端查询接口
/// TODO:  当前接口便于app端模拟测试，去服务端拿校验结果；实际开发中需要用户服务端对接，客户端对接自家服务端
- (void)queryVerfyResultWithCertifyId:(NSString *)certifyId completion:(void(^)(id data , NSError * _Nullable error))handle {
    
    NSDictionary * parameters = @{@"certifyId":certifyId,@"timeStamp":[CLTool getTimeStamp]};
//    NSString * URLString = @"http://172.18.108.194:7777/sdk/liveSDK/livingDetection/test";
//    NSString * URLString = @"http://172.16.43.56:7777/sdk/liveSDK/livingDetection/test"; //stable
//    NSString * URLString = @"http://172.16.40.148:7777/sdk/liveSDK/livingDetection/test"; //sit
    NSString * URLString = @"https://api.253.com/sdk/liveSDK/livingDetection/test"; //release
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.timeoutInterval = 15.0f;
    request.HTTPMethod = @"POST";
    NSString *POST_BOUNDS = @"adsfgshdfhaksdfhasdakjjhfkjf";
    NSMutableString *bodyContent = [NSMutableString string];
    for(NSString *key in parameters.allKeys){
        id value = [parameters objectForKey:key];
        [bodyContent appendFormat:@"--%@\r\n",POST_BOUNDS];
        [bodyContent appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        [bodyContent appendFormat:@"%@\r\n",value];
    }
    [bodyContent appendFormat:@"--%@--\r\n",POST_BOUNDS];
    NSData *bodyData=[bodyContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",POST_BOUNDS] forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:bodyData];
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"服务端查询结果：%@",json);
            handle(json,error);
            
        }else{
            handle(nil ,error);
        }
    }];
    [dataTask resume];
}


#pragma mark -ui
- (void)__initBackgroundView {
    UIImageView *personImageView = [[UIImageView alloc] init];
    personImageView.image = [UIImage imageNamed:@"pic_demo"];
    [self.view addSubview:personImageView];
    [personImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(CL_StatusBar_Height + KCLUIHeightAdapter(16));
        make.right.equalTo(self.view).offset(-kCLUIAdapter(32));
        make.width.equalTo(@(kCLUIAdapter(137)));
        make.height.equalTo(@(kCLUIAdapter(170)));
    }];
    
    UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(logEvent:)];
    personImageView.userInteractionEnabled = YES;
    [personImageView addGestureRecognizer:longGes];

    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"ico_logo_bar"];
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personImageView.mas_bottom).offset(KCLUIHeightAdapter(12));
        make.left.equalTo(self.view).offset(kCLUIAdapter(28));
        make.width.mas_equalTo(kCLUIAdapter(32));
        make.height.mas_equalTo(kCLUIAdapter(23));
    }];

    UILabel *firstLineTitleLable = [[UILabel alloc] init];
    firstLineTitleLable.text = @"欢迎体验，";
    firstLineTitleLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:kCLUIAdapter(28)];
    firstLineTitleLable.textColor = UIColorFromHex(0x464646);
    [self.view addSubview:firstLineTitleLable];
    [firstLineTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).offset(12);
        make.left.equalTo(self.view).offset(kCLUIAdapter(32));
    }];

    UILabel *secondLineTitleLable = [[UILabel alloc] init];
    secondLineTitleLable.text = @"创蓝活体检测Demo";
    secondLineTitleLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:kCLUIAdapter(24)];
    secondLineTitleLable.textColor = UIColorFromHex(0x464646);
    [self.view addSubview:secondLineTitleLable];
    [secondLineTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLineTitleLable.mas_bottom).offset(4);
        make.left.equalTo(firstLineTitleLable);
    }];

    UIImageView *firstGreenIconView = [[UIImageView alloc] init];
    firstGreenIconView.image = [UIImage imageNamed:@"ico_green"];
    [self.view addSubview:firstGreenIconView];
    [firstGreenIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondLineTitleLable.mas_bottom).mas_offset(KCLUIHeightAdapter(40));
        make.left.equalTo(self.view).offset(kCLUIAdapter(29));
        make.width.mas_equalTo(kCLUIAdapter(20));
        make.height.mas_equalTo(kCLUIAdapter(20));
    }];

    UILabel *firstGreenTitleLable = [[UILabel alloc] init];
    firstGreenTitleLable.text = @"明亮的光线环境下使用";
    firstGreenTitleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kCLUIAdapter(14)];
    firstGreenTitleLable.textColor = UIColorFromHex(0x8A8A99);
    [self.view addSubview:firstGreenTitleLable];
    [firstGreenTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstGreenIconView);
        make.left.equalTo(firstGreenIconView.mas_right).offset(kCLUIAdapter(29));
    }];

    UIImageView *secondGreenIconView = [[UIImageView alloc] init];
    secondGreenIconView.image = [UIImage imageNamed:@"ico_green"];
    [self.view addSubview:secondGreenIconView];
    [secondGreenIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstGreenIconView.mas_bottom).offset(18);
        make.left.equalTo(firstGreenIconView);
        make.width.equalTo(firstGreenIconView);
        make.height.equalTo(firstGreenIconView);
    }];

    UILabel *secondGreenTitleLable = [[UILabel alloc] init];
    secondGreenTitleLable.text = @"不要遮挡面部";
    secondGreenTitleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kCLUIAdapter(14)];
    secondGreenTitleLable.textColor = UIColorFromHex(0x8A8A99);
    [self.view addSubview:secondGreenTitleLable];
    [secondGreenTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secondGreenIconView);
        make.left.equalTo(firstGreenTitleLable);
    }];

    UIImageView *thirdGreenIconView = [[UIImageView alloc] init];
    thirdGreenIconView.image = [UIImage imageNamed:@"ico_green"];
    [self.view addSubview:thirdGreenIconView];
    [thirdGreenIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondGreenIconView.mas_bottom).offset(18);
        make.left.equalTo(firstGreenIconView);
        make.width.equalTo(firstGreenIconView);
        make.height.equalTo(firstGreenIconView);
    }];

    UILabel *thirdGreenTitleLable = [[UILabel alloc] init];
    thirdGreenTitleLable.text = @"正握手机，人脸正对屏幕";
    thirdGreenTitleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kCLUIAdapter(14)];
    thirdGreenTitleLable.textColor = UIColorFromHex(0x8A8A99);
    [self.view addSubview:thirdGreenTitleLable];
    [thirdGreenTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(thirdGreenIconView);
        make.left.equalTo(firstGreenTitleLable);
    }];

    UIButton *startDetectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startDetectButton setTitle:@"开始活体检测" forState:UIControlStateNormal];
    [startDetectButton setTitle:@"开始活体检测" forState:UIControlStateHighlighted];
    [startDetectButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
    [startDetectButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateHighlighted];
    startDetectButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kCLUIAdapter(15)];
    startDetectButton.layer.cornerRadius = kCLUIAdapter(44)/2;
    startDetectButton.layer.masksToBounds = YES;
    [startDetectButton addTarget:self action:@selector(startLiveDetect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startDetectButton];
    [startDetectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdGreenIconView.mas_bottom).offset(KCLUIHeightAdapter(15));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(kCLUIAdapter(44));
        make.width.mas_equalTo(kCLUIAdapter(311));
    }];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, kCLUIAdapter(311), kCLUIAdapter(44));
    gradientLayer.colors = @[(id)UIColorFromHex(0x60b1fe).CGColor, (id)UIColorFromHex(0x6551f6).CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    [startDetectButton.layer insertSublayer:gradientLayer atIndex:0];
    
    
    UIButton *serverDetectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serverDetectButton setTitle:@"开始服务端校验" forState:UIControlStateNormal];
    [serverDetectButton setTitle:@"开始服务端校验" forState:UIControlStateHighlighted];
    [serverDetectButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
    [serverDetectButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateHighlighted];
    serverDetectButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kCLUIAdapter(15)];
    serverDetectButton.layer.cornerRadius = kCLUIAdapter(44)/2;
    serverDetectButton.layer.masksToBounds = YES;
    [serverDetectButton addTarget:self action:@selector(serverDetect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serverDetectButton];
    [serverDetectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startDetectButton.mas_bottom).offset(KCLUIHeightAdapter(15));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(kCLUIAdapter(44));
        make.width.mas_equalTo(kCLUIAdapter(311));
    }];

    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, kCLUIAdapter(311), kCLUIAdapter(44));
    gradientLayer1.colors = @[(id)UIColorFromHex(0x60b1fe).CGColor, (id)UIColorFromHex(0x6551f6).CGColor];
    gradientLayer1.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer1.endPoint = CGPointMake(1.0, 0.5);
    [serverDetectButton.layer insertSublayer:gradientLayer1 atIndex:0];

    UIButton *startRealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startRealButton setTitle:@"更改默认设置" forState:UIControlStateNormal];
    [startRealButton setTitle:@"更改默认设置" forState:UIControlStateHighlighted];
    [startRealButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
    [startRealButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateHighlighted];
    startRealButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kCLUIAdapter(15)];
    startRealButton.layer.cornerRadius = kCLUIAdapter(44)/2;
    startRealButton.layer.masksToBounds = YES;
    [startRealButton addTarget:self action:@selector(modefySettingEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startRealButton];
    [startRealButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serverDetectButton.mas_bottom).offset(kCLUIAdapter(15));
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(kCLUIAdapter(44));
        make.width.mas_equalTo(kCLUIAdapter(311));
    }];

    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(0, 0, kCLUIAdapter(311), kCLUIAdapter(44));
    gradientLayer2.colors = @[(id)UIColorFromHex(0x60b1fe).CGColor, (id)UIColorFromHex(0x6551f6).CGColor];
    gradientLayer2.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer2.endPoint = CGPointMake(1.0, 0.5);
    [startRealButton.layer insertSublayer:gradientLayer2 atIndex:0];
}

- (void)__initBottomView {
    UILabel *bottomCopyRightLabel = [[UILabel alloc] init];
    bottomCopyRightLabel.text = bottomCopyRightText;
    bottomCopyRightLabel.font = [UIFont systemFontOfSize:kCLUIAdapter(12)];
    bottomCopyRightLabel.textColor = UIColorFromHex(0x999999);
    [self.view addSubview:bottomCopyRightLabel];
    [bottomCopyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(CL_IS_iPhoneX ? -40 : -20);
    }];
}

- (void)__initNavItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"log" style:(UIBarButtonItemStyleDone) target:self action:@selector(logEvent:)];
}

- (void)logEvent:(UIGestureRecognizer *)ges{
    UIViewController * vc = [[[NSClassFromString(@"CLLogViewController") class] alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
