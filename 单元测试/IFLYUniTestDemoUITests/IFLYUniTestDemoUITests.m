//
//  IFLYUniTestDemoUITests.m
//  IFLYUniTestDemoUITests
//
//  Created by wkding on 2017/4/25.
//  Copyright © 2017年 wkding. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface IFLYUniTestDemoUITests : XCTestCase

@end

@implementation IFLYUniTestDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}



//- (BOOL)exists;//判断该元素是否存在
//- (XCUIElementQuery *)descendantsMatchingType:(XCUIElementType)type;//取某种类型的元素以及它的子类集合
//- (XCUIElementQuery *)childrenMatchingType:(XCUIElementType)type;//取某种类型的元素集合，不包含它的子类
//
////交互类方法
//- (void)tap;//单击,还能使testField获得焦点
//- (void)doubleTap;//双击
//- (void)swipeUp;//pan手势
//- (void)typeText:(NSString *)text;//输入文字
//- (void)pressForDuration:(NSTimeInterval)duration;//长按

- (void)testLogin{
    //XCUIApplication 这是应用的代理，他能够把你的应用启动起来，并且每次都在一个新进程中。
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    //XCUIElement 这是 UI 元素的代理。元素都有类型和唯一标识。可以结合使用来找到元素在哪里，如当前界面上的一个输入框
    XCUIElement *phoneTextField = app.textFields[@"phone"];
//    XCUIElement *phoneTextField = [app.textFields elementMatchingType:XCUIElementTypeTextField identifier:@"loginPhone"];
    [phoneTextField tap];
    [phoneTextField typeText:@"13881747578"];

    XCUIElement *passwordTextField = app.textFields[@"password"];
    [passwordTextField tap];
    [passwordTextField typeText:@"123456"];
    
    
    [app.buttons[@"Login"] tap];
    
    // 开始一段延时，由于真实的登录是联网请求，所以不能直接获得结果，demo通过延时的方式来模拟联网请求
//    let window = app.windows.elementAtIndex(0)
    XCUIElement *window = [app.windows elementBoundByIndex:0];
    // 延时3秒, 3秒后如果登录成功，则自动进入信息页面，如果登录失败，则弹出警告窗
    [window pressForDuration:3];
    
    //    if ([app.alerts count] > 0){
    XCUIElement *clearButton = app.buttons[@"Clear"];
    [clearButton tap];
    
    [phoneTextField tap];
    [phoneTextField typeText:@""];
    
    [passwordTextField tap];
    [passwordTextField typeText:@""];
    
    [app.buttons[@"Login"] tap];
    [window pressForDuration:3];
    
    //登录成功后的控制器的title为loginSuccess，只需判断控制器的title时候一样便可判断登录是否成功
    XCTAssertEqualObjects(app.navigationBars.element.identifier, @"手机号不为空");
//    }else{
//    
//    }
}




@end
