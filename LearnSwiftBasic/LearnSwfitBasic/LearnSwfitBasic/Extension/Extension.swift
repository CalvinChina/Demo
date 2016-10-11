//
//  Extension.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/26.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

extension String{
    //
}

extension Array{

    func sortByFirtst(arr:Array) -> Array{
        
        return arr
    }
    
}

// 对整数加从右往左的索引下标
extension Int {
    subscript(index: Int) -> Int {
        var base = 1
        
        for _ in 1...index {
            base *= 10
        }
        
        return self / base % 10
    }
}

extension Int {
    enum Kind {
        case 正,负,零
    }
    
    var 正负类型: Kind {
        switch self {
        case 0:
            return .零
        case  let x where x > 0:
            return .正
        default:
            return .负
        }
    }
}


class Extension: NSObject {
    let array2 =  Array(1...10)
    
    func printSortByFirst(){
            print(array2 .sortByFirtst(arr: array2))
    }
    
    
    
    func printInt(){
        print(123456789[2])
        
        let 整数组 = [3, 4, 0 , -5]
        var 整数组类型 = [String]()
        
        for 整数 in 整数组 {
            var 符号: String
            
            switch 整数.正负类型 {
            case .正:
                符号 = "+"
            case .负:
                符号 = "-"
            default:
                符号 = "0"
            }
            
            整数组类型.append(符号)
        }
        
        print(整数组类型)
    }
    
}
