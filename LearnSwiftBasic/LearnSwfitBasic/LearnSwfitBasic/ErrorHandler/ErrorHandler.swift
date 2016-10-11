//
//  ErrorHandler.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/23.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

enum StudyPre:Error{
    case NoWay,DoNotLikeReading,NoStudyTool(tool :String)
}

class ErrorHandler: NSObject {
    
    func Foo() throws{
        print("丁文凯")
    }
    
    
    func iosDev(method:Bool ,way:Bool , tool:Bool) throws {
        guard method else {
            throw StudyPre.NoWay
        }
        
        guard way else {
            throw StudyPre.DoNotLikeReading
        }
        
        guard tool else {
            throw StudyPre.NoStudyTool(tool: "MacBook")
        }
    }
    
    var predict = 7000
    
    func buy(tool:String){
        if predict >= 6000 {
            predict -= 6000
            print("did buy tool \(predict)")
        }else{
            print("money is not enough")
        }
    }
    
    
    func dohandleError(index:Int){
        
        switch index {
        case 0:
        
            do {
                try? iosDev(method: true, way: true, tool: true)
                print("congratulations on your succes!")
            }catch StudyPre.NoWay {
                print("找小波")
            } catch StudyPre.DoNotLikeReading {
                print("看小波视频，斗鱼互动")
            } catch StudyPre.NoStudyTool(let mac) {
                buy(tool:mac)
            }

        case 1:
            
            do {
                try? Foo()
                print("foo")
                
            }
            
        default:
            print("")
            
        }
    }
    
}
