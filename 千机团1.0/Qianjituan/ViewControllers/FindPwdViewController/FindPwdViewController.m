//
//  FindPwdViewController.m
//  Qianjituan
//
//  Created by zengbixing on 15/9/23.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "FindPwdViewController.h"

@implementation FindPwdViewController

@synthesize mFindPasswordContainerView;

@synthesize mFindPasswordInputContainerView;

@synthesize mFindPasswordPhoneTextField;

@synthesize mFindPasswordNextBtn;

//
@synthesize mTitleLabel;

@synthesize mBackBtn;

@synthesize mNoticeContainerView;

@synthesize  mNoticeBgView;

@synthesize mNoticeLabel;

//
@synthesize mLoadingViewContainer;
@synthesize mLoadingImageView;

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
    mFindPasswordNextBtn.layer.masksToBounds = YES;
    
    mFindPasswordNextBtn.layer.cornerRadius = 20;
    
    mFindPasswordNextBtn.layer.borderWidth = 1.0;
    
    mFindPasswordNextBtn.layer.borderColor =[[UIColor clearColor] CGColor];
    
    //
    mNoticeContainerView.hidden = YES;
    
    mNoticeBgView.layer.masksToBounds = YES;
    
    mNoticeBgView.layer.cornerRadius = 25;
    
    mNoticeBgView.layer.borderWidth = 1.0;
    
    mNoticeBgView.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //
    mLoadingViewContainer.hidden = YES;
    
    NSArray* gifArray = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"1"],
                         [UIImage imageNamed:@"2"],
                         [UIImage imageNamed:@"3"],
                         [UIImage imageNamed:@"4"],
                         [UIImage imageNamed:@"5"],
                         [UIImage imageNamed:@"6"],
                         [UIImage imageNamed:@"7"],
                         [UIImage imageNamed:@"8"],
                         [UIImage imageNamed:@"9"],
                         [UIImage imageNamed:@"10"],
                         [UIImage imageNamed:@"11"],
                         [UIImage imageNamed:@"12"],
                         [UIImage imageNamed:@"13"],
                         [UIImage imageNamed:@"14"],
                         [UIImage imageNamed:@"15"],
                         nil];
    
    mLoadingImageView.animationImages = gifArray;
    
    mLoadingImageView.animationDuration = 2;
    
    mLoadingImageView.animationRepeatCount = 0;
    
    //
    mFindPasswordPhoneTextField.delegate = self;
    
    //keyboard type
    mFindPasswordPhoneTextField.keyboardType = UIKeyboardTypePhonePad;
    
    mFindPasswordPhoneTextField.returnKeyType = UIReturnKeyDone;
    
    //
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onKeyboardShow)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onKeyboardHide)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
    
    //
    if(self.mPreAccount != nil)
    {
        mFindPasswordPhoneTextField.text = self.mPreAccount;
    }
}

/**
 *  正则判断手机号是否合法
 *
 *  @param mobile 输入的手机号
 *
 *  @return yes为合法no为非法
 */
- (Boolean)isValidateMobile:(NSString*)mobile
{
    //手机号以13，15，18，17开头，八个 \d 数字字符
    NSString* phoneRegex = @"(13|14|15|18|17)\\d{9}";
    
    NSPredicate* phoneTest =
    [NSPredicate predicateWithFormat: @"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject: mobile];
}

-(void) startDelayDismissNoticeTimer
{
    if(mDelayDismissNoticeTimer != nil)
    {
        [mDelayDismissNoticeTimer invalidate];
        
        mDelayDismissNoticeTimer = nil;
    }
    
    //
    mDelayDismissNoticeTimer =
    [NSTimer scheduledTimerWithTimeInterval: 2
                                     target: self
                                   selector: @selector(onTimerTick)
                                   userInfo: nil
                                    repeats: NO];
    
    [[NSRunLoop currentRunLoop] addTimer: mDelayDismissNoticeTimer
                                 forMode: NSDefaultRunLoopMode];
}

- (void) onTimerTick
{
    mNoticeContainerView.hidden = YES;
}

#pragma mark touch event handle start

-(void)touchesBegan: (NSSet*)touches
          withEvent: (UIEvent*)event
{
    if(!mNoticeContainerView.isHidden)
    {
        mNoticeContainerView.hidden = YES;
        
        if(mDelayDismissNoticeTimer != nil)
        {
            [mDelayDismissNoticeTimer invalidate];
            
            mDelayDismissNoticeTimer = nil;
        }
    }
}

- (IBAction) onTitleBackBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) onNextBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    if(mFindPasswordPhoneTextField.text == nil ||
       mFindPasswordPhoneTextField.text.length <= 0)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"手机号码不能为空!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    NSString* phoneNum = mFindPasswordPhoneTextField.text;
    
    Boolean isPhoneNumIllegal = [self isValidateMobile: phoneNum];
    
    if(!isPhoneNumIllegal)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"不支持该号段手机号码!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    //
    
    //loading animation
    mLoadingViewContainer.hidden = NO;
    
    [mLoadingImageView startAnimating];
    
    NetworkManager* networkManager = [NetworkManager shareInstance];
    
    [networkManager appSendValidateMsg: phoneNum
                                   type: 1
                                picCode: @""
                                 pickey: @""
                                  block: ^(NSDictionary* returnDict)
     {
         //stop loading animation
         [mLoadingImageView stopAnimating];
         
         mLoadingViewContainer.hidden = YES;
         
         if(returnDict == nil)
         {
             mNoticeContainerView.hidden = NO;
             
             mNoticeLabel.text = @"短信验证码获取失败!";
             
             [self startDelayDismissNoticeTimer];
             
             return;
         }
         
         Boolean result = [[returnDict objectForKey: @"IsSuccess"] boolValue];
         
         //
         if(!result)
         {
             mNoticeContainerView.hidden = NO;
             
             mNoticeLabel.text = @"短信验证码获取失败!";
             
             [self startDelayDismissNoticeTimer];
             
             return;
         }
         
         //
         FindPwdConfirmViewController* viewController = [[FindPwdConfirmViewController alloc] init];
         
         viewController.mPreAccount = phoneNum;
         
         //
         viewController.mOnLoginSuccessDelegate=self.mOnLoginSuccessDelegate;
         
         UINavigationController* naviC = self.navigationController;
         
         [naviC pushViewController: viewController
                          animated: YES];
     }];
}

- (BOOL) textField:(UITextField*)textField
shouldChangeCharactersInRange: (NSRange)range
 replacementString: (NSString*)string
{
    if(string != nil &&
       [string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (IBAction) onTextFieldEditEnd:(id)sender
{
    
}

- (void) onKeyboardShow
{
}

- (void) onKeyboardHide
{
}

@end
