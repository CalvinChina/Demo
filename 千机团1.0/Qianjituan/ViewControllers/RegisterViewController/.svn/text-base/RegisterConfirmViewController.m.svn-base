//
//  RegisterConfirmViewController.m
//  Qianjituan
//
//  Created by Pisen on 15/12/9.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "RegisterConfirmViewController.h"

@interface RegisterConfirmViewController ()

@end

@implementation RegisterConfirmViewController

@synthesize mInputContainerView;

@synthesize mInputedPhoneNumLabel;

@synthesize mInputVerifyCodeTextfield;

@synthesize mRefreshVerifyCodeBtn;

@synthesize mInputPasswordTextfield;

@synthesize mShowPasswordBtn;

@synthesize mRegisterBtn;

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
    mRefreshVerifyCodeBtn.layer.masksToBounds = YES;
    
    mRefreshVerifyCodeBtn.layer.cornerRadius = 16;
    
    mRefreshVerifyCodeBtn.layer.borderWidth = 2.0;
    
    mRefreshVerifyCodeBtn.layer.borderColor =
    [[UIColor colorWithRed: 1.0f
                     green: 107.0f / 255.0f
                      blue: 41.0f / 255.0f
                     alpha: 1.0f] CGColor];
    
    //
    mRegisterBtn.layer.masksToBounds = YES;
    
    mRegisterBtn.layer.cornerRadius = 20;
    
    mRegisterBtn.layer.borderWidth = 1.0;
    
    mRegisterBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    
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
    mInputPasswordTextfield.delegate = self;
    
    //keyboard type
    mInputVerifyCodeTextfield.keyboardType = UIKeyboardTypeNumberPad;
    
    mInputVerifyCodeTextfield.returnKeyType = UIReturnKeyDone;
    
    //
    mInputPasswordTextfield.secureTextEntry = YES;
    
    mInputPasswordTextfield.keyboardType = UIKeyboardTypeASCIICapable;
    
    mInputPasswordTextfield.returnKeyType = UIReturnKeyDone;
    
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
    mInputedPhoneNumLabel.text = self.mInputedPhoneNum;
    
    //
    mNetworkManager = [NetworkManager shareInstance];
    
    mUserDataDBManager = [UserDataDBManager getInstance];
    
    //initilize fetch verify code
    if(mVerifyCodeFetchingTimer != nil)
    {
        [mVerifyCodeFetchingTimer invalidate];
        
        mVerifyCodeFetchingTimer = nil;
    }
    
    if(mInputedPhoneNumLabel.text == nil ||
       mInputedPhoneNumLabel.text.length <= 0)
    {
        UIAlertView* alertView =
        [[UIAlertView alloc]initWithTitle: nil
                                  message: @"手机号码不能为空!"
                                 delegate: nil
                        cancelButtonTitle: @"关闭"
                        otherButtonTitles: nil];
        
        [alertView show];
        
        return;
    }
    
    NSString* phoneNum = mInputedPhoneNumLabel.text;
    
    [self initVerifyCodeFetchingTimer];
    
    [mNetworkManager appSendValidateMsg: phoneNum
                                   type: 0
                                picCode: @""
                                 pickey: @""
                                  block: ^(NSDictionary* returnDict)
     {
         if(returnDict == nil)
         {
             return;
         }
         
         Boolean result = [[returnDict objectForKey: @"IsSuccess"] boolValue];
         
         NSString* resultMessage = [returnDict objectForKey: @"Message"];
         
         //
         if(!result)
         {
             //
             if(resultMessage != nil &&
                resultMessage != [NSNull null])
             {
                 mNoticeContainerView.hidden = NO;
                 
                 mNoticeLabel.text = resultMessage;
                 
                 [self startDelayDismissNoticeTimer];
             }
             else
             {
                 mNoticeContainerView.hidden = NO;
                 
                 mNoticeLabel.text = @"获取验证码失败!";
                 
                 [self startDelayDismissNoticeTimer];
             }
             
             //
             if(mVerifyCodeFetchingTimer != nil)
             {
                 [mVerifyCodeFetchingTimer invalidate];
                 
                 mVerifyCodeFetchingTimer = nil;
             }
             
             [mRefreshVerifyCodeBtn setTitle: @"重新发送验证码"
                                    forState: UIControlStateNormal];
         }
     }];
}

-(void)initVerifyCodeFetchingTimer
{
    if(mVerifyCodeFetchingTimer != nil)
    {
        [mVerifyCodeFetchingTimer invalidate];
    }
    
    mVerifyCodeFetchingCounter = 90;
    
    [mRefreshVerifyCodeBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                           forState: UIControlStateNormal];
    
    [mRefreshVerifyCodeBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                           forState: UIControlStateHighlighted];
    
    [mRefreshVerifyCodeBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                           forState: UIControlStateDisabled];
    
    //
    mVerifyCodeFetchingTimer =
    [NSTimer scheduledTimerWithTimeInterval: 1
                                     target: self
                                   selector: @selector(onTimerTick)
                                   userInfo: nil
                                    repeats: YES];
    
    [[NSRunLoop currentRunLoop] addTimer: mVerifyCodeFetchingTimer
                                 forMode: NSDefaultRunLoopMode];
}

- (void) onTimerTick
{
    mVerifyCodeFetchingCounter--;
    
    if(mVerifyCodeFetchingCounter < 0)
    {
        if(mVerifyCodeFetchingTimer != nil)
        {
            [mVerifyCodeFetchingTimer invalidate];
            
            mVerifyCodeFetchingTimer = nil;
        }
        
        [mRefreshVerifyCodeBtn setTitle: @"重新发送验证码"
                               forState: UIControlStateNormal];
        
        return;
    }
    
    [mRefreshVerifyCodeBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                           forState: UIControlStateNormal];
    
    [mRefreshVerifyCodeBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                           forState: UIControlStateHighlighted];
    
    [mRefreshVerifyCodeBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                           forState: UIControlStateDisabled];
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
                                   selector: @selector(onDismissTimerTick)
                                   userInfo: nil
                                    repeats: NO];
    
    [[NSRunLoop currentRunLoop] addTimer: mDelayDismissNoticeTimer
                                 forMode: NSDefaultRunLoopMode];
}

- (void) onDismissTimerTick
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
    else if(mInputVerifyCodeTextfield.isEditing)
    {
        [mInputVerifyCodeTextfield resignFirstResponder];
    }
    else if(mInputPasswordTextfield.isEditing)
    {
        [mInputPasswordTextfield resignFirstResponder];
    }
}

- (IBAction) onRefreshVerifyCodeBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    if(mVerifyCodeFetchingTimer != nil)
    {
        return;
    }
    
    if(mInputedPhoneNumLabel.text == nil ||
       mInputedPhoneNumLabel.text.length <= 0)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"手机号码不能为空!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    NSString* phoneNum = mInputedPhoneNumLabel.text;
    
    [self initVerifyCodeFetchingTimer];
    
    [mNetworkManager appSendValidateMsg: phoneNum
                                   type: 0
                                picCode: @""
                                 pickey: @""
                                  block: ^(NSDictionary* returnDict)
     {
         if(returnDict == nil)
         {
             return;
         }
         
         Boolean result = [[returnDict objectForKey: @"IsSuccess"] boolValue];
         
         NSString* resultMessage = [returnDict objectForKey: @"Message"];
         
         //
         if(!result)
         {
             //
             if(resultMessage != nil &&
                resultMessage != [NSNull null])
             {
                 mNoticeContainerView.hidden = NO;
                 
                 mNoticeLabel.text = resultMessage;
                 
                 [self startDelayDismissNoticeTimer];
             }
             else
             {
                 mNoticeContainerView.hidden = NO;
                 
                 mNoticeLabel.text = @"获取验证码失败!";
                 
                 [self startDelayDismissNoticeTimer];
             }
             
             //
             if(mVerifyCodeFetchingTimer != nil)
             {
                 [mVerifyCodeFetchingTimer invalidate];
                 
                 mVerifyCodeFetchingTimer = nil;
             }
             
             [mRefreshVerifyCodeBtn setTitle: @"重新发送验证码"
                                    forState: UIControlStateNormal];
         }
     }];
}

- (IBAction) onShowPasswordBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    if(mInputPasswordTextfield.isSecureTextEntry)
    {
        [mShowPasswordBtn setImage: [UIImage imageNamed: @"look-.png"]
                          forState: UIControlStateNormal];
        
        [mShowPasswordBtn setImage: [UIImage imageNamed: @"look-.png"]
                          forState: UIControlStateHighlighted];
        
        mInputPasswordTextfield.secureTextEntry = NO;
    }
    else
    {
        [mShowPasswordBtn setImage: [UIImage imageNamed: @"Close-.png"]
                          forState: UIControlStateNormal];
        
        [mShowPasswordBtn setImage: [UIImage imageNamed: @"Close-.png"]
                          forState: UIControlStateHighlighted];
        
        mInputPasswordTextfield.secureTextEntry = YES;
    }
}

- (IBAction) onTitleBackBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
    
    if(mVerifyCodeFetchingTimer != nil)
    {
        [mVerifyCodeFetchingTimer invalidate];
        
        mVerifyCodeFetchingTimer = nil;
    }
}
#pragma mark-注册
- (IBAction) onRegisterBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    if(mInputedPhoneNumLabel.text == nil ||
       mInputedPhoneNumLabel.text.length <= 0)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"手机号码不能为空!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    NSString* phoneNum = mInputedPhoneNumLabel.text;
    
    if(mInputVerifyCodeTextfield.text == nil ||
       mInputVerifyCodeTextfield.text.length <= 0)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"短信验证码不能为空!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    if(mInputPasswordTextfield.text == nil ||
       mInputPasswordTextfield.text.length <= 0)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"密码不能为空!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    if(mInputPasswordTextfield.text.length < 6)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"密码不能少于6位!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    if(mInputPasswordTextfield.text.length > 20)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"密码不能超过20位，请修改后重试!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    //
    if(mVerifyCodeFetchingTimer != nil)
    {
        [mVerifyCodeFetchingTimer invalidate];
        
        mVerifyCodeFetchingTimer = nil;
    }
    
    //
    if(mVerifyCodeFetchingTimer != nil)
    {
        [mVerifyCodeFetchingTimer invalidate];
        
        mVerifyCodeFetchingTimer = nil;
    }
    
    [mRefreshVerifyCodeBtn setTitle: @"重新发送验证码"
                           forState: UIControlStateNormal];
    
    //
    mIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    mIndicator.tag = 103;
    
    mIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    mIndicator.backgroundColor = [UIColor blackColor];
    
    mIndicator.alpha = 0.5;
    
    mIndicator.layer.cornerRadius = 6;
    mIndicator.layer.masksToBounds = YES;
    
    [mIndicator setCenter:CGPointMake(
                                      self.view.frame.size.width / 2.0,
                                      self.view.frame.size.height / 3.0)];
    
    [mIndicator startAnimating];
    
    [self.view addSubview: mIndicator];
    
    //loading animation
    mLoadingViewContainer.hidden = NO;
    
    [mLoadingImageView startAnimating];
    //获取手机号
    NSString *phone = mInputedPhoneNumLabel.text;
    NSString *passwordOri = mInputPasswordTextfield.text;
    // 获取偏移量
    NSString *offsetStr =[common catchStringByRandom];
    NSString *encryptPasswd = [common md5OfString:passwordOri offsetStr:offsetStr];
    NSString *sendPwdStr = [NSString stringWithFormat:@"%@:%@", encryptPasswd, offsetStr];
    //注册
    [mNetworkManager appRegister:^(NSDictionary* returnDict)
     {
         //stop loading animation
         [mLoadingImageView stopAnimating];
         
         mLoadingViewContainer.hidden = YES;
         
         [mIndicator stopAnimating];
         
         if(returnDict == nil)
         {
             return;
         }
         
         Boolean result = [[returnDict objectForKey: @"IsSuccess"] boolValue];
         
         NSString* resultMessage = [returnDict objectForKey: @"Message"];
         
         //
         if(!result)
         {
             mInputVerifyCodeTextfield.text = @"";
             
             mInputPasswordTextfield.text = @"";
             
             //jump to register state view
             RegisterResultViewController* viewController =
             [[RegisterResultViewController alloc] init];
             
             //
             viewController.mIsRegisterSuccess = NO;
             
             viewController.mRegisterStateContent = resultMessage;
             
             //
             UINavigationController* naviC = self.navigationController;
             
             [naviC pushViewController: viewController
                              animated: YES];
             
             return;
         }
         
         //
         UserData* userData = [[UserData alloc] init];
         
         userData->account = [[NSString alloc] initWithString: mInputedPhoneNumLabel.text];
         
         userData->password = [[NSString alloc] initWithString: mInputPasswordTextfield.text];
         
         userData->isOnline = YES;
         
         [mUserDataDBManager saveUserDataToDB: userData];
         
         //jump to register state view
         RegisterResultViewController* viewController =
         [[RegisterResultViewController alloc] init];
         //wlg=========
         viewController.mOnLoginSuccessDelegate=self.mOnLoginSuccessDelegate;
         //=======
         viewController.mIsRegisterSuccess = YES;
         
         //
         viewController.account=phone;
         viewController.seAccount=mInputPasswordTextfield.text;
         UINavigationController* naviC = self.navigationController;
         
         [naviC pushViewController: viewController
                          animated: YES];
     }
                           phone: phone
                             key: sendPwdStr
                            code: mInputVerifyCodeTextfield.text
                         version:3];
    
    
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
    if(!mIsKeyboardShowing)
    {
        mIsKeyboardShowing = YES;
    }
}

- (void) onKeyboardHide
{
    if(mIsKeyboardShowing)
    {
        mIsKeyboardShowing = NO;
    }
}

@end
