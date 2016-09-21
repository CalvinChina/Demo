//
//  EncryptManager.swift
//  Swift3Demo
//
//  Created by pisen on 16/9/14.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

@objc protocol EncryptManagerDelegate {
    @objc optional func encrypt();
    func decrypt();
}


private let manager = EncryptManager()

class EncryptManager: NSObject {
    
    var encryptArr:NSMutableArray!
    var encryptStr:NSString!
    
    class var sharedManager: EncryptManager {
        return manager;
    }

    func encryptStrings(str:String) -> String {
        
        let result :String = str.appending("123456")
        return result
    }
    
    
    private func encryptMethod(str:String) -> String{
        let result: String = str.appending("123456")
        
        return result
    }
}

