//
//  IFLYUniTestDemoTests.m
//  IFLYUniTestDemoTests
//
//  Created by wkding on 2017/4/25.
//  Copyright © 2017年 wkding. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Order.h"
#import "NSDictionary+JsonHelper.h"
#import "MJExtension.h"
#import "NSObject+YYModel.h"
#import "JSONKit.h"

@interface IFLYUniTestDemoTests : XCTestCase
{
    Order *_order;
}
@property (nonatomic ,copy) NSString * jsonString;
@end

@implementation IFLYUniTestDemoTests

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
    
    _jsonString = [resultdict mj_JSONString];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    _order = nil;

    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

/**
 测试 NSDictionary+JsonHelper.h的json解析
 */
- (void)testJson{
    // 判断不为空 _order不为空时通过，反之不通过
    XCTAssertNotNil(_order);
    // 判断是否为真  当表达式值为TRUE时通过 否则不通过且展示对应信息(可不写)
    XCTAssertTrue([_order.name isEqualToString:@"4月18日 上午10:12"],@"解析错误1");
    XCTAssertTrue([_order.orderId isEqualToString:@"LYZX20170320100002"]);
}

- (void)testOfInnerJson{
    NSDictionary * dict = _order.audios[0];
    XCTAssertNotNil(dict);
    Audio *tempAudio =  dict.json.audio;
    XCTAssertNotNil(tempAudio);
    XCTAssertTrue([tempAudio.audioId isEqualToString:@"11497"]);
    XCTAssertEqualObjects(tempAudio.originalFile, @"yyzx_hyzl/audio/62/LYZX20170320100002//storage/emulated/0/iFlyAssistRecorder/SoundRecorder/20170320_101242_5c23362e082b41a8b72c938480888721.lyb");
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    // 10000 次 0.220 sec
    //            Order *dict = [Order modelWithJSON:_jsonString];

     // 测试性能例子
    [self measureBlock:^{
        // 需要测试性能的代码
        
        for (int i = 0 ; i < 100000 ;i ++){
            // 1000 次 0.018 sec 10000次 0.184 sec
//            NSDictionary *dict =  [_jsonString mj_JSONObject];
            
            // 1000 次 0.049 sec  10000次 0.489 sec  100000 5.024s
                NSDictionary *dict = [_jsonString objectFromJSONString];
        }
        
        // Put the code you want to measure the time of here.
    }];
}

@end
