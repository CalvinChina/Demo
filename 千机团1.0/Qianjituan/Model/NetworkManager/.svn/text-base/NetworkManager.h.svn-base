//
//  NetworkManager.h
//  qiangche
//
//  Created by ios-mac on 15/8/19.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GTMBase64.h"

#import <CommonCrypto/CommonCryptor.h>

typedef void (^ReturnBlock)(NSDictionary *returnDict);

@interface NetworkManager : NSObject

@property (strong, nonatomic)ReturnBlock returnBlock;

+ (NetworkManager *)shareInstance;

- (void)POSTInfo:(ReturnBlock)infoBlock param:(NSDictionary *)paramDict URL:(NSString *)url;

- (void)GETInfo:(ReturnBlock)infoBlock param:(NSDictionary *)paramDict URL:(NSString *)url;
//获取偏移量wlg
- (void)appCustomerOffset:(ReturnBlock)infoBlock phone:(NSString *)phoneNumber ;
//判断获取偏移量是否成功
- (BOOL)isSOANormalSuccess:(NSDictionary *)returnDic;
//sendtype 0注册，1找回密码
- (void)appSendValidateMsg:(NSString*)phone type:(NSInteger)sendType picCode:(NSString*)code pickey:(NSString*)key block:(ReturnBlock)infoBlock;

- (void)appGetImgVerifyCode:(ReturnBlock)infoBlock;

- (void)appPhoneCodeVerify: (NSString*)phone
                verifyCode: (NSString*)code
                     block: (ReturnBlock)infoBlock;
//注册wlg 新
- (void)appRegister:(ReturnBlock)infoBlock phone:(NSString*)userPhone key:(NSString*)password code:(NSString*)phoneCode version:(int)apiVersion;
//老注册
//- (void)appRegister:(ReturnBlock)infoBlock phone:(NSString*)userPhone key:(NSString*)password code:(NSString*)phoneCode;
//登录新wlg

- (void)appLogin:(ReturnBlock)infoBlock phone:(NSString*)phoneNum password:(NSString*)pwd verifyKey:(NSString*)key verifyCode:(NSString*)code needVerify:(BOOL)bNeed version:(int)apiVersion;
//老
//- (void)appLogin:(ReturnBlock)infoBlock phone:(NSString*)phoneNum password:(NSString*)pwd verifyKey:(NSString*)key verifyCode:(NSString*)code needVerify:(BOOL)bNeed;

- (void)appFindPassword:(ReturnBlock)infoBlock phone:(NSString*)phoneNum code:(NSString*)phoneCode;

//新找回密码wlg  yes需要传入旧密码 no不需要(找回密码)
- (void)appRestPassword:(ReturnBlock)infoBlock
                  phone:(NSString*)phoneNum
                 pwdNew:(NSString*)passWord
                 pwdOld:(NSString*)passWordOld
          certificateID:(NSString*)certificateID
             needUpdate:(BOOL)bUpdate
                version:(int)apiVersion;
//老
//update :yes需要传入旧密码 no不需要(找回密码)
//- (void)appRestPassword:(ReturnBlock)infoBlock
//                  phone:(NSString*)phoneNum
//                 pwdNew:(NSString*)passWord
//                 pwdOld:(NSString*)passWordOld
//          certificateID:(NSString*)certificateID
//             needUpdate:(BOOL)bUpdate;

- (void)updateUserInfo: (ReturnBlock)infoBlock
                 phone: (NSString*)phoneNum
                   sex: (NSInteger)gender
                  date: (NSString*)birthday
              nickName: (NSString*)name
               mailbox: (NSString*)mailbox;

- (void) uploadAvatar: (ReturnBlock)infoBlock
                phone: (NSString*)phoneNum
             fileName: (NSString*)avatarName
            avatarB64: (NSString*)avatarBase64;

@end
