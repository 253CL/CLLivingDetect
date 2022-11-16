//
//  CLSettingViewController.m
//  CLLivingDetectionDemo
//
//  Created by chuangLan on 2022/11/7.
//

#import "CLSettingViewController.h"
#import "CLSettingActionCell.h"
#import "CLTestSettingModel.h"
#import "CLTool.h"
@interface CLSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIColorPickerViewControllerDelegate,CLSettingProtocol>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)CLTestSettingModel * testModel;

@end

@implementation CLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testModel = [CLTestSettingModel cl_cacheModel];
    if(self.testModel==nil){
        self.testModel = [[CLTestSettingModel alloc] init];
    }

    self.title = @"设置";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellIndentity"];
    [self.tableView registerClass:[CLSettingColorCell class] forCellReuseIdentifier:@"CLSettingColorCell"];
    [self.tableView registerClass:[CLSettingActionCell class] forCellReuseIdentifier:@"CLSettingActionCell"];
    [self.tableView registerClass:[CLSettingImageCell class] forCellReuseIdentifier:@"CLSettingImageCell"];
    [self.tableView registerClass:[CLSettingTimeCell class] forCellReuseIdentifier:@"CLSettingTimeCell"];
    [self setFooterView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    
//    self.topConstraint.constant = CL_Nav_Height;
    
    [SVProgressHUD setContainerView:self.view];
    [self freshSetting];
}

- (void)freshSetting{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.testModel.action >0?self.testModel.action-1:0 inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionNone)];
    
    CLSettingColorCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    if(cell){
        cell.colorView.backgroundColor = [CLTool colorWithHexString:self.testModel.colorStr alpha:1];
    }
}

- (void)setFooterView{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.text = @"当前配置点击后才能生效！！";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = UIColor.purpleColor;
    [v addSubview:tipLabel];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(50, 30, [UIScreen mainScreen].bounds.size.width-100, 46)];
    [button setTitle:@"点击设置生效" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColorFromHex(0x60b1fe)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(settingEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds= YES;
    [v addSubview:button];
    self.tableView.tableFooterView = v;
}


#pragma mark - tableview delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @[@"检测动作",@"超时时间配置",@"扫脸进度条颜色",@"图片设置",@"视频设置"][section];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        CLSettingActionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CLSettingActionCell" forIndexPath:indexPath];
        cell.textLabel.text = @[@"单动作-眨眼检测",@"多动作-眨眼+任意摇头检测"][indexPath.row];
        return cell;
    }else if(indexPath.section ==2){
        CLSettingColorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CLSettingColorCell" forIndexPath:indexPath];
        cell.textLabel.text = @"颜色设置";
        return cell;
    }else if(indexPath.section ==3 || indexPath.section ==4){
        
        CLSettingImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CLSettingImageCell" forIndexPath:indexPath];
        if(indexPath.section ==3){
            cell.textLabel.text = @"是否返回图片";
            cell.switchBtn.on   = self.testModel.returnImage;
        }else{
            cell.textLabel.text = @"是否返回视频";
            cell.switchBtn.on   = self.testModel.returnVideo;
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }else if(indexPath.section ==1 ){
        
        CLSettingTimeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CLSettingTimeCell" forIndexPath:indexPath];
        cell.textLabel.text = @"更改时间(单位：s)";
        cell.numField.text = [NSString stringWithFormat:@"%.1f",self.testModel.timeout];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    } else{
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIndentity"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==2){
        [self startRealDetect];
    }else if (indexPath.section==0){
        self.testModel.action = indexPath.row +1;
    }
}

#pragma mark - cell delegate
- (void)modefySettingSwitchOn:(BOOL)on indexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==3){
        self.testModel.returnImage = on;
    }else if (indexPath.section==4){
        self.testModel.returnVideo = on;
    }
}
- (void)modefySettingTime:(NSString *)time indexPath:(NSIndexPath *)indexPath{
    self.testModel.timeout = [time floatValue];
    NSLog(@"修改时间了%@",time);
}


- (void)settingEvent:(UIButton *)sender {
    if(self.settingCompletion){
        
        [self.testModel cl_save];
        self.settingCompletion(self.testModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 颜色
- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController API_AVAILABLE(ios(14.0)){
}

- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController API_AVAILABLE(ios(14.0)){
    
    self.testModel.colorStr = [CLTool hexadecimalFromUIColor:viewController.selectedColor];
    CLSettingColorCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    cell.colorView.backgroundColor = viewController.selectedColor;
//    NSLog(@"====%@",[Tool hexadecimalFromUIColor:viewController.selectedColor]);
}

- (void)startRealDetect{
    if (@available(iOS 14.0, *)) {
        UIColorPickerViewController * pickVC = [[UIColorPickerViewController alloc] init];
        pickVC.view.backgroundColor = UIColor.whiteColor;
        pickVC.delegate = self;
        [self.navigationController pushViewController:pickVC animated:YES];
    }else{
//        [SVProgressHUD showErrorWithStatus:@"当前颜色为随机色！！！"];
        UIColor * randomColor = [CLTool getRandomColor];
        self.testModel.colorStr = [CLTool hexadecimalFromUIColor:randomColor];
        
        CLSettingColorCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        cell.colorView.backgroundColor = randomColor;
        
        [self freshSetting];
    }
    return;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


@end
