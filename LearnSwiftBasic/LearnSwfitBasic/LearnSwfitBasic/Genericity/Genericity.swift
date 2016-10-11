//
//  Genericity.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/26.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

struct IntStack {
    var items = [Int]()
    
    mutating func push(item:Int){
        items.append(item)
    }
    
    mutating func poptoElement(item:Int) ->[Int]{
        
        
        let index = items.index(of: item)
        // 非数组中元素
        if index == nil {
            return items
        }
        
        // 保存当前位数  之后位数所有元素pop出栈
        let number = items.count - 1 - index!
        
        if number > 0 &&  number <= items.count {
            
            items.removeLast(number)
        }
        
        return items
    }
}


struct Stack<Element>{
    var items = [Element]()
    
    mutating func push(item:Element){
        items.append(item)
    }
    
    mutating func pop(item:Element) ->Element{
        return items.removeLast()
    }
}

// 关联类型
protocol container {
    
    associatedtype itemType
    mutating func append(_ item : itemType)
    var count:Int{get}
    subscript(i:Int) ->itemType{get}
}

struct  containerStuck:container{
    var items = [Int]()
    mutating func push(item:Int){
        items.append(item)
    }
    mutating func pop (item:Int) ->Int{
        return items.removeLast()
    }
    mutating func append(_ item: Int) {
        self.push(item: item)
    }
    
    var count:Int{
        return items.count
    }
    subscript(i:Int) ->Int{
        return items[i]
    }
}


class Genericity: NSObject {

    
    func printArr(arr:[String]){
        
        for obj in arr{
            print(obj)
        }
    }
    
    func printIntArr(arr:[Int]){
        for obj in arr{
            print(obj)
        }
    }
    
    func printFloatArr(arr:[Double]){
        for obj in arr{
            print(obj)
        }
    }
    
    func printAnyArr<type>(arr:[type]){
    
        for 元素 in arr {
            print(元素)
        }
    }
    
    var swiftDarNew = Stack<String>()
    
    var swiftInt = IntStack()
    
    
    func printStack(){
        swiftDarNew.push(item: "小马哥")
        swiftDarNew.push(item: "杀神")
        swiftDarNew.push(item: "杨叔")
        swiftDarNew.push(item: "鸟人")
        
        let cainiao = swiftDarNew.pop(item: "xiaobo")
        
        
        
        print(cainiao)
        print(swiftDarNew)
        
        swiftInt.push(item: 1)
        swiftInt.push(item: 2)
        swiftInt.push(item: 3)
        swiftInt.push(item: 4)
        swiftInt.push(item: 5)
        
        print(swiftInt)
        // pop 到某一个元素
        print(swiftInt.poptoElement(item: 2))
        
        
       print(searchLocation(textArr: ["刘备","张飞","关羽","孔明","赵云"], item: "孔明"))
    }
    
    func searchLocation<Element:Equatable>(textArr:[Element],item:Element) ->Int?{
        for(location,value) in textArr.enumerated(){
            if value == item {
                return location
            }
        }
        return nil
    }
    
    
}
