//
//  SelectDeviceCell.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/10.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "SelectDeviceCell.h"

@implementation SelectDeviceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        if (!_chooseImage) {
            _chooseImage = [[UIImageView alloc] init];
            [self.contentView addSubview:_chooseImage];
            [_chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(146.f), yAutoFit(99.f)));
                make.left.equalTo(self.contentView.mas_left).offset(yAutoFit(42.f));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }
        if (!_rightNameLab) {
            _rightNameLab = [[UILabel alloc] init];
            _rightNameLab.font = [UIFont systemFontOfSize:30.f];
            _rightNameLab.backgroundColor = [UIColor clearColor];
            _rightNameLab.textColor = [UIColor whiteColor];
            _rightNameLab.adjustsFontSizeToFitWidth = YES;
            _rightNameLab.textAlignment = NSTextAlignmentLeft;
            [self.contentView addSubview:_rightNameLab];
            [_rightNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(yAutoFit(200), yAutoFit(30)));
                make.left.equalTo(self.chooseImage.mas_right).offset(yAutoFit(50));
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
        }

    }
    return self;
}

//重写frame 自定义Cell之间的间距
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
