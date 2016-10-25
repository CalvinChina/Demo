//
//  NetworkMacro.h
//  Qianjituan
//
//  Created by zengbixing on 15/9/22.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#ifndef NetworkMacro_h
#define NetworkMacro_h

//#define appKey @"13151015"
//#define secret @"8a97bf3169054f54862b07eb47adc250"



#define appKey @"11101659"
#define secret @"47be16b604dc4d18945ed5e07b455a09"
//// 生产环境接口
//#define mainUrl @"http://api.piseneasy.com/Router/Rest/Post"
//
////生产登录认证接口
//#define LoginUrl @"http://api.piseneasy.com/Router/Rest/SecretPost"
////生产获得偏移量接口
//#define OffsetUrl @"http://api.piseneasy.com/Router/Rest/InitializeLog"
//
// 测试环境sso接口
#define mainUrl @"http://test.api.piseneasy.com:9212/Router/Rest/Post"

//测试登录认证接口
#define LoginUrl @"http://test.api.piseneasy.com:9212/Router/Rest/SecretPost"
//测试获得偏移量接口
#define OffsetUrl @"http://test.api.piseneasy.com:9212/Router/Rest/InitializeLog"


#define APPSendMsg @"Pisen.Service.Share.SSO.Contract.ICustomerService.AppSendMsg"

#define AppGetVerifyCode @"Pisen.Service.Share.SSO.Contract.ICustomerService.AppGetVerifyCode"

#define AppPhoneCodeVerify @"Pisen.Service.Share.SSO.Contract.ICustomerService.AppPhoneCodeVerifyV2"

#define AppRegister  @"Pisen.Service.Share.SSO.Contract.ICustomerService.AppRegisterV2"
//注册V3接口
#define AppRegisterv3  @"Pisen.Service.Share.SSO.Contract.ICustomerService.AppRegisterV3"

#define AppLogin @"SOA.EC.Customer.Contract.ICustomerService.AppLoginV2"
//v3接口登录
#define AppLoginv3 @"SOA.EC.Customer.Contract.ICustomerService.AppLoginV3"

#define FinePwd @"Pisen.Service.Share.SSO.Contract.ICustomerService.APPFindPassWord"

#define AppRestPwd @"Pisen.Service.Share.SSO.Contract.ICustomerService.AppResetPassWordV2"
//重置密码接口v3
#define AppRestPwdv3 @"Pisen.Service.Share.SSO.Contract.ICustomerService.AppResetPassWordV3"
#define AppCustomerEdit @"SOA.EC.Customer.Contract.ICustomerService.AppCustomerEdit"

#define AppUploadAvatar @"SOA.EC.Customer.Contract.ICustomerService.AppCustomerUploadImage"

#define AppCustomerOffset @"Pisen.Service.Share.SSO.Contract.ICustomerService.AppCustomerOffset"
#endif /* NetworkMacro_h */
