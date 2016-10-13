//
//  CDFailedMessagesManager.m
//  LeanChatLib
//
//  Created by lzw on 15/7/14.
//  Copyright (c) 2015年 lzwjava@LeanCloud QQ: 651142978. All rights reserved.
//

#import "CDFailedMessageStore.h"
#import <FMDB/FMDB.h>
#import "CDMacros.h"

#define kCDFaildMessageTable @"failed_messages"
#define kCDKeyId @"id"
#define kCDKeyConversationId @"conversationId"
#define kCDKeyMessage @"message"

#define kCDCreateTableSQL                                       \
    @"CREATE TABLE IF NOT EXISTS " kCDFaildMessageTable @"("    \
        kCDKeyId @" VARCHAR(63) PRIMARY KEY, "                  \
        kCDKeyConversationId @" VARCHAR(63) NOT NULL,"          \
        kCDKeyMessage @" BLOB NOT NULL"                         \
    @")"

#define kCDWhereConversationId \
    @" WHERE " kCDKeyConversationId @" = ? "

#define kCDSelectMessagesSQL                        \
	@"SELECT * FROM " kCDFaildMessageTable          \
	kCDWhereConversationId

#define kCDInsertMessageSQL                             \
    @"INSERT OR IGNORE INTO " kCDFaildMessageTable @"(" \
        kCDKeyId @","                                   \
        kCDKeyConversationId @","                       \
        kCDKeyMessage                                   \
    @") values (?, ?, ?) "                              \

#define kCDDeleteMessageSQL                             \
    @"DELETE FROM " kCDFaildMessageTable @" "           \
    @"WHERE " kCDKeyId " = ? "                          \

@interface CDFailedMessageStore ()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end

@implementation CDFailedMessageStore

+ (CDFailedMessageStore *)store {
    static CDFailedMessageStore *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[CDFailedMessageStore alloc] init];
    });
    return manager;
}

- (void)setupStoreWithDatabasePath:(NSString *)path {
    if (self.databaseQueue) {
        DLog(@"database queue not nil !!!!");
    }
    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:kCDCreateTableSQL];
    }];
}

- (NSDictionary *)recordFromResultSet:(FMResultSet *)resultSet {
    NSMutableDictionary *record = [NSMutableDictionary dictionary];
    NSData *data = [resultSet dataForColumn:kCDKeyMessage];
    AVIMTypedMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [record setObject:message forKey:kCDKeyMessage];
    [record setObject:[resultSet stringForColumn:kCDKeyId] forKey:kCDKeyId];
    return record;
}

- (NSArray *)recordsByConversationId:(NSString *)conversationId {
    NSMutableArray *records = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:kCDSelectMessagesSQL, conversationId];
        while ([resultSet next]) {
            [records addObject:[self recordFromResultSet:resultSet]];
        }
        [resultSet close];
    }];
    return records;
}

- (NSArray *)selectFailedMessagesByConversationId:(NSString *)conversationId {
    NSArray *records = [self recordsByConversationId:conversationId];
    NSMutableArray *messages = [NSMutableArray array];
    for (NSDictionary *record in records) {
        [messages addObject:record[kCDKeyMessage]];
    }
    return messages;
}

- (BOOL)deleteFailedMessageByRecordId:(NSString *)recordId {
    __block BOOL result;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:kCDDeleteMessageSQL, recordId];
    }];
    return result;
}

- (void)insertFailedMessage:(AVIMTypedMessage *)message {
    if (message.conversationId == nil) {
        [NSException raise:@"conversationId is nil" format:nil];
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:message];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:kCDInsertMessageSQL,message.messageId, message.conversationId, data];
    }];
}

@end
