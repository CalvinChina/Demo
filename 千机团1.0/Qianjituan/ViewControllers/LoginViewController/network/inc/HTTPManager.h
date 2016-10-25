//
//  httpConnection.h
//  vContact
//
//  Created by apple on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TaskStateType
{
    EReceiveResponse = 0,
    EReceiveData,
    EReceiveDataFinish,
    EReceiveError
};

@protocol HTTPDelegate

-(void) url: (NSString*)url didReceiveResponse: (NSURLResponse *)response;
-(void) url: (NSString*)url didReceiveData: (NSData *)receivedData;
-(void) url: (NSString*)url didFailWithError: (NSError *)error;
-(void) url: (NSString*)url didFinishLoading: (NSData*)data;

@end

@interface HTTPManager: NSObject
{
@private
    NSURL* mUrl;
    
    NSURLConnection* mUrlConnection;
    
    NSThread* mThread;
    
    NSMutableData* mResultData;
    
    id<HTTPDelegate> mDelegate;
    
    Boolean mIsNetWorkAvailable;
    
    Boolean mIsThreadNeedExit;
}

-(Boolean) openURL: (NSString*)url
       delegate: (id<HTTPDelegate>)delegate;

-(void) destroy;

@end
