//
//  NetworkManager.m
//  qiangche
//
//  Created by ios-mac on 15/8/19.
//
//

#import "NetworkManager.h"
#import "Hmacsha1.h"
#import "NetworkMacro.h"

@implementation NetworkManager

NSString* publicKey = @"Pi658098";

__strong static NetworkManager *networkInstance = nil;

+ (NetworkManager *)shareInstance
{
    static dispatch_once_t pre = 0;
    dispatch_once(&pre, ^{
        networkInstance = [[super allocWithZone:NULL] init];
    });
    
    return networkInstance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
     
    }
    
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}

- (void) startMonitoring{
    
    //监控网络改变-----
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        
        NSLog(@"AFNetworkReachabilityStatus===%ld", status);
    }];

}
- (void)POSTInfo:(ReturnBlock)infoBlock param:(NSDictionary *)paramDict URL:(NSString *)url
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:url parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        [dict setObject:@YES forKey:@"returnInfo"];
        
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *dict = @{@"returnInfo" : @NO};
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    }];
}

- (void)GETInfo:(ReturnBlock)infoBlock param:(NSDictionary *)paramDict URL:(NSString *)url
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
        [dict setObject:@YES forKey:@"returnInfo"];
        
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSDictionary *dict = @{@"returnInfo" : @NO};
        self.returnBlock = infoBlock;
        self.returnBlock(dict);
    }];
}
//新加===wlg
- (void)appendLoginCommomHead:(NSMutableDictionary*)paramDic sessionKey:(NSString *)sessionKey passwdStr:(NSString *)passwdStr {
    [self _appendCommomHead:paramDic sessionKey:sessionKey passwdStr:passwdStr needSessionKeySign:YES];
}

- (void)appendCommomHead:(NSMutableDictionary*)paramDic sessionKey:(NSString *)sessionKey {
    [self _appendCommomHead:paramDic sessionKey:sessionKey passwdStr:nil needSessionKeySign:NO];
}
//=====wlg
//新版=====wlg
- (void)_appendCommomHead:(NSMutableDictionary*)paramDic sessionKey:(NSString *)sessionKey passwdStr:(NSString *)passwdStr needSessionKeySign:(BOOL)needSessionKeySign {
    
    if (paramDic) {
        
        [paramDic setObject:appKey forKey:@"AppKey"];
        
        [paramDic setObject:@"json" forKey:@"Format"];
        
        [paramDic setObject:@"" forKey:@"Version"];
        
        if (sessionKey) {
            [paramDic setObject:sessionKey forKey:@"SessionKey"];
        } else {
            [paramDic setObject:@"" forKey:@"SessionKey"];
        }
        
        NSArray *sortArr = @[@"AppKey", @"Body", @"Format", @"Method",@"SessionKey",@"Version"];
        
        NSMutableString* a = [[NSMutableString alloc] initWithCapacity:1];
        
        NSInteger k = -1;
        
        for (NSInteger i = 0; i < sortArr.count; i++) {
            
            NSString *key = sortArr[i];
            
            NSString *value = [self getDictionaryValue:key srcData:paramDic];
            
            if ([value length] > 0) {
                
                k = i;
                
                if (k > 0 && i != sortArr.count - 1) {
                    
                    [a appendString:@"&"];
                }
                [a appendString:key];
                
                [a appendString:@"="];
                
                [a appendString:value];
                
            }
        }
        
        if (needSessionKeySign && sessionKey && passwdStr) {
            [a appendFormat:@"&%@%@", sessionKey, passwdStr];
        }
        
        NSString *sign = [Hmacsha1 hmacsha1:a key:secret];
        
        if (!sign) {
            
            sign = @"";
        }
        
        [paramDic setObject:sign forKey:@"Sign"];
    }
}
//新版=====wlg
//老版
- (void)appendCommomHead:(NSMutableDictionary*)paramDic {
    
    if (paramDic) {
        
        [paramDic setObject:appKey forKey:@"AppKey"];
        
        [paramDic setObject:@"json" forKey:@"Format"];
        
        [paramDic setObject:@"" forKey:@"Version"];
        
        [paramDic setObject:@"" forKey:@"SessionKey"];
        
        NSArray *sortArr = @[@"AppKey", @"Body", @"Format", @"Method",@"SessionKey",@"Version"];
        
        NSMutableString* a = [[NSMutableString alloc] initWithCapacity:1];
        
        NSInteger k = -1;
        
        for (NSInteger i = 0; i < sortArr.count; i++) {
            
            NSString *key = sortArr[i];
            
            NSString *value = [self getDictionaryValue:key srcData:paramDic];
            
            if ([value length] > 0) {
                
                k = i;
                
                if (k > 0&&i != sortArr.count - 1) {
                    
                    [a appendString:@"&"];
                }
                [a appendString:key];
                
                [a appendString:@"="];
                
                [a appendString:value];

            }
        }
        
        NSString *sign = [Hmacsha1 hmacsha1:a key:secret];
        
        if (sign == nil) {
            
            sign = @"";
        }
        
        //sign = @"n+v6F2GmnIwF9z5LZ1N1mZebmo4=";
        
        [paramDic setObject:sign forKey:@"Sign"];
    }
}

- (NSString*)getDictionaryValue:(NSString*)key srcData:(NSMutableDictionary*)param {
    
    NSString *value = [param objectForKey:key];
    
    if (value == nil) {
        
        value = @"";
    }
    
    return value;
}

- (void)appSendValidateMsg:(NSString*)phone type:(NSInteger)sendType picCode:(NSString*)code pickey:(NSString*)key block:(ReturnBlock)infoBlock{
    
    if (phone) {
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        
        [param setObject:phone forKey:@"Mobile"];
        
        [param setObject:APPSendMsg forKey:@"Method"];
        
        NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
        
        [bodyDic setObject:[NSNumber numberWithInteger:sendType] forKey:@"SendType"];

        [bodyDic setObject:phone forKey:@"PhoneNumber"];
        
//        [bodyDic setObject:code forKey:@"VerifyCode"];
//
//        [bodyDic setObject:key forKey:@"VerifyKey"];
        
        [bodyDic setObject: appKey forKey:@"AppKey"];
        
        [bodyDic setObject: [NSNumber numberWithInteger: 1] forKey:@"PlatformType"];//0(当日达),1(千机团)
        
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *bodyStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
        
        [param setObject:bodyStr forKey:@"Body"];
        
        [self appendCommomHead:param];
        
        [self POSTInfo:infoBlock param:param URL:mainUrl];
    }
}

- (void)appGetImgVerifyCode:(ReturnBlock)infoBlock {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:AppGetVerifyCode forKey:@"Method"];
    
    [param setObject:@"{}" forKey:@"Body"];

    [self appendCommomHead:param];
    
    [self POSTInfo:infoBlock param:param URL:mainUrl];
}
#pragma mark -here
- (void)appPhoneCodeVerify: (NSString*)phone
                verifyCode: (NSString*)code
                     block:(ReturnBlock)infoBlock
{
    if(phone == nil ||
       code == nil)
    {
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:phone forKey:@"Mobile"];
    
    [param setObject:AppPhoneCodeVerify forKey:@"Method"];
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    [bodyDic setObject:phone forKey:@"PhoneNumber"];
    
    [bodyDic setObject:code forKey:@"PhoneCode"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    [param setObject:bodyStr forKey:@"Body"];
    
    [self appendCommomHead:param];
    
    [self POSTInfo:infoBlock param:param URL:mainUrl];
}
#pragma mark-注册
- (void)appRegister:(ReturnBlock)infoBlock phone:(NSString*)userPhone key:(NSString*)password code:(NSString*)phoneCode version:(int)apiVersion{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:AppRegisterv3 forKey:@"Method"];
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    [bodyDic setObject:userPhone forKey:@"PhoneNumber"];
    
   // password = [self encryptUseDES: password key: publicKey];
    
    //[bodyDic setObject:password forKey:@"PassWord"];
    //wlg new
    [bodyDic setObject:password forKey:@"PassWord"];
    
    [bodyDic setObject:phoneCode forKey:@"PhoneCode"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    [param setObject:bodyStr forKey:@"Body"];
    
    [self appendCommomHead:param sessionKey:userPhone];
    
    [self POSTInfo:infoBlock param:param URL:mainUrl];
}
//获取偏移量==============wlg
- (void)appCustomerOffset:(ReturnBlock)infoBlock phone:(NSString *)phoneNumber {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:AppCustomerOffset forKey:@"Method"];
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    [bodyDic setObject:phoneNumber forKey:@"PhoneNumber"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    [param setObject:bodyStr forKey:@"Body"];
    
    [self appendCommomHead:param sessionKey:phoneNumber];
    
    [self POSTInfo:infoBlock param:param URL:OffsetUrl];//这里传入的是获取偏移量的接口
}
//===============================
//判断获取偏移量是否成功wlg
- (BOOL)isSOANormalSuccess:(NSDictionary *)returnDic {
    
    Boolean offsetSuccessed = [returnDic[@"IsSuccess"] boolValue];
    Boolean offsetFailed = [returnDic[@"IsError"] boolValue];
    
    return (offsetSuccessed && !offsetFailed);
}
#pragma mark-登录
- (void)appLogin:(ReturnBlock)infoBlock phone:(NSString*)phoneNum password:(NSString*)pwd verifyKey:(NSString*)key verifyCode:(NSString*)code needVerify:(BOOL)bNeed version:(int)apiVersion {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    /Users/pisen/Desktop/企业级/千机团1.0/Qianjituan/Library/ShareSDK/Support/Optional/ShareSDKUI.bundle/Icon/sns_icon_37.png

    [param setObject:AppLoginv3 forKey:@"Method"];
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    [bodyDic setObject:phoneNum forKey:@"PhoneNumber"];
    
    [bodyDic setObject: [NSNumber numberWithInteger: 31] forKey:@"Source"];
    //pwd = [self encryptUseDES: pwd key: publicKey];
    
    //[bodyDic setObject:pwd forKey:@"PassWord"];
    [bodyDic setObject:@"$pwd$" forKey:@"PassWord"];
    
    if (bNeed) {
        
        [bodyDic setObject:key forKey:@"VerifyKey"];
        
        [bodyDic setObject:code forKey:@"VerifyCode"];
    }
    else {
        
        [bodyDic setObject:@"" forKey:@"VerifyKey"];
        
        [bodyDic setObject:@"" forKey:@"VerifyCode"];

    }
    
    [bodyDic setObject: [NSNumber numberWithBool:bNeed] forKey:@"NeedVerify"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    [param setObject:bodyStr forKey:@"Body"];
    
    //[self appendCommomHead:param];
    [self appendLoginCommomHead:param sessionKey:phoneNum passwdStr:pwd];
    [self POSTInfo:infoBlock param:param URL:LoginUrl];
}

- (void)appFindPassword:(ReturnBlock)infoBlock phone:(NSString*)phoneNum code:(NSString*)phoneCode{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:FinePwd forKey:@"Method"];
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    [bodyDic setObject:phoneNum forKey:@"PhoneNumber"];
    
    [bodyDic setObject:phoneCode forKey:@"PhoneCode"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    [param setObject:bodyStr forKey:@"Body"];
    
    [self appendCommomHead:param];
    
    [self POSTInfo:infoBlock param:param URL:mainUrl];
}
#pragma mark-重置密码
- (void)appRestPassword:(ReturnBlock)infoBlock
                  phone:(NSString*)phoneNum
                 pwdNew:(NSString*)passWord
                 pwdOld:(NSString*)passWordOld
          certificateID:(NSString*)certificateID
             needUpdate:(BOOL)bUpdate
                version:(int)apiVersion{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:AppRestPwdv3 forKey:@"Method"];
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    [bodyDic setObject:phoneNum forKey:@"PhoneNumber"];
    
   // passWord = [self encryptUseDES: passWord key: publicKey];
    
   // [bodyDic setObject:passWord forKey:@"PassWord"];
    
   // passWordOld = [self encryptUseDES: passWordOld key: publicKey];
    
    //[bodyDic setObject:passWordOld forKey:@"OldPassword"];
    //wlg新的接口===
    [bodyDic setObject:passWord forKey:@"PassWord"];
    
    [bodyDic setObject:passWordOld forKey:@"OldPassword"];
    //====
    
    [bodyDic setObject:certificateID forKey:@"CertificateID"];
   
    [bodyDic setObject:[NSNumber numberWithBool:bUpdate] forKey:@"IsUpdate"];

    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    [param setObject:bodyStr forKey:@"Body"];
    
    //[self appendCommomHead:param];
    [self appendCommomHead:param sessionKey:phoneNum];
    
    [self POSTInfo:infoBlock param:param URL:mainUrl];
}

- (void)updateUserInfo: (ReturnBlock)infoBlock
                 phone: (NSString*)phoneNum
                   sex: (NSInteger)gender
                  date: (NSString*)birthday
              nickName: (NSString*)name
               mailbox: (NSString*)mailbox
{
    if(phoneNum == nil)
    {
        return;
    }
    
    if(birthday == nil)
    {
        birthday = @"";
    }
    
    if(name == nil)
    {
        name = @"";
    }
    
    if(mailbox == nil)
    {
        mailbox = @"";
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:AppCustomerEdit forKey:@"Method"];
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    [bodyDic setObject:phoneNum forKey:@"Phone"];
    
    [bodyDic setObject: phoneNum forKey:@"Account"];
    
    if(gender > 0)
    {
        [bodyDic setObject: @"1" forKey:@"Gender"];
    }
    else
    {
        [bodyDic setObject: @"0" forKey:@"Gender"];
    }
    
    [bodyDic setObject:name forKey:@"NickName"];
    
    [bodyDic setObject:birthday forKey:@"Birthday"];
    
    [bodyDic setObject:mailbox forKey:@"EmailAddress"];
        
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    [param setObject:bodyStr forKey:@"Body"];
    
    [self appendCommomHead:param];
    
    [self POSTInfo:infoBlock param:param URL:mainUrl];
    
}

- (void) uploadAvatar: (ReturnBlock)infoBlock
                phone: (NSString*)phoneNum
             fileName: (NSString*)avatarName
            avatarB64: (NSString*)avatarBase64
{
    if(phoneNum == nil ||
       avatarBase64 == nil ||
       phoneNum.length <= 0 ||
       avatarBase64.length <= 0)
    {
        return;
    }
    
    if(avatarName == nil)
    {
        avatarName = @"";
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:AppUploadAvatar forKey:@"Method"];
    
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    [bodyDic setObject:phoneNum forKey:@"Account"];
    
    [bodyDic setObject:avatarName forKey:@"FileName"];
    
    [bodyDic setObject:avatarBase64 forKey:@"FileImageString"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *bodyStr = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    [param setObject:bodyStr forKey:@"Body"];
    
    [self appendCommomHead:param];
    
    [self POSTInfo:infoBlock param:param URL:mainUrl];
}

- (NSString*) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    
    const char *textBytes = [plainText UTF8String];
    
    NSUInteger dataLength = [plainText length];
    
    unsigned char buffer[1024];
    
    memset(buffer, 0, sizeof(char));
    
    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          textBytes,
                                          dataLength,
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
    if(cryptStatus == kCCSuccess)
    {
        NSData *data = [GTMBase64 encodeBytes: buffer length: (NSUInteger)numBytesEncrypted];
        
//        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return ciphertext;
}

@end
