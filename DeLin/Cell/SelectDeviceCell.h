//
//  SelectDeviceCell.h
//  DeLin
//
//  Created by 安建伟 on 2019/12/10.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectDeviceCell : UITableViewCell

@property (nonatomic, strong) UIImageView *chooseImage;
@property (nonatomic, strong) UILabel *rightNameLab;

- (void)setFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
