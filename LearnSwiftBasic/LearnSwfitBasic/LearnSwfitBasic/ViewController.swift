//
//  ViewController.swift
//  LearnSwfitBasic
//
//  Created by pisen on 16/9/21.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var f1: CalvinFunctionOne!
    
    var enumrator:Enumrator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        f1 = CalvinFunctionOne()
//        
//        let z = f1.add(x:3,y:4)
//        
//        let a = f1.add(x: 100, y: -102)
//    
//        print("====\(a+z)")
//        print(f1.add(x: z, y: a))
//        
//        print (f1.add2(x:1,y:2,z:3))
//        
//       let b = f1.calculate(x: 2, y: 2, method:f1.multiply)
//        
//        print("f1.calculate(x: 2, y: 2, method:f1.multiply)===\(b)")
//    
//        let maxMin = f1.maxMin()
//        // 元组
//        print("\(maxMin)最大数值\(maxMin.0)最小数值\(maxMin.1)")
//        
        enumrator = Enumrator(tq:.多云)
//
//        print(enumrator.defaultRead())
//        
//        let jqtq  = enumrator.accurateWeather()
//        
//        switch jqtq {
//        case .晴(let uvi, let li, let desc):
//            print("紫外线指数:",uvi,"晾晒指数:", li, "天蓝程度:", desc)
//        case .霾(let cat, let index):
//            print("雾霾颗粒类别:", cat, "指数:", index)
//        default:
//            print("123")
//        }
        
//        print("",enumrator.accurateWeather(),"")
//        
//        let att = InstanceAttribute()
//        
//        print("att.AttributeOfRole()",att.AttributeOfRole())
//        
//        // block执行的代码块
//        att.soldier.returnBlockA = {
//            (a:Int,b:Int) -> String in
//            let c = a*100+b*200
//            return "\(a)*100+\(b)*200 = \(c)"
//        }
//        
//        att.AttributeOfLazyLoading(Tag: 5)
//        
//        let little = Initional(name:"小饼干")
//        
//        print(little.menu1.name)
        
//        let errorH = ErrorHandler()
//        
//        errorH.dohandleError(index: 0)
        
//       let fig =  DelegateDemo.createFigure(nickName:"小诚" ,realName:"李嘉诚")
//        
//        print("=====\(fig.nickName) =====\(fig.realName)")
        
        
//        let ex = Extension()
//        
//        ex.printSortByFirst()
//        ex.printInt()
    
        
        // 泛型
//        let text = ["1","2","3"]
//        let intArr = [1,2,3]
//        let floatArr = [1.1,2.2,3.3]
        
        let gen = Genericity()
        
//        gen.printArr(arr:text)
//        gen.printFloatArr(arr: floatArr)
//        gen.printIntArr(arr: intArr)
//        
//        gen.printAnyArr(arr: floatArr)
        
        gen.printStack()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

