//
//  AAPersonalTF.h
//  DeLin
//
//  Created by 安建伟 on 2019/12/4.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAPersonalLastNameTF : UIView <UITextFieldDelegate>

@property (nonatomic,strong) NSString *PlaceholderText;

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIView *labelView;

@property (nonatomic,assign) CGRect lastNameTFFrame;

@property (nonatomic,strong) UITextField *inputLastNameTF;

-(instancetype)initWithFrame:(CGRect)frame withPlaceholderText:(NSString *)lastName;

-(void)lastNameTFBeginEditing;

-(void)lastNameTFEndEditing;

@end

NS_ASSUME_NONNULL_END
