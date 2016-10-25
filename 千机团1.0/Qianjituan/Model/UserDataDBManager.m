//
//  UserDataDBManager.m
//  Qianjituan
//
//  Created by Pisen on 15/9/29.
//  Copyright © 2015年 ios-mac. All rights reserved.
//

#import "UserDataDBManager.h"

@implementation UserData

@end

@implementation UserDataDBManager

static UserDataDBManager* mInstance;

+ (UserDataDBManager*) getInstance
{
    if(mInstance == nil)
    {
        mInstance = [[UserDataDBManager alloc] init];
    }
    
    return mInstance;
}

- (id) init
{
    self = [super init];
    
    [self initDBManager];
    
    return self;
}

- (void) initDBManager
{
    [self createUserDataDB];
}

- (Boolean) createUserDataDB
{
    NSString* docsDir = nil;
    
    NSArray* dirPath = nil;
    
    dirPath =
        NSSearchPathForDirectoriesInDomains(
                                            NSDocumentDirectory,
                                            NSUserDomainMask,
                                            YES);
    
    docsDir = [dirPath objectAtIndex: 0];
    
    mUserDataDBPath = [docsDir stringByAppendingPathComponent: @"userdb.db"];
    
    mUserDataDBPath = [[NSString alloc] initWithString: mUserDataDBPath];
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    if(sqlite3_open(dbpath, &mUserDataDB) != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        return NO;
    }
    
    const char* tableCreateSqlStr =
    "create table if not exists userinfortable("\
    "id integer primary key autoincrement, "\
    "account text, "\
    "password text, "\
    "nickname text, "\
    "sooid interger, "\
    "gender integer, "\
    "birthday long, "\
    "avatarurl text, "\
    "mailbox text, "\
    "isOnline integer, "\
    "accesstime long)";
    
    const char* error = nil;
    
    int resultCode =
    sqlite3_exec(
                 mUserDataDB,
                 tableCreateSqlStr,
                 NULL,
                 NULL,
                 &error);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        return NO;
    }
    
    return YES;
}

- (void) saveUserDataToDB: (UserData*)userData
{
    if(userData == nil ||
       mUserDataDBPath == nil ||
       userData->account == nil ||
       userData->account == [NSNull null])
    {
        return;
    }
    
    UserData* existedUserData = [self readUserData: userData->account];
    
    if(existedUserData != nil)
    {
        [self updateUserDataToDB: userData];
        
        return;
    }
    
    sqlite3_stmt* sqlStatement;
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode != SQLITE_OK)
    {
        return;
    }
    
    NSString* nickName = userData->nickName;
    
    if(nickName == nil ||
       nickName == [NSNull null])
    {
        nickName = @"";
    }
    else if([nickName rangeOfString: @"\""].length > 0)
    {
        nickName = [nickName stringByReplacingOccurrencesOfString: @"\""
                                                       withString: @""];
    }
    
    NSString* avatarUrl = userData->avatarUrl;
    
    if(avatarUrl == nil ||
       avatarUrl == [NSNull null])
    {
        avatarUrl = @"";
    }
    
    NSString* mailBox = userData->mailbox;
    
    if(mailBox == nil ||
       mailBox == [NSNull null])
    {
        mailBox = @"";
    }
    
    NSLog(@"saveUserDataToDB password %@ ",userData->password);
    
    userData->password = [common encodeUseBase64:userData->password];
    
    NSLog(@"saveUserDataToDB encodeUseBase64 %@ ",userData->password);
    
    long currentTimeLong = [[NSDate date] timeIntervalSince1970];
    
    NSString* insertSQL =
    [NSString stringWithFormat:
     @"insert into "\
     "userinfortable("\
     "account, "\
     "password, "\
     "nickname, "\
     "sooid, "\
     "gender, "\
     "birthday, "\
     "avatarurl, "\
     "mailbox, "\
     "isOnline, "\
     "accesstime)"\
     "values("\
     "\"%@\", "\
     "\"%@\", "\
     "\"%@\", "\
     "%d, "\
     "%d, "\
     "%ld, "\
     "\"%@\", "\
     "\"%@\", "\
     "%d, "\
     "%ld)",
     userData->account,
     userData->password,
     nickName,
     userData->sooId,
     userData->gender,
     userData->birthday,
     avatarUrl,
     mailBox,
     userData->isOnline,
     currentTimeLong];
    
    const char* insertSqlStatement = [insertSQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       insertSqlStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
        
        return;
    }
    
    resultCode = sqlite3_step(sqlStatement);
    
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
    }
    
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);
}

- (UserData*) readUserData: (NSString*)account
{
    if(account <= 0 ||
       mUserDataDBPath == nil)
    {
        return nil;
    }
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    sqlite3_stmt* sqlStatement;
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode != SQLITE_OK)
    {
        return nil;
    }
    
    NSString* querySQL =
    [NSString stringWithFormat:
     @"select "\
     "password, "\
     "nickname, "\
     "sooid, "\
     "gender, "\
     "birthday, "\
     "avatarurl, "\
     "mailbox, "\
     "isOnline "\
     "from userinfortable "\
     "where account = \"%@\"",
     account];
    
    const char* queryStatement = [querySQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       queryStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
        
        return nil;
    }
    
    resultCode = sqlite3_step(sqlStatement);
    
    if(resultCode != SQLITE_ROW)
    {
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(mUserDataDB);
        
        return nil;
    }
    
    UserData* userDataItem = [[UserData alloc] init];
    
    userDataItem->account = [[NSString alloc] initWithString: account];
    
    const char* value = (const char*)sqlite3_column_text(sqlStatement, 0);
    
    //password
    if(value != nil)
    {
        NSString* password = [[NSString alloc] initWithUTF8String: value];
        
        if(password != nil &&
           password.length > 0)
        {
//            userDataItem->password = [[NSString alloc] initWithString: password];
            
            userDataItem->password = [common decodeUseBase64:password];
            
             NSLog(@" readUserData  password %@ ",password);
            
            NSLog(@" readUserData  decodeUseBase64 %@",userDataItem->password);
            
        }
    }
    
    //nickname
    value = (const char*)sqlite3_column_text(sqlStatement, 1);
    
    if(value != nil)
    {
        NSString* nickname = [[NSString alloc] initWithUTF8String: value];
        
        if(nickname != nil &&
           nickname.length > 0)
        {
            userDataItem->nickName = [[NSString alloc] initWithString: nickname];
        }
    }
    
    //sooId
    userDataItem->sooId = sqlite3_column_int(sqlStatement, 2);
    
    //gender
    userDataItem->gender = sqlite3_column_int(sqlStatement, 3);
    
    //birthday
    userDataItem->birthday = sqlite3_column_int64(sqlStatement, 4);
    
    //avatar url
    value = (const char*)sqlite3_column_text(sqlStatement, 5);
    
    if(value != nil)
    {
        NSString* avatarUrl = [[NSString alloc] initWithUTF8String: value];
        
        if(avatarUrl != nil &&
           avatarUrl.length > 0)
        {
            userDataItem->avatarUrl = [[NSString alloc] initWithString: avatarUrl];
        }
    }
    
    //mailbox
    value = (const char*)sqlite3_column_text(sqlStatement, 6);
    
    if(value != nil)
    {
        NSString* mailbox = [[NSString alloc] initWithUTF8String: value];
        
        if(mailbox != nil &&
           mailbox.length > 0)
        {
            userDataItem->mailbox = [[NSString alloc] initWithString: mailbox];
        }
    }
    
    //isOnline
    userDataItem->isOnline = sqlite3_column_int(sqlStatement, 7);
    
    //
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);

    return userDataItem;
}

- (NSMutableArray*) readAllUsers
{
    if(mUserDataDBPath == nil)
    {
        return nil;
    }
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    sqlite3_stmt* sqlStatement;
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode != SQLITE_OK)
    {
        return nil;
    }
    
    NSString* querySQL =
    [NSString stringWithFormat:
     @"select "\
     "account, "\
     "password, "\
     "nickname, "\
     "sooid, "\
     "gender, "\
     "birthday, "\
     "avatarurl, "\
     "mailbox, "\
     "isOnline "\
     "from userinfortable "\
     "order by accesstime desc"];
    
    const char* queryStatement = [querySQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       queryStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        sqlite3_close(mUserDataDB);
        
        return nil;
    }
    
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW)
    {
        UserData* userDataItem = [[UserData alloc] init];
        
        //account
        const char* value = (const char*)sqlite3_column_text(sqlStatement, 0);
        
        if(value != nil)
        {
            NSString* account = [[NSString alloc] initWithUTF8String: value];
            
            if(account != nil &&
               account.length > 0)
            {
                userDataItem->account = [[NSString alloc] initWithString: account];
            }
        }
        
        //password
        value = (const char*)sqlite3_column_text(sqlStatement, 1);
        
        if(value != nil)
        {
            NSString* password = [[NSString alloc] initWithUTF8String: value];
            
            if(password != nil &&
               password.length > 0)
            {
              //  userDataItem->password = [[NSString alloc] initWithString: password];
                userDataItem->password = [common decodeUseBase64:password];
                
                NSLog(@" readAllUsers  password %@ ",password);
                
                NSLog(@" readAllUsers  decodeUseBase64 %@",userDataItem->password);
            }
        }
        
        //nickname
        value = (const char*)sqlite3_column_text(sqlStatement, 2);
        
        if(value != nil)
        {
            NSString* nickname = [[NSString alloc] initWithUTF8String: value];
            
            if(nickname != nil &&
               nickname.length > 0)
            {
                userDataItem->nickName = [[NSString alloc] initWithString: nickname];
            }
        }
        
        //sooId
        userDataItem->sooId = sqlite3_column_int(sqlStatement, 3);
        
        //gender
        userDataItem->gender = sqlite3_column_int(sqlStatement, 4);
        
        //birthday
        userDataItem->birthday = sqlite3_column_int64(sqlStatement, 5);
        
        //avatar url
        value = (const char*)sqlite3_column_text(sqlStatement, 6);
        
        if(value != nil)
        {
            NSString* avatarUrl = [[NSString alloc] initWithUTF8String: value];
            
            if(avatarUrl != nil &&
               avatarUrl.length > 0)
            {
                userDataItem->avatarUrl = [[NSString alloc] initWithString: avatarUrl];
            }
        }
        
        //mailbox
        value = (const char*)sqlite3_column_text(sqlStatement, 7);
        
        if(value != nil)
        {
            NSString* mailbox = [[NSString alloc] initWithUTF8String: value];
            
            if(mailbox != nil &&
               mailbox.length > 0)
            {
                userDataItem->mailbox = [[NSString alloc] initWithString: mailbox];
            }
        }
        
        //isOnline
        userDataItem->isOnline = sqlite3_column_int(sqlStatement, 8);
        
        [resultArray addObject: userDataItem];
    }
    
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);
    
    return resultArray;
}

- (NSString*) readLastOnlineAccount
{
    if(mUserDataDBPath == nil)
    {
        return 0;
    }
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    sqlite3_stmt* sqlStatement;
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        return 0;
    }
    
    NSString* querySQL =
    [NSString stringWithFormat:
     @"select "\
     "account "\
     "from userinfortable "\
     "where isOnline = 1"];
    
    const char* queryStatement = [querySQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       queryStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
        
        return 0;
    }
    
    resultCode = sqlite3_step(sqlStatement);
    
    if(resultCode != SQLITE_ROW)
    {
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(mUserDataDB);
        
        return 0;
    }
    
    //account
    const char* resultChar = (const char*)sqlite3_column_text(sqlStatement, 0);
    
    NSString* account =
    [[NSString alloc] initWithUTF8String: resultChar];
    
    //
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);
    
    return account;
}

- (NSString*) readLatestUsedAccount
{
    if(mUserDataDBPath == nil)
    {
        return 0;
    }
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    sqlite3_stmt* sqlStatement;
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        return 0;
    }
    
    NSString* querySQL =
    [NSString stringWithFormat:
     @"select "\
     "account "\
     "from userinfortable "\
     "order by accesstime desc"];
    
    const char* queryStatement = [querySQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       queryStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
        
        return 0;
    }
    
    resultCode = sqlite3_step(sqlStatement);
    
    if(resultCode != SQLITE_ROW)
    {
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(mUserDataDB);
        
        return 0;
    }
    
    //account
    const char* resultChar = (const char*)sqlite3_column_text(sqlStatement, 0);
    
    NSString* account =
    [[NSString alloc] initWithUTF8String: resultChar];
    
    //
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);
    
    return account;
}

- (UserData*) readLastOnlineUserData
{
    if(mUserDataDBPath == nil)
    {
        return nil;
    }
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    sqlite3_stmt* sqlStatement;
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode != SQLITE_OK)
    {
        return nil;
    }
    
    NSString* querySQL =
    [NSString stringWithFormat:
     @"select "\
     "account, "\
     "password, "\
     "nickname, "\
     "sooid, "\
     "gender, "\
     "birthday, "\
     "avatarurl, "\
     "mailbox "\
     "from userinfortable "\
     "where isOnline = 1"];
    
    const char* queryStatement = [querySQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       queryStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
        
        return nil;
    }
    
    resultCode = sqlite3_step(sqlStatement);
    
    if(resultCode != SQLITE_ROW)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_finalize(sqlStatement);
        
        sqlite3_close(mUserDataDB);
        
        return nil;
    }
    
    UserData* userDataItem = [[UserData alloc] init];
    
    //account
    const char* value = (const char*)sqlite3_column_text(sqlStatement, 0);
    
    if(value != nil)
    {
        NSString* account = [[NSString alloc] initWithUTF8String: value];
        
        if(account != nil &&
           account.length > 0)
        {
            userDataItem->account = [[NSString alloc] initWithString: account];
        }
    }
    
    //password
    value = (const char*)sqlite3_column_text(sqlStatement, 1);
    
    if(value != nil)
    {
        NSString* password = [[NSString alloc] initWithUTF8String: value];
        
        if(password != nil &&
           password.length > 0)
        {
       //     userDataItem->password = [[NSString alloc] initWithString: password];
            userDataItem->password = [common decodeUseBase64:password];
            
            NSLog(@" readLastOnlineUserData  password %@ ",password);
            
            NSLog(@" readLastOnlineUserData  decodeUseBase64 %@",userDataItem->password);
        }
    }
    
    //nickname
    value = (const char*)sqlite3_column_text(sqlStatement, 2);
    
    if(value != nil)
    {
        NSString* nickname = [[NSString alloc] initWithUTF8String: value];
        
        if(nickname != nil &&
           nickname.length > 0)
        {
            userDataItem->nickName = [[NSString alloc] initWithString: nickname];
        }
    }
    
    //sooId
    userDataItem->sooId = sqlite3_column_int(sqlStatement, 3);
    
    //gender
    userDataItem->gender = sqlite3_column_int(sqlStatement, 4);
    
    //birthday
    userDataItem->birthday = sqlite3_column_int64(sqlStatement, 5);
    
    //avatar url
    value = (const char*)sqlite3_column_text(sqlStatement, 6);
    
    if(value != nil)
    {
        NSString* avatarUrl = [[NSString alloc] initWithUTF8String: value];
        
        if(avatarUrl != nil &&
           avatarUrl.length > 0)
        {
            userDataItem->avatarUrl = [[NSString alloc] initWithString: avatarUrl];
        }
    }
    
    //mailbox
    value = (const char*)sqlite3_column_text(sqlStatement, 7);
    
    if(value != nil)
    {
        NSString* mailbox = [[NSString alloc] initWithUTF8String: value];
        
        if(mailbox != nil &&
           mailbox.length > 0)
        {
            userDataItem->mailbox = [[NSString alloc] initWithString: mailbox];
        }
    }
    
    //isOnline
    userDataItem->isOnline = YES;
    
    //
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);
    
    return userDataItem;
}

- (void) resetLastOnlineUser
{
    sqlite3_stmt* sqlStatement;
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode !=SQLITE_OK)
    {
        return;
    }
    
    NSString* updateSQL =
    [NSString stringWithFormat:
     @"update "\
     "userinfortable "\
     "set "\
     "isOnline = 0"];
    
    const char* updateSqlStatement = [updateSQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       updateSqlStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
        
        return;
    }
    
    resultCode = sqlite3_step(sqlStatement);
    
    if(resultCode != SQLITE_DONE)
    {
        sqlite3_close(mUserDataDB);
    }
    
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);
}

- (void) setCurrentOnlineUser: (NSString*)account
{
    if(account == nil ||
       account.length <= 0)
    {
        return;
    }
    
    sqlite3_stmt* sqlStatement;
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode != SQLITE_OK)
    {
        return;
    }
    
    long currentTimeLong =
    [[NSDate date] timeIntervalSince1970];
    
    NSString* updateSQL =
    [NSString stringWithFormat:
     @"update "\
     "userinfortable "\
     "set "\
     "isOnline = 1, "\
     "accesstime = "\
     "%ld "\
     "where "\
     "account = "\
     "\"%@\")",
     currentTimeLong,
     account];
    
    const char* updateSqlStatement = [updateSQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       updateSqlStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
        
        return;
    }
    
    resultCode = sqlite3_step(sqlStatement);
    
    if(resultCode != SQLITE_DONE)
    {
        sqlite3_close(mUserDataDB);
    }
    
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);
}

- (void) updateUserDataToDB: (UserData*)userData
{
    if(userData == nil ||
       mUserDataDBPath == nil ||
       userData->account == 0)
    {
        return;
    }
    
    sqlite3_stmt* sqlStatement;
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode != SQLITE_OK)
    {
        return;
    }
    
    NSString* nickName = userData->nickName;
    
    if(nickName == nil ||
       nickName == [NSNull null])
    {
        nickName = @"";
    }
    else if([nickName rangeOfString: @"\""].length > 0)
    {
        nickName = [nickName stringByReplacingOccurrencesOfString: @"\""
                                                       withString: @""];
    }
    
    NSString* avatarUrl = userData->avatarUrl;
    
    if(avatarUrl == nil ||
       avatarUrl == [NSNull null])
    {
        avatarUrl = @"";
    }
    
    NSString* mailBox = userData->mailbox;
    
    if(mailBox == nil ||
       mailBox == [NSNull null])
    {
        mailBox = @"";
    }
    
    long currentTimeLong = [[NSDate date] timeIntervalSince1970];
    
    NSLog(@"  updateUserDataToDB  password %@ ",userData->password);
    
    userData->password = [common encodeUseBase64:userData->password];
    
    NSLog(@"  updateUserDataToDB  encodeUseBase64 %@",userData->password);
    
    NSString* updateSQL =
    [NSString stringWithFormat:
     @"update "\
     "userinfortable "\
     "set "\
     "password = \"%@\", "\
     "nickname = \"%@\", "\
     "sooid = %d, "\
     "gender = %d, "\
     "birthday = %ld, "\
     "avatarurl = \"%@\", "\
     "mailbox = \"%@\", "\
     "isOnline = %d, "\
     "accesstime = %ld "\
     "where account = "\
     "\"%@\"",
     userData->password,
     nickName,
     userData->sooId, 
     userData->gender,
     userData->birthday,
     avatarUrl,
     mailBox,
     userData->isOnline,
     currentTimeLong,
     userData->account];
    
    const char* updateSqlStatement = [updateSQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       updateSqlStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
        
        return;
    }
    
    resultCode = sqlite3_step(sqlStatement);
    
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
    }
    
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);
}

- (void) deleteUserDataFromDB: (NSString*)account
{
    if(mUserDataDBPath == nil ||
       account == 0)
    {
        return;
    }
    
    sqlite3_stmt* sqlStatement;
    
    const char* dbpath = [mUserDataDBPath UTF8String];
    
    int resultCode = sqlite3_open(dbpath, &mUserDataDB);
    
    if(resultCode !=SQLITE_OK)
    {
        return;
    }
    
    NSString* deleteSQL =
    [NSString stringWithFormat:
     @"delete from "\
     "userinfortable "\
     "where "\
     "account = "\
     "\"%@\"",
     account];
    
    const char* insertSqlStatement = [deleteSQL UTF8String];
    
    resultCode =
    sqlite3_prepare_v2(
                       mUserDataDB,
                       insertSqlStatement,
                       -1,
                       &sqlStatement,
                       NULL);
    
    if(resultCode != SQLITE_OK)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
        
        return;
    }
    
    resultCode = sqlite3_step(sqlStatement);
    
    if(resultCode != SQLITE_DONE)
    {
        NSLog(@"Error:%s",sqlite3_errmsg(mUserDataDB));
        
        sqlite3_close(mUserDataDB);
    }
    
    sqlite3_finalize(sqlStatement);
    
    sqlite3_close(mUserDataDB);
}

@end
