//
//  WorktimeCell.m
//  MOWOX
//
//  Created by Mac on 2017/12/11.
//  Copyright © 2017年 yusz. All rights reserved.
//

#import "WorktimeCell.h"
#define viewWidth self.contentView.frame.size.width
#define viewHeight self.contentView.frame.size.height

@interface WorktimeCell () <UITextFieldDelegate>
@end

@implementation WorktimeCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(done) name:@"done" object:nil];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_weekLabel) {
            _weekLabel = [[UILabel alloc] init];
            _weekLabel.frame = CGRectMake(yAutoFit(30) , 5, ScreenWidth / 3.0, viewHeight - 5);
            _weekLabel.font = [UIFont systemFontOfSize:25.f];
            _weekLabel.textColor = [UIColor colorWithHexString:@"FF9700"];
            [self.contentView addSubview:self.weekLabel];
        }
        if (!_worksHoursTF) {
            _worksHoursTF = [[UITextField alloc] init];
            _worksHoursTF.textColor = [UIColor whiteColor];
            _worksHoursTF.frame = CGRectMake(ScreenWidth / 3.0 + 50 , 5, (ScreenWidth / 3.0)/2, viewHeight - 5);
            _worksHoursTF.font = [UIFont systemFontOfSize:25.0];
            [_worksHoursTF addTarget:self action:@selector(pushTag) forControlEvents:UIControlEventTouchUpInside];
            _worksHoursTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _worksHoursTF.enabled = NO;
            [self.contentView addSubview:self.worksHoursTF];
        }
        if (!_worksMinutesTF) {
            _worksMinutesTF = [[UITextField alloc] init];
            _worksMinutesTF.textColor = [UIColor whiteColor];
            _worksMinutesTF.frame = CGRectMake(ScreenWidth / 3.0 + 80, 5, (ScreenWidth / 3.0)/2 + 8, viewHeight - 5);
            _worksMinutesTF.font = [UIFont systemFontOfSize:25.0];
            [_worksMinutesTF addTarget:self action:@selector(pushTag) forControlEvents:UIControlEventTouchUpInside];
            _worksMinutesTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [self.contentView addSubview:self.worksMinutesTF];
        }
        
        if (!_workTimeSwitch) {
            _workTimeSwitch = [[UISwitch alloc] init];
            _workTimeSwitch.transform = CGAffineTransformMakeScale(1, 1);
            [_workTimeSwitch setOn:NO animated:YES];
            [_workTimeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [self.contentView addSubview:_workTimeSwitch];
            [_workTimeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(yAutoFit(-50.f));
                make.centerY.equalTo(self.contentView.mas_centerY).offset(yAutoFit(-8.f));
            }];
            _workTimeSwitch.tintColor = [UIColor colorWithHexString:@"A8A5A5"];
            _workTimeSwitch.onTintColor = [UIColor colorWithHexString:@"FF9700"];
            _workTimeSwitch.backgroundColor = [UIColor colorWithHexString:@"A8A5A5"];
            _workTimeSwitch.layer.cornerRadius = 15.5f;
            _workTimeSwitch.layer.masksToBounds = YES;
        }
    }
    return self;
}

- (void)done {
    [_worksHoursTF resignFirstResponder];
    [_worksMinutesTF resignFirstResponder];
}

- (void)pushTag{
    
}

- (BOOL)textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch *)sender;
    if (self.block) {
        self.block(switchButton.isOn);
    }
}

@end
