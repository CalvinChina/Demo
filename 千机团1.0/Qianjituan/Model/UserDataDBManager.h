//
//  UserDataDBManager.h
//  Qianjituan
//
//  Created by Pisen on 15/9/29.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import <sqlite3.h>
#import <Foundation/Foundation.h>

@interface UserData: NSObject
{
    @public
    NSString* account;
    
    NSString* password;
    
    NSString* nickName;
    
    int sooId;
    
    int gender;
    
    long birthday;
    
    NSString* avatarUrl;
    
    NSString* mailbox;
    
    Boolean isOnline;
}
@end

@interface UserDataDBManager: NSObject
{
    @private
    sqlite3* mUserDataDB;
    
    NSString* mUserDataDBPath;
}

+ (UserDataDBManager*) getInstance;

- (Boolean) createUserDataDB;

- (void) saveUserDataToDB: (UserData*)userData;

- (UserData*) readUserData: (NSString*)account;

- (NSMutableArray*) readAllUsers;

- (NSString*) readLastOnlineAccount;

- (NSString*) readLatestUsedAccount;

- (UserData*) readLastOnlineUserData;

- (void) resetLastOnlineUser;

- (void) setCurrentOnlineUser: (NSString*)account;

- (void) updateUserDataToDB: (UserData*)userData;

- (void) deleteUserDataFromDB: (NSString*)account;

@end
