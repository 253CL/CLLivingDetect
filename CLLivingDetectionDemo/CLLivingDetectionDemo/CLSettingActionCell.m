//
//  CLSettingActionCell.m
//  CLLivingDetectionDemo
//
//  Created by chuangLan on 2022/11/7.
//

#import "CLSettingActionCell.h"


@implementation CLBaseCell

- (instancetype)init{
    self = [super init];
    if(self){
//        self.titleLabel = [[UILabel alloc] init];
//        self.titleLabel.frame = CGRectMake(15, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    }
    return self;
}

@end

@implementation CLSettingActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected){
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the view for the selected state
}

@end


@implementation CLSettingColorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.colorView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-100, 10, 50, 30)];
        self.colorView.layer.cornerRadius = 5;
        self.colorView.layer.masksToBounds= YES;
        [self addSubview:self.colorView];
    }
    return self;
}

@end


@implementation CLSettingImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-100, 10, 100, 44)];
        [self.switchBtn addTarget:self action:@selector(changheValueEvent:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.switchBtn];
    }
    return self;
}

- (void)changheValueEvent:(UISwitch *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(modefySettingSwitchOn:indexPath:)]){
        [self.delegate modefySettingSwitchOn:sender.on indexPath:self.indexPath];
    }
}

@end



@implementation CLSettingTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.numField = [[UITextField alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-100, 0, 100, 50)];
        
        [self.numField addTarget:self action:@selector(editEvent:) forControlEvents:UIControlEventEditingChanged];
        self.numField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:self.numField];
    }
    return self;
}

- (void)editEvent:(UITextField *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(modefySettingTime:indexPath:)]){
        [self.delegate modefySettingTime:sender.text indexPath:self.indexPath];
    }
}



@end
