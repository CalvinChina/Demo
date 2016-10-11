//
//  CalvinFunctionOne.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/21.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit


enum 怪物经验表:Int {
    case 骷髅 = 80, 跳舞骷髅 = 100, 骷髅叫兽 = 300
}

struct 服务器经验倍数 {
    var 开启 = false
    var 倍数 = 2
}

class 人民币玩家{
    var 经验值 = 0
    var 经验倍数 = 服务器经验倍数()
    
    func 挂机经验(){
        经验值 += 500
        print("挂机成功一次+\(经验值)")
    }
    
    func 打怪经验(怪物:怪物经验表,经验倍数:Int) {
        let 怪物经验值 = 怪物.rawValue
        self.经验值 += (怪物经验值  * 经验倍数)
        if self.经验倍数.开启 && self.经验倍数.倍数 > 1{
            经验值 *= self.经验倍数.倍数
        }
        print("当前打怪经验值是\(self.经验值)")
    }
    
    
    
}


class CalvinFunctionOne: NSObject {

    func add(x: Int ,y:Int) -> Int {
        return x + y
    }
    
    func maxMin() ->(Int,Int){
        return(Int.max ,Int.min)
    }
    
    func add2(x:Int ,y :Int, z:Int) -> Int{
        return x+y+z
    }
    
    func add3(x:Int, increment:Int = 2) ->Int{
        return x + increment
    }
    
    func calculate(x: Int, y: Int, method: (Int,Int)->Int ) -> Int {
        return method(x, y)
    }
    
    func multiply(x: Int, y: Int) -> Int {
        return x * y
    }

}
