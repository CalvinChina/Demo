//
//  httpConnection.m
//  vContact
//
//  Created by apple on 11-10-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager

- (id)init
{
    self = [super init];
    
    if(self != nil)
    {
        [self initDefaultValue];
    }
    
    return self;
}

-(void) initDefaultValue
{
    mIsNetWorkAvailable = YES;
}

-(BOOL) isURLIllegal:(NSString*)url
{
    if(url == nil)
    {
        return NO;
    }
    
    if([url hasPrefix:@"http://"] ||
       [url hasPrefix:@"HTTP://"])
    {
        return YES;
    }
    
    return NO;
}

- (Boolean) isStrNeedUTF8Encode: (NSString*)srcStr
{
    if(srcStr == nil ||
       srcStr.length <= 0)
    {
        return NO;
    }
    
    for(int i = 0; i < srcStr.length; i++)
    {
        int singleChar = [srcStr characterAtIndex: i];
        
        if(singleChar > 0x4e00 &&
           singleChar < 0x9fff)
        {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL) openURL: (NSString *)url
       delegate: (id<HTTPDelegate>) delegate
{
    if([self isURLIllegal:url] == NO)
    {
        return NO;
    }
    
    if([self isStrNeedUTF8Encode: url])
    {
        NSString* encodedString =
        [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        if(encodedString == nil ||
           encodedString.length <= 0)
        {
            return NO;
        }
        
        mUrl = [[NSURL alloc] initWithString: encodedString];
    }
    else
    {
        mUrl = [[NSURL alloc] initWithString: url];
    }
    
    mDelegate = delegate;
    
    if(mThread != nil)
    {
        mIsThreadNeedExit = YES;
        
        while(mThread != nil)
        {
            [NSThread sleepForTimeInterval: 0.25];
        }
    }
    
    mThread = [[NSThread alloc] initWithTarget: self
                                      selector: @selector(httpThreadFunc)
                                        object: nil];
    
    if(mThread != nil)
    {
        [mThread start];
        
        return YES;
    }
    
    return NO;
}

-(void)httpThreadFunc
{
    if(mUrl == nil)
    {
        return;
    }
    
    mIsThreadNeedExit = NO;
    
    @autoreleasepool
    {
        NSURLRequest* request = [NSURLRequest requestWithURL: mUrl];
        
        mUrlConnection =
        [NSURLConnection connectionWithRequest: request
                                      delegate: self];
        
        if(mUrlConnection != nil)
        {
            [mUrlConnection scheduleInRunLoop: [NSRunLoop currentRunLoop]
                                      forMode: NSDefaultRunLoopMode];
            
            [mUrlConnection start];
        }
        
        while(YES)
        {
            if(mIsThreadNeedExit)
            {
                if(mUrlConnection != nil)
                {
                    [mUrlConnection cancel];
                    
                    [mUrlConnection unscheduleFromRunLoop: [NSRunLoop currentRunLoop]
                                                  forMode: NSDefaultRunLoopMode];
                }
                
                break;
            }
            
            [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode
                                     beforeDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
        }
    }
    
    if(mThread != nil)
    {
        [mThread cancel];
        
        mThread = nil;
    }
}

#pragma mark URL connection delgate start

-(void) connection: (NSURLConnection *)theConnection
didReceiveResponse: (NSURLResponse *)response
{
    if(response == nil)
    {
        return;
    }
    
    NSLog(@"Response: %@", [response description]);
    
    if(mIsThreadNeedExit)
    {
        return;
    }
    
    mResultData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)data
{
    if(data == nil)
    {
        return;
    }
    
//    NSLog(@"Received data");
    
    if(mIsThreadNeedExit)
    {
        return;
    }
    
    if(mDelegate == nil)
    {
        return;
    }
    
    data = [[NSData alloc] initWithData: data];
    
    [mResultData appendData: data];
}

- (void)connection: (NSURLConnection *)theConnection
  didFailWithError: (NSError *)error
{
    if(error == nil)
    {
        return;
    }
    
    NSLog(@"Error: %@", [error description]);
    
    if(mIsThreadNeedExit)
    {
        return;
    }
    
    mUrlConnection = nil;
    
    mIsThreadNeedExit = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
    NSLog(@"FinishDataLoading: --------");
    
    if(mIsThreadNeedExit)
    {
        return;
    }
    
    mUrlConnection = nil;
    
    mIsThreadNeedExit = YES;
    
    [mDelegate url: mUrl.absoluteString didReceiveData: mResultData];
}

@end
