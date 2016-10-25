//
//获取路由地址
//作者(曾必兴)，日期(2014-07-02)
//

#import <Foundation/Foundation.h>

@protocol RouteAddressDelegate;

@interface RouteAddress : NSObject

@property (nonatomic, retain) NSString *hostRoute;

@property (assign) id<RouteAddressDelegate> delegate;

//获取路由地址
- (void)discoverDevices;

@end

@protocol RouteAddressDelegate <NSObject>

//回调代理
//str:地址
- (void)routeAddressCallBack:(NSString *)str;

@end