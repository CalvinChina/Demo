//
//  Initional.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/22.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class Food{
    var name:String
    init(name:String) {
        self.name = name
    }
    
    convenience init(){
        self.init(name:"默认名字的食物")
    }
}

class Menu:Food{
    var count:Int
    init(name:String ,count:Int) {
        self.count = count
        super.init(name: name)
    }
    
    convenience override init(name:String) {
        self.init(name:name,count:1)
    }
}





class Initional: NSObject {

    var menu1:Menu!

    init(name:String) {
        if name.isEmpty {
            menu1 = Menu(name:name ,count:2)
        }
        menu1 = Menu(name:name ,count:2)
        
    }
}
