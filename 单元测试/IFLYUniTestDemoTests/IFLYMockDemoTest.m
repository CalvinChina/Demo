//
//  IFLYMockDemoTest.m
//  IFLYUniTestDemo
//
//  Created by wkding on 2017/4/25.
//  Copyright © 2017年 wkding. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "Order.h"
#import "NSDictionary+JsonHelper.h"
#import "Connection.h"
#import "ViewController.h"
#import "OrderView.h"


#import "NetworkManager.h"

@interface IFLYMockDemoTest : XCTestCase
{
    Order *_order;
}
@end

@implementation IFLYMockDemoTest

- (void)setUp {
    [super setUp];
    
    NSDictionary * resultdict = @{@"audios":@[@{@"clientFile":@"/storage/emulated/0/iFlyAssistRecorder/SoundRecorder/20170320_101242_5c23362e082b41a8b72c938480888721.lyb",
                                                @"convertStatus":@2,
                                                @"convertedDuration":@2000,
                                                @"convertedFile":@"yyzx_hyzl/audio/62/LYZX20170320100002//storage/emulated/0/iFlyAssistRecorder/SoundRecorder/20170320_101242_5c23362e082b41a8b72c938480888721.lyb.wav",
                                                @"convertedSize":@64044,
                                                @"createTime":@1489975912000,
                                                @"id":@"11497",
                                                @"lastBlock":@1,
                                                @"orderId":@"LYZX20170320100002",
                                                @"originalDuration":@2000,
                                                @"originalFile":@"yyzx_hyzl/audio/62/LYZX20170320100002//storage/emulated/0/iFlyAssistRecorder/SoundRecorder/20170320_101242_5c23362e082b41a8b72c938480888721.lyb",
                                                @"originalSize":@6104,
                                                @"resultUploadStatus":@0,
                                                @"transEndTime":@1489975919000,
                                                @"transcriptStatus":@"-1",
                                                @"uploadStatus":@2,
                                                @"uploadTime":@1489975912000,}],
                                  @"companyId":@1000010,
                                  @"createTime":@1489975912000,
                                  @"id":@"LYZX20170320100002",
                                  @"name":@"4月18日 上午10:12",
                                  @"orderFrom":@1,
                                  @"status":@"-1",
                                  @"submitTime":@1489975915000,
                                  @"type":@2,
                                  @"userId":@62};
    
    _order = resultdict.json.order;
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//最简单的一个使用OCMock的例子
- (void)testPersonNameEqual{
    //创建一个mock对象
    id mockClass = OCMClassMock([Order class]);
    //可以给这个mock对象的方法设置预设的参数和返回值
    OCMStub([mockClass getName]).andReturn(@"4月18日 上午10:12");
    
    //用这个预设的值和实际的值进行比较是否相等
    XCTAssertEqualObjects([mockClass getName], [_order getName], @"值相等");
}

// 示例1 验证方法调用
- (void)testOCMVerify{
    ViewController * controller = [[ViewController alloc]init];
    //模拟出来一个网络连接请求数据的类
    id mockConnection = OCMClassMock([Connection class]);
    controller.connection = mockConnection;
    
    //模拟fetchData方法返回预设值
    Order *testOrder = [[Order alloc] init];
    testOrder.name = @"1234";
    Order *testOrder2 = [[Order alloc] init];
    testOrder2.name = @"4321";
    NSArray *orderArray = @[testOrder,testOrder2];
    OCMStub([mockConnection fetchData]).andReturn(orderArray);
    
    //模拟出来一个view类
    id mockView = OCMClassMock([OrderView class]);
    controller.orderView = mockView;
    
    // 这里执行updateOrderView之后，[mockView addOrder:]加入了testOrder和testOrder2
    [controller updateOrderView];
    
     //---------验证使用对应参数的方法是否被调用-----------
    // 成功
    OCMVerify([mockView addOrder:testOrder]);
    OCMVerify([mockView addOrder:testOrder2]);
    OCMVerify([mockView addOrder:[OCMArg any]]);
    
        
    // 失败 因为执行[controller updateOrderView];的时候，mockView没有添加testOrder3，所以验证不通过
//    Order *testOrder3 = [[Order alloc] init];
//    testOrder3.name = @"123";
//    OCMVerify([mockView addOrder:testOrder3]);
    
}


// 示例二
- (void)testOCMVerify2{
    ViewController * controller = [[ViewController alloc]init];
    //模拟出来一个网络连接请求数据的类
    id mockConnection = OCMClassMock([Connection class]);
    controller.connection = mockConnection;
    
    
//    [controller.connection fetchDataWihtBlock:^(NSDictionary *result, NSError *error) {
//        
//        
//        
//    }];
//    // 1. stub using OCMock andDo: operator.
//    OCMStub([mockConnection fetchDataWihtBlock:[OCMArg any]]).andDo((^(NSInvocation *invocation){
//        //2. declare a block with same signature
//        void (^weatherStubResponse)(NSDictionary *dict);
//        //3. link argument 3 with with our block callback
//        [invocation getArgument:&weatherStubResponse atIndex:3];
//        //4. invoke block with pre-defined input
//        NSDictionary *testResponse = @{@"high": @43 , @"low": @12};
//        
//        weatherStubResponse(mockConnection);
//    }));
//    
    
    //模拟fetchData2方法返回预设值
    Order *testOrder = [[Order alloc] init];
    testOrder.name = @"1234";
    Order *testOrder2 = [[Order alloc] init];
    testOrder2.name = @"4321";
    NSArray *orderArray = @[testOrder,testOrder2];
    OCMStub([mockConnection fetchData2]).andReturn(orderArray);
    
    //模拟出来一个view类
    id mockView = OCMClassMock([OrderView class]);
    controller.orderView = mockView;
    
    // 这里执行updateOrderView2之后，[mockView addOrder:]加入了testOrder和testOrder2
    [controller updateOrderVie2];
    
    //---------验证使用对应参数的方法是否被调用-----------
    // 成功
    OCMVerify([mockView addOrder:testOrder]);
    OCMVerify([mockView addOrder:testOrder2]);
    OCMVerify([mockView addOrder:[OCMArg any]]);
    

    // 失败 因为执行[controller updateOrderView2;的时候，mockView没有添加testOrder3，所以验证不通过
    //    Order *testOrder3 = [[Order alloc] init];
    //    testOrder3.name = @"123";
    //    OCMVerify([mockView addOrder:testOrder3]);
}


//例子3
- (void)testStrictMock3{
    
    id classMock = OCMClassMock([OrderView class]);
    //这个classMock需要执行addOrder方法且参数不为nil。  不然的话会抛出异常
    OCMExpect([classMock addOrder:[OCMArg isNotNil]]);
    OCMStub([classMock addOrder:[OCMArg isNotNil]]);
    
    /* 如果不执行以下代码的话会抛出异常 */
    Order *testOrder = [[Order alloc] init];
    testOrder.name = @"1234";
    [classMock addOrder:testOrder];
    
    OCMVerifyAll(classMock);
    
    
    /*-----------------------*/
//        id classMock = OCMStrictClassMock([OrderView class]);
//    //这个classMock需要执行addOrder方法且参数不为nil。  不然的话会抛出异常
////        OCMExpect([classMock addOrder:[OCMArg isNotNil]]);
////        OCMStub([classMock addOrder:[OCMArg isNotNil]]);
//    
//        Order *testOrder = [[Order alloc] init];
//        testOrder.name = @"1234";
//        [classMock addOrder:testOrder]; // this will throw an exception
//    
//        OCMVerifyAll(classMock);
}

- (void)testDelegateDemo {
    // mock 一个协议对象
    id mock = OCMProtocolMock(@protocol(AuthenticationDelegate));
    NSDictionary *returnDict = @{@"code":@"000001"};
    // 模拟替换调用方法 并给出预设回调数据
    OCMStub([mock onRequest:returnDict Type:AuthenticationTypeLogin]).andCall(self,@selector(onRequest:Type:));
    // mock 对象调用方法
    [mock onRequest:returnDict Type:AuthenticationTypeLogin];
}

- (void)onRequest:(NSDictionary *)info Type:(AuthenticationType)type{
    if (type == AuthenticationTypeLogin){
        if ([info[@"code"] isEqualToString:@"000000"]){
            NSLog(@"登录成功");
        }else{
            NSLog(@"登录失败");
        }
    }
}

- (void)testBlockMock {
    id networkClass = OCMClassMock([[NetworkManager sharedInstance] class]);
    
    //    OCMStub([networkClass shareInstance]).andReturn(networkClass);
    // 设置一个预定回调
    NSDictionary * dict = @{@"ErrCode":@""
                            ,@"ErrMsg":@""
                            ,@"IsError":@0
                            ,@"IsSuccess":@1
                            ,@"Message":@""
                            ,@"Offset":@"fj"
                            ,@"returnInfo":@"1"};
    // 模拟行为并设定预定回调值
    OCMStub([networkClass appCustomerOffset:([OCMArg invokeBlockWithArgs:dict,@(AuthenticationTypeOffset), nil]) phone:[OCMArg any]]);
    
    __block NSDictionary * resultDict;
    
    [networkClass appCustomerOffset:^(NSDictionary *returnDict,AuthenticationType type) {
        if (type == AuthenticationTypeOffset){
                resultDict = returnDict;
            NSLog(@"offset =====%@",resultDict[@"Offset"]);
        }
    } phone:[OCMArg any]];
    
    XCTAssertEqual(resultDict, dict);
    
        NSDictionary *loginReturnDict = @{@"code":@"200004",@"loginErrorCount":@"10"};
//    NSDictionary *loginReturnDict = @{@"code":@"000000",@"loginErrorCount":@"0"};
    [[networkClass stub] appDoLoginWithPhone:[OCMArg any] password:[OCMArg any] captcha:[OCMArg any] token:[OCMArg any] callBack:[OCMArg invokeBlockWithArgs:loginReturnDict,@(AuthenticationTypeLogin), nil]];
    
    [networkClass appDoLoginWithPhone:[OCMArg any] password:[OCMArg any] captcha:[OCMArg any] token:[OCMArg any] callBack:^(NSDictionary *returnDict,AuthenticationType type) {
        if (type == AuthenticationTypeLogin){
            if ([returnDict[@"code"] isEqualToString:@"000000"]){
                NSLog(@"=======登录成功");
            }else{
                if ([returnDict[@"loginErrorCount"] integerValue] >= 5){
                    NSLog(@"=======需要验证码");
                }else{
                    NSLog(@"=======不需要验证码");
                }
            }
        }else{
            NSLog(@"不是登录");
        }
    }];
    
}






- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
