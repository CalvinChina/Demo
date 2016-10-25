//
//  FindPwdConfirmViewController.m
//  Qianjituan
//
//  Created by Pisen on 15/12/11.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "FindPwdConfirmViewController.h"

@implementation FindPwdConfirmViewController

@synthesize mFindPasswordContainerView;

@synthesize mFindPasswordInputContainerView;

@synthesize mFindPasswordPhoneLabel;

@synthesize mVerifyCodeInputTextfield;

@synthesize mSMSVerifyCodeFetchBtn;

@synthesize mInputPasswordTextfield;

@synthesize mShowPasswordBtn;

@synthesize mResetPasswordFinishBtn;

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
    mResetPasswordFinishBtn.layer.masksToBounds = YES;
    
    mResetPasswordFinishBtn.layer.cornerRadius = 20;
    
    mResetPasswordFinishBtn.layer.borderWidth = 1.0;
    
    mResetPasswordFinishBtn.layer.borderColor =[[UIColor clearColor] CGColor];
    
    //
    mResetPasswordFinishBtn.layer.masksToBounds = YES;
    
    mResetPasswordFinishBtn.layer.cornerRadius = 20;
    
    mResetPasswordFinishBtn.layer.borderWidth = 1.0;
    
    mResetPasswordFinishBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    
    //
    mSMSVerifyCodeFetchBtn.layer.masksToBounds = YES;
    
    mSMSVerifyCodeFetchBtn.layer.cornerRadius = 16;
    
    mSMSVerifyCodeFetchBtn.layer.borderWidth = 2.0;
    
    mSMSVerifyCodeFetchBtn.layer.borderColor =
    [[UIColor colorWithRed: 1.0f
                     green: 107.0f / 255.0f
                      blue: 41.0f / 255.0f
                     alpha: 1.0f] CGColor];
    
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
    
    mVerifyCodeInputTextfield.delegate = self;
    
    //keyboard type
    mVerifyCodeInputTextfield.keyboardType = UIKeyboardTypeDefault;
    
    mVerifyCodeInputTextfield.returnKeyType = UIReturnKeyDone;
    
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
    if(self.mPreAccount != nil)
    {
        mFindPasswordPhoneLabel.text = self.mPreAccount;
    }
    
    //
    mNetworkManager = [NetworkManager shareInstance];
    
    [self initVerifyCodeFetchingTimer];
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

-(void)initVerifyCodeFetchingTimer
{
    if(mVerifyCodeFetchingTimer != nil)
    {
        [mVerifyCodeFetchingTimer invalidate];
    }
    
    mVerifyCodeFetchingCounter = 90;
    
    [mSMSVerifyCodeFetchBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                            forState: UIControlStateNormal];
    
    [mSMSVerifyCodeFetchBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                            forState: UIControlStateHighlighted];
    
    [mSMSVerifyCodeFetchBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
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
        
        [mSMSVerifyCodeFetchBtn setTitle: @"重新发送验证码"
                                forState: UIControlStateNormal];
        
        return;
    }
    
    [mSMSVerifyCodeFetchBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                            forState: UIControlStateNormal];
    
    [mSMSVerifyCodeFetchBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
                            forState: UIControlStateHighlighted];
    
    [mSMSVerifyCodeFetchBtn setTitle: [NSString stringWithFormat: @"还剩下%d秒钟", mVerifyCodeFetchingCounter]
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
    else if(mInputPasswordTextfield.isEditing)
    {
        [mInputPasswordTextfield resignFirstResponder];
    }
    else if(mVerifyCodeInputTextfield.isEditing)
    {
        [mVerifyCodeInputTextfield resignFirstResponder];
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

- (IBAction) onFetchSMSVerifyCodeBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    if(mVerifyCodeFetchingTimer != nil)
    {
        return;
    }
    
    if(mFindPasswordPhoneLabel.text == nil ||
       mFindPasswordPhoneLabel.text.length <= 0)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"手机号码不能为空!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    NSString* phoneNum = mFindPasswordPhoneLabel.text;
    
    Boolean isPhoneNumIllegal = [self isValidateMobile: phoneNum];
    
    if(!isPhoneNumIllegal)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"不支持该号段手机号码!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    [self initVerifyCodeFetchingTimer];
    
    [mNetworkManager appSendValidateMsg: phoneNum
                                   type: 1
                                picCode: @""
                                 pickey: @""
                                  block: ^(NSDictionary* returnDict)
     {
         if(returnDict == nil)
         {
             [mSMSVerifyCodeFetchBtn setTitle: @"重新发送验证码"
                                     forState: UIControlStateNormal];
             
             mNoticeContainerView.hidden = NO;
             
             mNoticeLabel.text = @"短信验证码获取失败!";
             
             [self startDelayDismissNoticeTimer];
             
             return;
         }
         
         Boolean result = [[returnDict objectForKey: @"IsSuccess"] boolValue];
         
         //
         if(!result)
         {
             if(mVerifyCodeFetchingTimer != nil)
             {
                 [mVerifyCodeFetchingTimer invalidate];
                 
                 mVerifyCodeFetchingTimer = nil;
             }
             
             [mSMSVerifyCodeFetchBtn setTitle: @"重新发送验证码"
                                     forState: UIControlStateNormal];
             
             mNoticeContainerView.hidden = NO;
             
             mNoticeLabel.text = @"短信验证码获取失败!";
             
             [self startDelayDismissNoticeTimer];
         }
     }];
}
#pragma mark- 重置密码
- (IBAction) onResetPasswordFinishBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
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
    //验证码判断
    if(![self VerifyCodeJudgeMent:mVerifyCodeInputTextfield.text]){
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"验证码输入格式有误";
        
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
    
    //
    [mNetworkManager appPhoneCodeVerify: mFindPasswordPhoneLabel.text
                             verifyCode: mVerifyCodeInputTextfield.text
                                  block: ^(NSDictionary *returnDict)
     {
         //stop loading animation
         [mLoadingImageView stopAnimating];
         
         mLoadingViewContainer.hidden = YES;
         
         [mIndicator stopAnimating];
         
         Boolean result = [[returnDict objectForKey: @"IsSuccess"] boolValue];
         
         NSString* certificateID = [returnDict objectForKey: @"CertificateID"];
         
         NSString* resultMessage = [returnDict objectForKey: @"Message"];
         
         if(!result)
         {
             FindPwdStateViewController* viewController = [[FindPwdStateViewController alloc] init];
             
             if(returnDict == nil)
             {
                 viewController.mFindPwdStateContent = @"通讯失败";
             }
             
             if(resultMessage == nil ||
                resultMessage == [NSNull null] ||
                resultMessage.length <= 0)
             {
                 viewController.mFindPwdStateContent = @"通讯失败";
             }else{
                 viewController.mFindPwdStateContent = @"输入手机号验证码错误或已过期";
             }
             
             viewController.mIsFindPwdSuccess = NO;
             
             //login fail state reset
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             
             appDelegate.mLoginFailCounter = 0;
             
             //
             UINavigationController* naviC = self.navigationController;
             
             [naviC pushViewController: viewController
                              animated: YES];
             
             return;
         }
         //wlg=====
         //获取手机号
         NSString *phone = mFindPasswordPhoneLabel.text;
         NSString *passwordOri = mInputPasswordTextfield.text;
         
         //loading animation
         mLoadingViewContainer.hidden = NO;
         
         [mLoadingImageView startAnimating];
         [mNetworkManager appCustomerOffset:^(NSDictionary *returnDict) {
             if (!returnDict) {
                 
                 [mLoadingImageView stopAnimating];
                 
                 return;
             }
             if ([mNetworkManager isSOANormalSuccess:returnDict]) {
                 // 获取偏移量成功
                 NSString *offsetStr = returnDict[@"Offset"];
                 NSString *encryptPasswd = [common md5OfString:passwordOri offsetStr:offsetStr];
                 NSString *sendPwdStr = [NSString stringWithFormat:@"%@:%@", encryptPasswd, offsetStr];
                 
                 //=====
                 //重置密码====
                 [mNetworkManager appRestPassword:  ^(NSDictionary* returnDict)
                  {
                      //stop loading animation
                      [mLoadingImageView stopAnimating];
                      
                      mLoadingViewContainer.hidden = YES;
                      
                      [mIndicator stopAnimating];
                      
                      FindPwdStateViewController* viewController = [[FindPwdStateViewController alloc] init];
                      
                      if(returnDict == nil)
                      {
                          viewController.mFindPwdStateContent = @"通讯失败";
                      }
                      
                      Boolean result = [[returnDict objectForKey: @"IsSuccess"] boolValue];
                      
                      NSString* resultMessage = [returnDict objectForKey: @"Message"];
                      
                      if(!result)
                      {
                          if(resultMessage == nil ||
                             resultMessage == [NSNull null] ||
                             resultMessage.length <= 0)
                          {
                              viewController.mFindPwdStateContent = @"通讯失败";
                          }
                          
                          viewController.mIsFindPwdSuccess = NO;
                      }
                      else
                      {
                          viewController.mIsFindPwdSuccess = YES;
                      }
                      
                      if(resultMessage != nil &&
                         resultMessage != [NSNull null])
                      {
                          viewController.mFindPwdStateContent = resultMessage;
                      }
                      
                      //login fail state reset
                      AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                      
                      appDelegate.mLoginFailCounter = 0;
                      
                      //将注册成功的代理方法传入
                      viewController.mOnLoginSuccessDelegate=self.mOnLoginSuccessDelegate;
                      
                      
                      UINavigationController* naviC = self.navigationController;
                      
                      [naviC pushViewController: viewController
                                       animated: YES];
                  }
                                            phone: phone
                                           pwdNew: sendPwdStr
                                           pwdOld: @""
                                    certificateID: certificateID
                                       needUpdate: false
                                          version:3];
             }else {
                 // 获取偏移量失败
                 // [self loginFailed:returnDict];
                 NSLog(@"[mNetworkManager isSOANormalSuccess:returnDict]=%d", [mNetworkManager isSOANormalSuccess:returnDict]);
                 [mLoadingImageView stopAnimating];
                 return;
             }
             
         } phone:phone];
         
     }];
}

- (IBAction) onShowPwdBtnClick:(id)sender
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
#pragma mark-注册嘛判断
-(BOOL)VerifyCodeJudgeMent:(NSString *)mVerifyCode{
    BOOL success;
    NSLog(@"mFindPasswordPhoneLabel.text.length=%ld",mVerifyCode.length);
    if(mVerifyCode.length == 6){
        success=YES;
    }else{
        success=NO;
    }
    
    return success;
}
@end
