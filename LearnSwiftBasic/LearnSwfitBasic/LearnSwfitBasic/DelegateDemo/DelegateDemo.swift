//
//  DelegateDemo.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/23.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

protocol docuentDelegate{
    var  readWrite: Int{get set}
    var  readOnly:  Int{get}
}

protocol liveLink {
    static var link: String{get}
}


protocol wholeName {
    var firstName:  String{get}
    var lastName:   String{get}
}


struct student:wholeName {
    var firstName: String
    var lastName: String
}


class Figure:wholeName  {
    var nickName:String!
    var realName:String!
    
    init(nickName:String ,realName:String) {
        self.nickName = nickName
        self.realName = realName
    }
    
    var firstName: String{
        return nickName ?? ""
    }
    var lastName: String{
        return realName
    }

}




class DelegateDemo: NSObject {
    
    func createStudent(firstName:String ,lastName:String){
        let student1 = student(firstName:firstName , lastName:lastName)
        
        print("student1====\(student1.firstName)\(student1.lastName)")
    }
    
    static func createFigure(nickName:String,realName:String) ->Figure{
        let fig = Figure(nickName:nickName , realName:realName)
       return fig
    }
    
    
    func createArray(){
        let array : [Int]
        array = [Int](repeatElement(3, count: 10))
        
        let array2 =  Array(1...10)
        
        var place = ["beijing","shanghai","guangzhou","shenzhen"]
        
        place.count
        
        place.isEmpty
        
        place.append("wuhan")
        
        let haiwaiPlace = ["NewYork","London","Sao Paolu"]
        
        place += haiwaiPlace
        
        place.insert("Paris", at: 4)
        
        place.remove(at:8)
    }
    // 无序不可重合
    func createSet(){
        var cardno :Set = [1,2,3]
        
        var citys:Set =  ["beijing","shanghai","guangzhou","shenzhen"]
        
        citys.insert("hef")
        
        let cityArray = citys.sorted()
        
        
        var x:Set = [1,2,3,4]

        let y:Set = [1,3,5,7]
        // 交集
        print("交集:",x.intersection(y))
        
        print("差集:",x.subtract(y))
        
        print("并集:",x.union(y))
        
        print("补集:",x.symmetricDifference(y))
        
        let h :Set = [1,2,3]
        let i :Set = [3,2,4,1]
        
        if h == i  {
            
        }else{
            print("不等于")
        }
        
        
       print("是否是子集 && 严格子集", h.isSubset(of: i),h.isStrictSubset(of: i))
        
       print("是否是父集 && 严格父集",i.isSuperset(of: h),i.isStrictSuperset(of: h))
         //无交集
        //h.isDisjoint(with: i)
        
        
    }
    
    
}
