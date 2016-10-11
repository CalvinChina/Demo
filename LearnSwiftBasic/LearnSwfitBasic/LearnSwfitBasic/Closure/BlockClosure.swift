//
//  BlockClosure.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/21.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class BlockClosure: NSObject {
    
    var citys = ["上海","New York","London","北京","Tokyo"]
    
    func 倒序(a:String ,b:String) ->Bool{
        return a > b
    }
    
    func sort(){
    
        let city1 = citys.sorted(by:倒序)
        
        let city2 = citys.sorted { (a, b) -> Bool in
            return a > b
        }
        
        let city3 = citys.sorted{(a,b) in
             a > b
        }
        
    }
  

}
