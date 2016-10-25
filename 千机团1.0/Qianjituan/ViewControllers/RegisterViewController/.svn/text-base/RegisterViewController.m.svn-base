//
//  RegisterViewController.m
//  Qianjituan
//
//  Created by zengbixing on 15/9/23.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

@synthesize mInputContainerView;

@synthesize mInputPhoneTextfield;

@synthesize mRegisterBtn;

@synthesize mRegisterProtocolBtn;

@synthesize mRegisterProtocolLabel;

@synthesize mBackBtn;

@synthesize mNoticeContainerView;

@synthesize  mNoticeBgView;

@synthesize mNoticeLabel;

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
    NSMutableAttributedString* registerProtocolText =
    [[NSMutableAttributedString alloc] initWithString: @"注册即视为同意千机团服务协议，系统将为您创建千机团账户。"];
    
    [registerProtocolText addAttribute: NSForegroundColorAttributeName
                                 value: [UIColor darkGrayColor]
                                 range: NSMakeRange(0, 7)];
    
    [registerProtocolText addAttribute: NSForegroundColorAttributeName
                                 value: [UIColor blueColor]
                                 range: NSMakeRange(7,7)];
    
    [registerProtocolText addAttribute: NSUnderlineStyleAttributeName
                                 value: [NSNumber numberWithInteger: NSUnderlineStyleSingle]
                                 range: NSMakeRange(7,7)];
    
    [registerProtocolText addAttribute: NSForegroundColorAttributeName
                                 value: [UIColor darkGrayColor]
                                 range: NSMakeRange(14,14)];
    
    mRegisterProtocolLabel.attributedText = registerProtocolText;
    
    //
    mInputPhoneTextfield.delegate = self;
    
    //keyboard type
    mInputPhoneTextfield.keyboardType = UIKeyboardTypePhonePad;
    
    mInputPhoneTextfield.returnKeyType = UIReturnKeyDone;
    
    mInputPhoneTextfield.text = self.mInputedPhoneNum;
    
    //
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onKeyboardShow)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onKeyboardHide)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
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
    else if(mInputPhoneTextfield.isEditing)
    {
        [mInputPhoneTextfield resignFirstResponder];
    }
}

- (IBAction) onTitleBackBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) onRegisterProtocolBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    RegisterProtocolViewController* registerProtocolController = [[RegisterProtocolViewController alloc] init];
    
    UINavigationController* naviC = self.navigationController;
    
    [naviC pushViewController: registerProtocolController
                     animated: YES];
}

- (IBAction) onRegisterBtnClick:(id)sender
{
    [self touchesBegan: nil
             withEvent: nil];
    
    NSString* inputedPhoneNum = mInputPhoneTextfield.text;
    
    if(inputedPhoneNum != nil &&
       inputedPhoneNum.length > 0 )
    {
        if([self isValidateMobile: inputedPhoneNum])
        {
            RegisterConfirmViewController* viewController =
            [[RegisterConfirmViewController alloc] init];
            
            //
            viewController.mInputedPhoneNum = mInputPhoneTextfield.text;
          //wlg====
            viewController.mOnLoginSuccessDelegate=self.mOnLoginSuccessDelegate;
            //=======
            UINavigationController* naviC = self.navigationController;
            
            [naviC pushViewController: viewController
                             animated: YES];
        }
        else
        {
            mNoticeContainerView.hidden = NO;
            
            mNoticeLabel.text = @"暂不支持该手机号码!";
            
            [self startDelayDismissNoticeTimer];
        }
    }
    else
    {
        mNoticeContainerView.hidden = NO;
        
        mNoticeLabel.text = @"手机号码不能为空!";
        
        [self startDelayDismissNoticeTimer];
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

@end
