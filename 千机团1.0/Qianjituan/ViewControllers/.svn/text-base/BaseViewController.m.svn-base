//
//  BaseViewController.m
//  Qianjituan
//
//  Created by ios-mac on 15/9/16.
//  Copyright (c) 2015年 ios-mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIButton *leftBtn;
    UIButton *rightBtn;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initRightBarButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initQianjituanNavBack
{
    self.navigationController.navigationBar.barTintColor = [common rgbColor:"491972" alpha:1.0];
    NSDictionary *dict = @{UITextAttributeTextColor : [UIColor whiteColor],
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18.0]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)initNavBack
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary *dict = @{UITextAttributeTextColor : [common rgbColor:"333333" alpha:1.0],
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18.0]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)initLeftBarButton:(BOOL)bQianjituan
{
    leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];

    if (bQianjituan)
    {
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [leftBtn setTitleColor:[common rgbColor:"666666" alpha:1.0] forState:UIControlStateNormal];
    }
    
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [leftBtn addTarget:self action:@selector(onLeftClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = menuBtn;
}

- (void)initRightBarButton
{
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [rightBtn setImage:[UIImage imageNamed:@"ico_menu"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(onRightClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = menuBtn;
}

- (void)setRightBtnTitle:(NSString *)title
{
    [rightBtn setTitle:title forState:UIControlStateNormal];
}

- (void)setLeftBtnTitle:(NSString *)title
{
    [leftBtn setTitle:title forState:UIControlStateNormal];
    
    [leftBtn setImage: [UIImage imageNamed: @"ico_back.png"]
             forState: UIControlStateNormal];
    
    [leftBtn setImage: [UIImage imageNamed: @"ico_back.png"]
             forState: UIControlStateHighlighted];
}

- (void)onRightClicked:(id)sender
{
    
}

- (void)hideRightNavBtn
{
    rightBtn.hidden = YES;
}

- (void)showRightNavBtn
{
    rightBtn.hidden = NO;
}

- (void)onLeftClicked:(id)sender
{
    
}

- (void)hideLeftNavBtn
{
    leftBtn.hidden = YES;
}

- (void)showLeftNavBtn
{
    leftBtn.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
