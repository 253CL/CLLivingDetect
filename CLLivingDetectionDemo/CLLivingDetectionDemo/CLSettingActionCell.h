//
//  CLSettingActionCell.h
//  CLLivingDetectionDemo
//
//  Created by chuangLan on 2022/11/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CLSettingProtocol <NSObject>
- (void)modefySettingSwitchOn:(BOOL)on indexPath:(NSIndexPath *)indexPath;
- (void)modefySettingTime:(NSString *)time indexPath:(NSIndexPath *)indexPath;
@end


@interface CLBaseCell : UITableViewCell

@property (nonatomic,strong)UILabel * titleLabel;

@end

@interface CLSettingActionCell : UITableViewCell

@end

@interface CLSettingColorCell : UITableViewCell

@property (nonatomic,strong)UIView * colorView;

@end


@interface CLSettingImageCell : UITableViewCell

@property (nonatomic,strong)UISwitch * switchBtn;

@property (nonatomic,strong)UILabel * label;

@property (nonatomic,weak)id<CLSettingProtocol>delegate;

@property (nonatomic,strong)NSIndexPath * indexPath;

@end


@interface CLSettingTimeCell : UITableViewCell

@property (nonatomic,strong)UITextField * numField;
@property (nonatomic,weak)id<CLSettingProtocol>delegate;
@property (nonatomic,strong)NSIndexPath * indexPath;
@end

NS_ASSUME_NONNULL_END
