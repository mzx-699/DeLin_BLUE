//
//  userPrivacyAgreementController.m
//  DeLin
//
//  Created by 安建伟 on 2020/7/23.
//  Copyright © 2020 com.thingcom. All rights reserved.
//

#import "UserPrivacyAgreementController.h"

@interface UserPrivacyAgreementController ()<UITextViewDelegate>

@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UIScrollView *secondAgreementScrollView;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation UserPrivacyAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _secondAgreementScrollView = [self secondAgreementScrollView];
    [self setNavItem];
}

#pragma mark - LazyLoad

- (void)setNavItem{
    //self.navigationItem.title = LocalString(@"用户协议和隐私政策");
    
    UIImage *image = [UIImage imageNamed:@"img_back_black"];
    [self addLeftBarButtonWithImage:image action:@selector(backAction)];
    
}


- (UIScrollView *)secondAgreementScrollView{
    if (!_secondAgreementScrollView) {
        // 1.创建UIScrollView
        _secondAgreementScrollView  = [[UIScrollView alloc] init];
        _secondAgreementScrollView.frame = CGRectMake(0, getRectNavAndStatusHight, ScreenWidth,ScreenHeight);
        // frame中的size指UIScrollView的可视范围
        _secondAgreementScrollView.backgroundColor = [UIColor clearColor];
        _secondAgreementScrollView.delegate = self;
        _secondAgreementScrollView.clipsToBounds = YES;
        _secondAgreementScrollView.canCancelContentTouches = YES;
        _secondAgreementScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        // 设置内容大小
        _secondAgreementScrollView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight);
        // 是否分页
        _secondAgreementScrollView.pagingEnabled = NO;//这里很重要，因为设置为YES会出现滑动不流畅
        // 提示用户,Indicators flash
        [_secondAgreementScrollView flashScrollIndicators];
        
        // 是否同时运动,lock
        _secondAgreementScrollView.directionalLockEnabled = YES;
        _secondAgreementScrollView.bouncesZoom = NO;
        _secondAgreementScrollView.scrollEnabled = YES;
        
        [self.view addSubview:_secondAgreementScrollView];
        
//        _headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_logo"]];
//        [_secondAgreementScrollView addSubview:_headerImage];
//        [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(140/WScale, 112/HScale));
//            make.centerX.equalTo(self.secondAgreementScrollView.mas_centerX);
//            make.top.equalTo(self.secondAgreementScrollView.mas_top).offset(20/HScale);
//        }];
        
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(0, yAutoFit(10.f), ScreenWidth,ScreenHeight);
        _textView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight);
        _textView.backgroundColor = [UIColor clearColor];
        _textView.text = LocalString(@"Terms of Service and Privacy Policy\n\n1.Term of Services\n\nBy downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. We are offering you this app to use for your own personal use without cost, but you should be aware that you cannot send it on to anyone else, and you’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to REDBACK.\nAt the bottom of these terms and conditions you will be able to find links to our website where we set out our Privacy Policy, which will be relevant if you use the app to use REDBACK robots in the future.\n\n2.Privacy Policy\n\nGeneral Information\n\nThis information provides the REDBACK Robots App (the App) privacy policy regarding the purpose, use, and sharing of any Personally Information (PI) collected via this website and/or the App. Our privacy policy explains our information practices when you provide PI to us, whether collected online or offline, or when you visit us online to browse, obtain information, or conduct a transaction. PI may include: your name and email(nick name is also workable for the appliance but the email needs to be real.).\nWe do not require you to register or provide personal information to visit the App. However, to maintain connectivity between you and REDBACK robots, a registration in the App with your email account is required.\nThe PI you provide on REDBACK Robots App will be used only for its intended purpose. We will protect your information consistent with us and us only.\n\nPersonally Information (PI)\n\nAs a general rule, the App does not collect PI about you when you are using, unless you choose to provide such information to us. Submitting PI through the App is voluntary. By doing so, you are giving the App your permission to use the information for the stated purpose.\nGenerally, the information requested will be used to get the original password for controlling the robot mower.");
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.textColor = [UIColor blackColor];
        _textView.font = [UIFont boldSystemFontOfSize:16];
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;
        // 禁止编辑.设置为只读，不再能输入内容
        _textView.editable = NO;
        //禁止选择.禁止选中文本，此时文本也禁止编辑
        _textView.selectable = NO;
        _textView.scrollEnabled = NO;
        // 设置可以对选中的文字加粗。选中文字时可以对选中的文字加粗
        _textView.allowsEditingTextAttributes = YES;
        _textView.delegate = self;
        _textView.adjustsFontForContentSizeCategory = YES;
        //文字滑动到底部
        CGPoint offset = _textView.contentOffset;
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            [self.textView setContentOffset: offset];
        }];
        [self textViewDidChange:_textView];
        [self.secondAgreementScrollView addSubview:_textView];
    }
    return _secondAgreementScrollView;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    _secondAgreementScrollView.contentSize = CGSizeMake(ScreenWidth,100/HScale + newSize.height);
}

- (void)backAction{

    //返回上一级视图
    UIViewController *viewCtl = self.navigationController.viewControllers[4];
    [self.navigationController popToViewController:viewCtl animated:YES];
}

@end
