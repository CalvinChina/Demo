//
//  InstanceAttribute.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/22.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class role{
    let userId = "xm1993"
    var money = 99999
}

class 地图 {
    var fileName = "死亡沙漠.map"
}

typealias funcBlockA = (Int,Int) -> String

class 战士:role{
    lazy var 打怪地图 = 地图()
    var 进入副本 = false
    
    var returnBlockA:funcBlockA?

}



class InstanceAttribute: NSObject {
    
    let 小明 = role()
    
    let soldier = 战士()
 
    func AttributeOfRole() -> (userId:String, money: Int){
        return(小明.userId,小明.money)
    }

    func AttributeOfLazyLoading(Tag:Int) -> String{
     
        if !soldier.进入副本 {
            print(soldier.打怪地图)
               
             if soldier.returnBlockA != nil {
                
                let result = soldier.returnBlockA!(7,8)
                
                print("soldier.returnBlockA",result)
            }
        }
        
        return ""
    }
 
    
    

}
