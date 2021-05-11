//
//  LandroidListCell.h
//  MOWOX
//
//  Created by 杭州轨物科技有限公司 on 2018/12/19.
//  Copyright © 2018年 yusz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *deviceImage;
@property (nonatomic, strong) UILabel *deviceListLabel;

- (void)setFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
