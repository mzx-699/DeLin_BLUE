//
//  HelpViewController.m
//  DeLin
//
//  Created by 安建伟 on 2020/8/4.
//  Copyright © 2020 com.thingcom. All rights reserved.
//

#import "HelpSupportViewController.h"

@interface HelpSupportViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UIScrollView *secondAgreementScrollView;

@end

@implementation HelpSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    _secondAgreementScrollView = [self secondAgreementScrollView];
    [self setNavItem];
}

#pragma mark - LazyLoad

- (void)setNavItem{
    //self.navigationItem.title = LocalString(@"Help and support");
    UIImage *image = [UIImage imageNamed:LocalString(@"img_back_black")];
    [self addLeftBarButtonWithImage:image action:@selector(backAction)];
    
}

// 定义缩放比例
CGFloat scaleMini = 1.0;
CGFloat scaleMax = 3.0;

- (UIScrollView *)secondAgreementScrollView{
    if (!_secondAgreementScrollView) {
        // 1.创建UIScrollView
        _secondAgreementScrollView  = [[UIScrollView alloc] init];
        _secondAgreementScrollView.frame = CGRectMake(0, getRectNavAndStatusHight, ScreenWidth,ScreenHeight); // frame中的size指UIScrollView的可视范围
        _secondAgreementScrollView.backgroundColor = [UIColor clearColor];
        _secondAgreementScrollView.delegate = self;
        _secondAgreementScrollView.clipsToBounds = YES;
        _secondAgreementScrollView.canCancelContentTouches = YES;
        _secondAgreementScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        // 设置内容大小
        _secondAgreementScrollView.contentSize = CGSizeMake(ScreenWidth,2.5* ScreenHeight);
        // 是否分页
        _secondAgreementScrollView.pagingEnabled = NO;
        _secondAgreementScrollView.userInteractionEnabled = YES;
        // 提示用户,Indicators flash
        [_secondAgreementScrollView flashScrollIndicators];
        
        _secondAgreementScrollView.showsHorizontalScrollIndicator = NO;
        _secondAgreementScrollView.showsVerticalScrollIndicator = NO;
        // 是否同时运动,lock
        _secondAgreementScrollView.directionalLockEnabled = YES;
        _secondAgreementScrollView.bouncesZoom = NO;
        _secondAgreementScrollView.scrollEnabled = YES;
        
        //设置代理,设置最大缩放和虽小缩放
        _secondAgreementScrollView.maximumZoomScale = scaleMax;
        _secondAgreementScrollView.minimumZoomScale = scaleMini;
        
        [self.view addSubview:_secondAgreementScrollView];
        
        _headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LocalString(@"img_help_English")]];
        [_secondAgreementScrollView addSubview:_headerImage];
        [_headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 3*ScreenHeight));
            make.centerX.equalTo(self.secondAgreementScrollView.mas_centerX);
            make.top.equalTo(self.secondAgreementScrollView.mas_top).offset(yAutoFit(10.f));
        }];
        
    }
    return _secondAgreementScrollView;
}

#pragma mark - Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat imageWidth = scrollView.frame.size.width;
    CGSize newSize = [scrollView sizeThatFits:CGSizeMake(imageWidth, MAXFLOAT)];
    CGRect newFrame = scrollView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, imageWidth), newSize.height);
    scrollView.frame = newFrame;
    _secondAgreementScrollView.contentSize = CGSizeMake(ScreenWidth, 2.5*ScreenHeight + newSize.height);

}

//代理方法，告诉ScrollView要缩放的是哪个视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _headerImage;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self showInCenter:scrollView imageView:_headerImage];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    // 缩放效果 放大或缩小
    if (scrollView.minimumZoomScale >= scale) {
        [scrollView setZoomScale:scaleMini animated:YES];
    }
    if (scrollView.maximumZoomScale <= scale) {
        [scrollView setZoomScale:scaleMax animated:YES];
    }
}

// 缩放时居中显示处理
- (void)showInCenter:(UIScrollView *)scrollView imageView:(UIImageView *)imageView
{
    // 居中显示
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - Action

- (void)backAction{

    //返回上一级视图
    UIViewController *viewCtl = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:viewCtl animated:YES];
}

@end
