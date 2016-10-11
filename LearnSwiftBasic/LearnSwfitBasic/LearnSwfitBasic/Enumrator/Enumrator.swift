//
//  Enumrator.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/22.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

enum 天气{
    case 晴
    case 阴
    case 雨
    case 霾
    case 冰雹
    case 雪
    case 雾
    case 多云
}

enum 精确天气 {
    case 晴(Int, Int, String)
    case 霾(String, Int)
}


class Enumrator: NSObject {
    var 今天的天气 = 天气.晴

    init(tq:天气) {
        今天的天气 = tq
    }
  
    
    func defaultRead() -> 天气{
      return 今天的天气
    }
    
    func accurateWeather() ->精确天气{
        return 精确天气.霾("PM10", 100)
    }
    
    
    
    

}
