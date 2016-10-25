//
//  RegisterResultViewController.m
//  Qianjituan
//
//  Created by Pisen on 15/12/9.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "RegisterResultViewController.h"
#import <CommonCrypto/CommonDigest.h>
@implementation RegisterResultViewController{
    NSInteger CountDownToMain;
}

//
@synthesize mRegisterStateContainerView;

@synthesize mRegisterStateImageView;

@synthesize mRegisterStateLabel;

@synthesize mRegisterStateContentTextView;

@synthesize mGoMainPageActionBtn;

@synthesize mRepeatRegisterActionBtn;

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
    mGoMainPageActionBtn.hidden = YES;
    
    mGoMainPageActionBtn.layer.masksToBounds = YES;
    
    mGoMainPageActionBtn.layer.cornerRadius = 20;
    
    mGoMainPageActionBtn.layer.borderWidth = 1.0;
    
    mGoMainPageActionBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //
    mRepeatRegisterActionBtn.hidden = YES;
    
    mRepeatRegisterActionBtn.layer.masksToBounds = YES;
    
    mRepeatRegisterActionBtn.layer.cornerRadius = 20;
    
    mRepeatRegisterActionBtn.layer.borderWidth = 1.0;
    
    mRepeatRegisterActionBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //
    if(self.mIsRegisterSuccess)
    {
        [mRegisterStateImageView setImage: [UIImage imageNamed: @"Success-.png"]];
        
        mRegisterStateLabel.textColor =
        [UIColor colorWithRed: 94.0f / 255.0f
                        green: 165.0f / 255.0f
                         blue: 2.0f / 255.0f
                        alpha: 1.0f];
        
        mRegisterStateLabel.text = @"恭喜您！注册成功";
        
        mRegisterStateContentTextView.text = @"5秒后会带你进入之前页面";
        CountDownToMain=5;
        
        mGoMainPageActionBtn.hidden = NO;
        
        [self startDelayEnterMainTimer];
    }
    else
    {
        [mRegisterStateImageView setImage: [UIImage imageNamed: @"Failure-.png"]];
        
        mRegisterStateLabel.textColor =
        [UIColor colorWithRed: 251.0f / 255.0f
                        green: 132.0f / 255.0f
                         blue: 51.0f / 255.0f
                        alpha: 1.0f];
        
        mRegisterStateLabel.text = @"哎哟！！注册失败";
        
        mRegisterStateContentTextView.text = self.mRegisterStateContent;
        
        mRepeatRegisterActionBtn.hidden = NO;
    }
}

-(void) startDelayEnterMainTimer
{
    if(mDelayEnterMainTimer != nil)
    {
        [mDelayEnterMainTimer invalidate];
        
        mDelayEnterMainTimer = nil;
    }
    
    //
    mDelayEnterMainTimer =
    [NSTimer scheduledTimerWithTimeInterval: 1
                                     target: self
                                   selector: @selector(onDismissTimerTick)
                                   userInfo: nil
                                    repeats: YES];
    
    [[NSRunLoop currentRunLoop] addTimer: mDelayEnterMainTimer
                                 forMode: NSDefaultRunLoopMode];
}

- (void) onDismissTimerTick
{
    CountDownToMain--;
    
    if (CountDownToMain<=0) {
         [self enterMainController];
       
    }
   mRegisterStateContentTextView.text =[NSString stringWithFormat:@"%ld秒后会带你进入之前页面",(long)CountDownToMain];
}

- (void) enterMainController

{
    if(mDelayEnterMainTimer != nil)
    {
        [mDelayEnterMainTimer invalidate];
        
        mDelayEnterMainTimer = nil;
    }
    AppDelegate*  appDelegate = [UIApplication sharedApplication].delegate;
    CATransition *animation = [CATransition animation];
    
    animation.duration = 1.0;
    
    animation.type = kCATransitionFade;
    
    animation.subtype = kCATransitionFromTop;
    
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [self.view.window.layer addAnimation: animation
                                  forKey: @"animation"];
    if (self.mOnLoginSuccessDelegate!=nil) {
    [self.mOnLoginSuccessDelegate onLoginSucceeded: _account
                                          password: _seAccount];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
     QianjituanViewController* viewController = [[QianjituanViewController alloc] init];

    UINavigationController* naviC =
    [[UINavigationController alloc] initWithRootViewController: viewController];
     viewController.mIsNeedInjectLoginData = YES;
    viewController.account=_account;
    viewController.isBack=YES;
    appDelegate.window.rootViewController = naviC;
    }
    
}

#pragma mark touch event handle start

- (IBAction) onTitleBackBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) onGoMainPageBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    if(mDelayEnterMainTimer != nil)
    {
        [mDelayEnterMainTimer invalidate];
        
        mDelayEnterMainTimer = nil;
    }
    
    [self enterMainController];
}

- (IBAction) onRepeatRegisterBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    RegisterViewController* viewController =
    [[RegisterViewController alloc] init];
    
    //
    UINavigationController* naviC = self.navigationController;
    
    [naviC pushViewController: viewController
                     animated: YES];
}
- (NSString*) getMD5WithData: (NSString*)source
{
    
    if(source == nil)
    {
        return nil;
    }
    
    const char* sourceStr = [source UTF8String];
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(sourceStr, strlen(sourceStr), digist);
    
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity: CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [outPutStr appendFormat: @"%02x",digist[i]];
    }
    
    return [outPutStr lowercaseString];
    
}
@end
