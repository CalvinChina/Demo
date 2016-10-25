//
//获取路由地址
//作者(曾必兴)，日期(2014-07-02)
//

#import "RouteAddress.h"
#import "AsyncUdpSocket.h"
#import "getgateway.h"
#import <arpa/inet.h>

#import <ifaddrs.h>
#import <ifaddrs.h>

@interface RouteAddress (){
    
    AsyncUdpSocket *ssdpSock;
}

@end

@implementation RouteAddress

- (void)discoverDevices {
    
    self.hostRoute = nil;

    struct in_addr addr;
    
    int a = getdefaultgateway(&(addr.s_addr));
    
    NSString *aa =  [NSString stringWithUTF8String:inet_ntoa(addr)];
    
    //这里如果能用c语言获取到 则不用广播
    if (a == 0&&[aa length] > 5) {
        
        self.hostRoute = aa;
        
        if (_delegate&&[_delegate respondsToSelector:@selector(routeAddressCallBack:)]) {
            
            [_delegate routeAddressCallBack:self.hostRoute];
        }
        
        return;
    }
    
    
	ssdpSock = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
	[ssdpSock enableBroadcast:TRUE error:nil];
    
	NSString *str = @"M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX:3\r\nST: urn:schemas-upnp-org:device:InternetGatewayDevice:1\r\n\r\n";
	
	[ssdpSock bindToPort:0 error:nil];
    
	[ssdpSock joinMulticastGroup:@"239.255.255.250" error:nil];
    
	[ssdpSock sendData:[str dataUsingEncoding:NSUTF8StringEncoding]  toHost:@"239.255.255.250" port:1900 withTimeout:3 tag:1];
    
	[ssdpSock receiveWithTimeout:-1 tag:2];
    
	[NSTimer scheduledTimerWithTimeInterval:5 target: self
								   selector:@selector(completeSearch:) userInfo: self repeats: NO];
}


-(void) completeSearch: (NSTimer *)t {
    
	[ssdpSock close];
    
	ssdpSock = nil;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    
    NSLog(@"2222");

}


- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    
    self.hostRoute = host;
    
    if (_delegate&&[_delegate respondsToSelector:@selector(routeAddressCallBack:)]) {
        
        [_delegate routeAddressCallBack:host];
    }
    
    NSLog(host);
	NSString *aStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"%@",aStr);
    //	return YES;
	NSLog(@"%@", @"didNotSendDataWithTag");
	return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error {
    
    NSLog(@"111");
}

//- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock {
//    
//    NSLog(@"3333");
//}

@end
