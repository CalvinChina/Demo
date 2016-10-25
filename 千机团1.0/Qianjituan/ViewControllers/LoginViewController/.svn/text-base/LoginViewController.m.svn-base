//
//  LoginViewController.m
//  Qianjituan
//
//  Created by ios-mac on 15/9/15.
//  Copyright (c) 2015年 ios-mac. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

@synthesize mMovableView;

//
@synthesize mBackBtn;

//
@synthesize mInputContainerView;

//
@synthesize mAccountInputContainerView;
@synthesize mAccountTextField;

//
@synthesize mPasswordInputContainerView;
@synthesize mPasswordTextField;

//
@synthesize mVerifyContainerView;
@synthesize mVerifyCodeInputTextField;
@synthesize mVerifyCodeLabel;
@synthesize mRefreshVerifyBtn;

//
@synthesize mActionBtnContainerView;
@synthesize mLoginBtn;
@synthesize mRegisterBtn;
@synthesize mForgetPasswordBtn;

@synthesize mNoticeContainerView;
@synthesize mNoticeBgView;
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

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent
                                                animated: NO];
    
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    //
    if(appDelegate.mLoginFailCounter < 3)
    {
        if(!mVerifyContainerView.isHidden)
        {
            mInputContainerView.frame =
            CGRectMake(
                       mInputContainerView.frame.origin.x,
                       mInputContainerView.frame.origin.y,
                       mInputContainerView.frame.size.width,
                       mInputContainerView.frame.size.height - mVerifyContainerView.frame.size.height);
            
            mActionBtnContainerView.frame =
            CGRectMake(
                       mActionBtnContainerView.frame.origin.x,
                       mActionBtnContainerView.frame.origin.y - mVerifyContainerView.frame.size.height,
                       mActionBtnContainerView.frame.size.width,
                       mActionBtnContainerView.frame.size.height);
            
            mVerifyContainerView.hidden = YES;
        }
    }
    else
    {
        if(mVerifyContainerView.isHidden)
        {
            mInputContainerView.frame =
            CGRectMake(
                       mInputContainerView.frame.origin.x,
                       mInputContainerView.frame.origin.y,
                       mInputContainerView.frame.size.width,
                       mInputContainerView.frame.size.height + mVerifyContainerView.frame.size.height);
            
            mActionBtnContainerView.frame =
            CGRectMake(
                       mActionBtnContainerView.frame.origin.x,
                       mActionBtnContainerView.frame.origin.y + mVerifyContainerView.frame.size.height,
                       mActionBtnContainerView.frame.size.width,
                       mActionBtnContainerView.frame.size.height);
            
            mVerifyContainerView.hidden = NO;
        }
        
        [self doGetVerifyCodeAction];
    }
}

- (void) initComponents
{
    //calculate login fail count to figur if display verify code view
    mLoginFailCounterDefaults = [NSUserDefaults standardUserDefaults];
    
    //
    mLoginBtn.layer.masksToBounds = YES;
    
    mLoginBtn.layer.cornerRadius = 20;
    
    mLoginBtn.layer.borderWidth = 1.0;
    
    mLoginBtn.layer.borderColor = [[UIColor clearColor] CGColor];
    
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
    mAccountTextField.delegate = self;
    
    mPasswordTextField.delegate = self;
    
    mVerifyCodeInputTextField.delegate = self;
    
    //keyboard type
    mAccountTextField.keyboardType = UIKeyboardTypePhonePad;
    
    mAccountTextField.returnKeyType = UIReturnKeyDone;
    
    //
    mPasswordTextField.secureTextEntry = YES;
    
    mPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    mPasswordTextField.returnKeyType = UIReturnKeyDone;
    
    //
    mVerifyCodeInputTextField.keyboardType = UIKeyboardTypeDefault;
    
    mVerifyCodeInputTextField.returnKeyType = UIReturnKeyDone;
    
    //
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onKeyboardShow)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onKeyboardHide)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
    
    //init user database
    mUserDataDBManager = [UserDataDBManager getInstance];
    
    NSString* latestUsedAccount = [mUserDataDBManager readLatestUsedAccount];
    
    if(latestUsedAccount != nil &&
       latestUsedAccount.length > 0)
    {
        //set last online account for primary login
        mAccountTextField.text = latestUsedAccount;
    }
    
    //
    mNetworkManager = [NetworkManager shareInstance];
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
#pragma mark- 登录验证
- (void) doLoginAction
{
    NSString* verifyKey = @"";
    
    NSString* verifyCode = @"";
    
    if(!mVerifyContainerView.isHidden)
    {
        verifyKey = mVerifyKey;
        
        verifyCode = mVerifyCode;
    }
    //获取手机号
    NSString *phone = mAccountTextField.text;
    NSString *passwordOri = mPasswordTextField.text;
    
    //loading animation
    mLoadingViewContainer.hidden = NO;
    
    [mLoadingImageView startAnimating];
    [mNetworkManager appCustomerOffset:^(NSDictionary *returnDict1) {
        if (!returnDict1) {
            
            [mLoadingImageView stopAnimating];
            
            return;
        }
        //       if(![returnDict1[@"IsError"] boolValue]){
        //           if (![returnDict1[@"IsSuccess"] boolValue]) {
        //               [mLoadingImageView stopAnimating];
        //               mNoticeContainerView.hidden = NO;
        //               mNoticeLabel.text = @"用户名或密码错误";
        //               [self startDelayDismissNoticeTimer];
        //               return;
        //           }
        //
        //       }
        
        if ([mNetworkManager isSOANormalSuccess:returnDict1]) {
            // 获取偏移量成功
            NSString *offsetStr = returnDict1[@"Offset"];
            NSString *encryptPasswd = [common md5OfString:passwordOri offsetStr:offsetStr];
            NSString *sendPwdStr = [NSString stringWithFormat:@"%@:%@", encryptPasswd, offsetStr];
            [mNetworkManager appLogin: ^(NSDictionary* returnDict)
             {
                 //stop loading animation
                 [mLoadingImageView stopAnimating];
                  
                 mLoadingViewContainer.hidden = YES;
                 
                 if(returnDict == nil)
                 {
                     return;
                 }
                 
                 Boolean result = [[returnDict objectForKey: @"IsSuccess"] boolValue];
                 
                 NSString* resultMessage = returnDict[@"ErrMsg"];
                 
                 AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
                 
                 if(!result)
                 {
                     appDelegate.mLoginFailCounter++;
                     
                     if(appDelegate.mLoginFailCounter >= 3 &&
                        mVerifyContainerView.isHidden)
                     {
                         mVerifyContainerView.hidden = NO;
                         
                         mInputContainerView.frame =
                         CGRectMake(
                                    mInputContainerView.frame.origin.x,
                                    mInputContainerView.frame.origin.y,
                                    mInputContainerView.frame.size.width,
                                    mInputContainerView.frame.size.height + mVerifyContainerView.frame.size.height);
                         
                         mActionBtnContainerView.frame =
                         CGRectMake(
                                    mActionBtnContainerView.frame.origin.x,
                                    mActionBtnContainerView.frame.origin.y + mVerifyContainerView.frame.size.height,
                                    mActionBtnContainerView.frame.size.width,
                                    mActionBtnContainerView.frame.size.height);
                         
                         [self doGetVerifyCodeAction];
                     }
                     
                     mPasswordTextField.text = @"";
                     
                     mVerifyCodeInputTextField.text = @"";
                     
                     //
                     mNoticeContainerView.hidden = NO;
                     
                     if(resultMessage != nil &&
                        resultMessage.length > 0)
                     {
                         mNoticeLabel.text = @"用户名或密码错误";
                         [self startDelayDismissNoticeTimer];
                         return;
                     }else
                     {
                         mNoticeLabel.text = @"登录失败";
                         [self startDelayDismissNoticeTimer];
                         return;
                         
                     }
                     
                     
                     
                     if(self.mOnLoginSuccessDelegate != nil)
                     {
                         [self.mOnLoginSuccessDelegate onLoginSucceeded: nil
                                                               password: nil];
                     }
                     
                     return;
                 }
                 
                 if(!mVerifyContainerView.isHidden)
                 {
                     mVerifyContainerView.hidden = YES;
                     
                     mInputContainerView.frame =
                     CGRectMake(
                                mInputContainerView.frame.origin.x,
                                mInputContainerView.frame.origin.y,
                                mInputContainerView.frame.size.width,
                                mInputContainerView.frame.size.height - mVerifyContainerView.frame.size.height);
                     
                     mActionBtnContainerView.frame =
                     CGRectMake(
                                mActionBtnContainerView.frame.origin.x,
                                mActionBtnContainerView.frame.origin.y - mVerifyContainerView.frame.size.height,
                                mActionBtnContainerView.frame.size.width,
                                mActionBtnContainerView.frame.size.height);
                 }
                 
                 //reset login fail counter
                 appDelegate.mLoginFailCounter = 0;
                 
                 //reset last online user
                 [mUserDataDBManager resetLastOnlineUser];
                 
                 //
                 mCurrentUserData = [[UserData alloc] init];
                 
                 mCurrentUserData->account = [[NSString alloc] initWithString: mAccountTextField.text];
                 
                 mCurrentUserData->password = [[NSString alloc] initWithString: mPasswordTextField.text];
                 
                 //
                 mCurrentUserData->nickName = [returnDict objectForKey: @"NickName"];
                 
                 //
                 if(mCurrentUserData->nickName == [NSNull null])
                 {
                     mCurrentUserData->nickName = @"";
                 }
                 
                 //
                 mCurrentUserData->sooId = [[returnDict objectForKey: @"sooId"] longValue];
                 
                 //
                 NSString* gender = [returnDict objectForKey: @"Gender"];
                 
                 if(gender != nil &&
                    gender.length > 0)
                 {
                     if([gender isEqualToString: @"男"])
                     {
                         mCurrentUserData->gender = 1;
                     }
                     else if([gender isEqualToString: @"女"])
                     {
                         mCurrentUserData->gender = 0;
                     }
                     else
                     {
                         mCurrentUserData->gender = 1;
                     }
                 }
                 else
                 {
                     mCurrentUserData->gender = 1;
                 }
                 
                 //
                 NSString* dateStr = [returnDict objectForKey: @"Birthday"];
                 
                 if(dateStr != nil &&
                    dateStr.length > 0)
                 {
                     NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                     
                     NSTimeZone* timeZone = [NSTimeZone localTimeZone];
                     
                     [dateFormatter setTimeZone:timeZone];
                     
                     [dateFormatter setDateFormat: @"YYYY-MM-dd"];
                     
                     NSDate* birthDate = [dateFormatter dateFromString: dateStr];
                     
                     mCurrentUserData->birthday = [birthDate timeIntervalSince1970];
                 }
                 
                 //
                 mCurrentUserData->avatarUrl = [returnDict objectForKey: @"HeadImage"];
                 
                 if(mCurrentUserData->avatarUrl == [NSNull null])
                 {
                     mCurrentUserData->avatarUrl = @"";
                 }
                 
                 //
                 mCurrentUserData->mailbox = [returnDict objectForKey: @"EmailAddress"];
                 
                 if(mCurrentUserData->mailbox == [NSNull null])
                 {
                     mCurrentUserData->mailbox = @"";
                 }
                 
                 //
                 mCurrentUserData->isOnline = YES;
                 
                 //update online user data
                 [mUserDataDBManager saveUserDataToDB: mCurrentUserData];
                 
                 //
                 if(self.mOnLoginSuccessDelegate != nil)
                 {
                     [self.mOnLoginSuccessDelegate onLoginSucceeded: mCurrentUserData->account
                                                           password: mCurrentUserData->password];
                 }
                 
                 if(self.mIsFromMain)
                 {
                     
                     [self.navigationController popToRootViewControllerAnimated: YES];
                 }
                 else
                 {
                     // 注册后登陆
                     CATransition *animation = [CATransition animation];
                     
                     animation.duration = 1.0;
                     
                     animation.type = kCATransitionFade;
                     
                     animation.subtype = kCATransitionFromTop;
                     
                     animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
                     
                     [self.view.window.layer addAnimation: animation
                                                   forKey: @"animation"];
                     
                     //
                     QianjituanViewController* viewController = [[QianjituanViewController alloc] init];
                     
                     viewController.mIsNeedInjectLoginData = YES;
                     
                     UINavigationController* naviC =
                     [[UINavigationController alloc] initWithRootViewController: viewController];
                     
                     self.view.window.rootViewController = naviC;
                 }
             }
                                phone: phone
                             password: sendPwdStr
                            verifyKey: verifyKey
                           verifyCode: verifyCode
                           needVerify: !mVerifyContainerView.isHidden
                              version:3
             ];
        } else {
            // 获取偏移量失败
            [mLoadingImageView stopAnimating];
            mLoadingViewContainer.hidden = YES;
            [self loginFailed:returnDict1];
            NSLog(@"[mNetworkManager isSOANormalSuccess:returnDict]=%d", [mNetworkManager isSOANormalSuccess:returnDict1]);
            mNoticeContainerView.hidden = NO;
            mNoticeLabel.text = @"登录失败";
            [self startDelayDismissNoticeTimer];
            return;
        }
        
    } phone:phone];
    
}

- (void) doGetVerifyCodeAction
{
    mVerifyCode = nil;
    
    mVerifyKey = nil;
    
    [mNetworkManager appGetImgVerifyCode: ^(NSDictionary* returnDict)
     {
         if(returnDict == nil)
         {
             return;
         }
         
         NSString* resultMessage = [returnDict objectForKey: @"Message"];
         
         if(resultMessage == nil ||
            [resultMessage rangeOfString: @"|"].location <= 0)
         {
             mNoticeContainerView.hidden = NO;
             
             mNoticeLabel.text = @"验证码获取失败!";
             
             [self startDelayDismissNoticeTimer];
             
             return;
         }
         
         NSArray* splitStrArray = [resultMessage componentsSeparatedByString: @"|"];
         
         if(splitStrArray == nil ||
            splitStrArray.count <= 1)
         {
             mNoticeContainerView.hidden = NO;
             
             mNoticeLabel.text = @"验证码获取失败!";
             
             [self startDelayDismissNoticeTimer];
             
             return;
         }
         
         mVerifyCode = splitStrArray[0];
         
         mVerifyKey = splitStrArray[1];
         
         mVerifyCodeLabel.text = mVerifyCode;
     }];
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
    else if(mAccountTextField.isEditing)
    {
        [mAccountTextField resignFirstResponder];
    }
    else if(mPasswordTextField.isEditing)
    {
        [mPasswordTextField resignFirstResponder];
    }
    else if(mVerifyCodeInputTextField.isEditing)
    {
        [mVerifyCodeInputTextField resignFirstResponder];
    }
}

- (IBAction) onBackBtn: (id)sender
{
    if(self.mOnLoginSuccessDelegate != nil)
    {
        [self.mOnLoginSuccessDelegate onLoginSucceeded: nil
                                              password: nil];
    }
    
    
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) onRefreshVerifyCodeBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    [self doGetVerifyCodeAction];
}

- (IBAction) onLoginBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    if(mAccountTextField.text == nil ||
       mAccountTextField.text.length <= 0)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"手机号码不能为空!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    NSString* phoneNum = mAccountTextField.text;
    
    Boolean isPhoneNumIllegal = [self isValidateMobile: phoneNum];
    
    if(!isPhoneNumIllegal)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"不支持该号段手机号码!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    if(mPasswordTextField.text == nil ||
       mPasswordTextField.text.length <= 0)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"密码不能为空!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    if(mPasswordTextField.text.length < 6)
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"密码不能少于6位!";
        
        [self startDelayDismissNoticeTimer];
        
        return;
    }
    
    if(!mVerifyContainerView.isHidden)
    {
        if(mVerifyCodeInputTextField.text == nil ||
           mVerifyCodeInputTextField.text.length <= 0)
        {
            mNoticeContainerView.hidden = NO;
            
            mNoticeLabel.text = @"验证码不能为空!";
            
            [self startDelayDismissNoticeTimer];
            
            return;
        }
        else
        {
            if(mVerifyCode == nil ||
               mVerifyKey == nil ||
               mVerifyCode.length <= 0 ||
               mVerifyKey.length <= 0)
            {
                mNoticeContainerView.hidden = NO;
                
                mNoticeLabel.text = @"验证码正在获取中，请稍后再试!";
                
                [self startDelayDismissNoticeTimer];
                
                return;
            }
            
            //
            NSString* inputedVerifyCodeStr = mVerifyCodeInputTextField.text;
            
            NSString* fetchedVerifyCodeStr = mVerifyCode;
            
            inputedVerifyCodeStr = [inputedVerifyCodeStr lowercaseString];
            
            fetchedVerifyCodeStr = [fetchedVerifyCodeStr lowercaseString];
            
            if(![inputedVerifyCodeStr isEqualToString: fetchedVerifyCodeStr])
            {
                mNoticeContainerView.hidden = NO;
                
                mNoticeLabel.text = @"验证码不匹配，请重新输入!";
                
                [self startDelayDismissNoticeTimer];
                
                return;
            }
        }
    }
    
    [self doLoginAction];
}

- (IBAction) onRegisterBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    RegisterViewController* registerController = [[RegisterViewController alloc] init];
    
    //
    registerController.mInputedPhoneNum = mAccountTextField.text;
    //wlg========代理成功回调传递，填坑
    registerController.mOnLoginSuccessDelegate=self.mOnLoginSuccessDelegate;
    //====
    UINavigationController* naviC = self.navigationController;
    
    [naviC pushViewController: registerController animated: YES];
}

- (IBAction) onForgetPasswordBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    FindPwdViewController* findPwdController = [[FindPwdViewController alloc] init];
    
    //代理成功回调传递
    findPwdController.mPreAccount = mAccountTextField.text;
    
    //
    findPwdController.mOnLoginSuccessDelegate=self.mOnLoginSuccessDelegate;
    UINavigationController* naviC = self.navigationController;
    
    [naviC pushViewController: findPwdController animated: YES];
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
        
        //        mMovableView.frame =
        //        CGRectMake(
        //                   mMovableView.frame.origin.x,
        //                   mMovableView.frame.origin.y - 100,
        //                   mMovableView.frame.size.width,
        //                   mMovableView.frame.size.height);
    }
}

- (void) onKeyboardHide
{
    if(mIsKeyboardShowing)
    {
        mIsKeyboardShowing = NO;
        
        //        mMovableView.frame =
        //        CGRectMake(
        //                   mMovableView.frame.origin.x,
        //                   mMovableView.frame.origin.y + 100,
        //                   mMovableView.frame.size.width,
        //                   mMovableView.frame.size.height);
    }
}

- (void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    
}
//获取偏移量失败
- (void)loginFailed:(NSDictionary *)infoDic {
    
    NSString *tipsMessage = nil;
    
    if (!infoDic) {
        tipsMessage = NSLocalizedString(@"Login_failed", nil);
    } else if (infoDic[@"ErrCode"] && ![infoDic[@"ErrCode"] isEqual:[NSNull null]] && [infoDic[@"ErrCode"] intValue] == 401) {
        tipsMessage = NSLocalizedString(@"Wrong_name_password", nil);
    } else if (infoDic[@"ErrMsg"] && ![infoDic[@"ErrMsg"] isEqual:[NSNull null]]) {
        tipsMessage = infoDic[@"ErrMsg"];
    } else if (infoDic[@"Message"] && ![infoDic[@"Message"] isEqual:[NSNull null]]) {
        tipsMessage = infoDic[@"Message"];
    } else if (infoDic[@"DetailError"] && ![infoDic[@"DetailError"] isEqual:[NSNull null]]) {
        tipsMessage = infoDic[@"DetailError"];
    } else {
        tipsMessage = NSLocalizedString(@"Login_failed", nil);
    }
    NSLog(@"failed");
    
}
#pragma mark Table view delegate end

@end
