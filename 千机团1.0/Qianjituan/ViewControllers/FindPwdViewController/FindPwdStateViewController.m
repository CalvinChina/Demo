//
//  FindPwdStateViewController.m
//  Qianjituan
//
//  Created by Pisen on 15/12/11.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "FindPwdStateViewController.h"

@implementation FindPwdStateViewController

//
@synthesize mFindPwdStateContainerView;

@synthesize mFindPwdStateImageView;

@synthesize mFindPwdStateLabel;

@synthesize mFindPwdStateContentTextView;

@synthesize mGoLoginActionBtn;

@synthesize mRepeatFindPwdActionBtn;

@synthesize mBackBtn;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) initComponents
{
    //
    mGoLoginActionBtn.hidden = YES;
    
    mGoLoginActionBtn.layer.masksToBounds = YES;
    
    mGoLoginActionBtn.layer.cornerRadius = 20;
    
    mGoLoginActionBtn.layer.borderWidth = 1.0;
    
    mGoLoginActionBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //
    mRepeatFindPwdActionBtn.hidden = YES;
    
    mRepeatFindPwdActionBtn.layer.masksToBounds = YES;
    
    mRepeatFindPwdActionBtn.layer.cornerRadius = 20;
    
    mRepeatFindPwdActionBtn.layer.borderWidth = 1.0;
    
    mRepeatFindPwdActionBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //
    if(self.mIsFindPwdSuccess)
    {
        mGoLoginActionBtn.hidden = NO;
        
        [mFindPwdStateImageView setImage: [UIImage imageNamed: @"Success-.png"]];
        
        mFindPwdStateLabel.textColor =
        [UIColor colorWithRed: 94.0f / 255.0f
                        green: 165.0f / 255.0f
                         blue: 2.0f / 255.0f
                        alpha: 1.0f];
        
        mFindPwdStateLabel.text = @"您的密码重置成功！";
    }
    else
    {
        mRepeatFindPwdActionBtn.hidden = NO;
        
        [mFindPwdStateImageView setImage: [UIImage imageNamed: @"Failure-.png"]];
        
        mFindPwdStateLabel.textColor =
        [UIColor colorWithRed: 251.0f / 255.0f
                         green: 132.0f / 255.0f
                          blue: 51.0f / 255.0f
                         alpha: 1.0f];
        
        mFindPwdStateLabel.text = @"您的密码重置失败！";
    }
    
    mFindPwdStateContentTextView.text = self.mFindPwdStateContent;
}

- (void) enterLoginController
{
    CATransition *animation = [CATransition animation];
    
    animation.duration = 1.0;
    
    animation.type = kCATransitionFade;
    
    animation.subtype = kCATransitionFromTop;
    
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [self.view.window.layer addAnimation: animation
                                  forKey: @"animation"];
    
    //
    LoginViewController* viewController = [[LoginViewController alloc] init];
    viewController.mIsFromMain=YES;
    viewController.mOnLoginSuccessDelegate=self.mOnLoginSuccessDelegate;
    [self.navigationController pushViewController:viewController animated:YES];
//    UINavigationController* naviC =
//    [[UINavigationController alloc] initWithRootViewController: viewController];
//    
//    self.view.window.rootViewController = naviC;
}

#pragma mark touch event handle start

- (IBAction) onTitleBackBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) onGoLoginBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    [self enterLoginController];
}

- (IBAction) onRepeatFindPwdBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    [self onTitleBackBtnClick: nil];
}

@end